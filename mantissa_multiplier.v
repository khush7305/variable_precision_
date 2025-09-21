`timescale 1ns / 1ps

module mantissa_multiplier (
    input  [10:0] mask,
    input  [ 7:0] manta,  // multiplicand
    input  [ 7:0] mantb,  // multiplier
    output [10:0] mults,  // carry-save sum
    output [10:0] multc   // carry-save carry
);

  wire [2:0] booth_sel[3:0];
  wire [10:0] pp[3:0];
  wire [10:0] pp_shifted[3:0];

  wire [10:0] l1_sum_01, l1_carry_01;
  wire [10:0] l1_sum_23, l1_carry_23;
  wire [10:0] l2_sum, l2_carry;

  assign booth_sel[0] = {mantb[1:0], 1'b0};
  assign booth_sel[1] = mantb[3:1];
  assign booth_sel[2] = mantb[5:3];
  assign booth_sel[3] = mantb[7:5];

  // partial product generation
  booth_encoder be0 (
      .multiplicand(manta),
      .booth_sel(booth_sel[0]),
      .partial_product(pp[0])
  );
  booth_encoder be1 (
      .multiplicand(manta),
      .booth_sel(booth_sel[1]),
      .partial_product(pp[1])
  );
  booth_encoder be2 (
      .multiplicand(manta),
      .booth_sel(booth_sel[2]),
      .partial_product(pp[2])
  );
  booth_encoder be3 (
      .multiplicand(manta),
      .booth_sel(booth_sel[3]),
      .partial_product(pp[3])
  );


  assign pp_shifted[0] = pp[0];
  assign pp_shifted[1] = pp[1] << 2;
  assign pp_shifted[2] = pp[2] << 4;
  assign pp_shifted[3] = pp[3] << 6;

  // level 1
  csa_11bit csa_l1_01 (
      .a(pp_shifted[0]),
      .b(pp_shifted[1]),
      .c(11'b0),
      .mask(mask),
      .sum(l1_sum_01),
      .carry(l1_carry_01)
  );

  csa_11bit csa_l1_23 (
      .a(pp_shifted[2]),
      .b(pp_shifted[3]),
      .c(11'b0),
      .mask(mask),
      .sum(l1_sum_23),
      .carry(l1_carry_23)
  );

  // level 2
  csa_11bit csa_l2 (
      .a(l1_sum_01),
      .b(l1_sum_23),
      .c({l1_carry_01[9:0], 1'b0}),
      .mask(mask),
      .sum(l2_sum),
      .carry(l2_carry)
  );

  wire [10:0] final_sum, final_carry;
  csa_11bit csa_final (
      .a(l2_sum),
      .b({l1_carry_23[9:0], 1'b0}),
      .c({l2_carry[9:0], 1'b0}),
      .mask(mask),
      .sum(final_sum),
      .carry(final_carry)
  );

  assign mults = final_sum;
  assign multc = final_carry;

endmodule

module csa_11bit (
    input  [10:0] a,
    input  [10:0] b,
    input  [10:0] c,
    input  [10:0] mask,
    output [10:0] sum,
    output [10:0] carry
);
  genvar i;
  generate
    for (i = 0; i < 11; i = i + 1) begin : csa_bit
      assign sum[i]   = mask[i] ? (a[i] ^ b[i] ^ c[i]) : 1'b0;
      assign carry[i] = mask[i] ? ((a[i] & b[i]) | (b[i] & c[i]) | (a[i] & c[i])) : 1'b0;
    end
  endgenerate
endmodule


module booth_encoder (
    input [7:0] multiplicand,
    input [2:0] booth_sel,
    output reg [10:0] partial_product
);

  wire [10:0] pos_1x, pos_2x;
  wire [10:0] neg_1x, neg_2x;

  assign pos_1x = {3'b000, multiplicand};
  assign pos_2x = {2'b00, multiplicand, 1'b0};
  assign neg_1x = ~pos_1x + 1'b1;
  assign neg_2x = ~pos_2x + 1'b1;

  always @(*) begin
    case (booth_sel)
      3'b000:  partial_product = 11'b0;  // 0
      3'b001:  partial_product = pos_1x;  // +1M
      3'b010:  partial_product = pos_1x;  // +1M
      3'b011:  partial_product = pos_2x;  // +2M
      3'b100:  partial_product = neg_2x;  // -2M
      3'b101:  partial_product = neg_1x;  // -1M
      3'b110:  partial_product = neg_1x;  // -1M
      3'b111:  partial_product = 11'b0;  // 0
      default: partial_product = 11'b0;
    endcase
  end

endmodule
