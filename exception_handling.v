`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2025 12:39:27 PM
// Design Name: 
// Module Name: exception_handling
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module exception_handling(
    input [9:0] expt_pd,
    input [10:0] mantissa_pd,
    input Spd,
    output reg [15:0] Product
    );
    reg [7:0]result_exp;
    reg [6:0]result_manti;
    wire [9:0] mantissa_pd_low;
    assign mantissa_pd_low = mantissa_pd[9:0];
    wire signed [9:0] expt_pd_s;
    assign expt_pd_s = expt_pd;
    always @* begin
    result_exp   = expt_pd[7:0];
    result_manti = mantissa_pd[16:10];

    // overflow
    if (expt_pd_s > 10'sd255) begin
      result_exp   = 8'hFF;
      result_manti = 7'b0000000;
    end  // underflow
    else if (expt_pd_s < 10'sd0) begin
      result_exp   = 8'h00;
      result_manti = 7'b0000000;
    end
  end
always @* begin
    Product = {Spd, result_exp, result_manti};
  end
endmodule
