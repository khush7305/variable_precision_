`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2025 11:30:38 AM
// Design Name: 
// Module Name: normalization
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


module normalization(
    input [10:0] mantissa_i,
    input [9:0] exponent_i,
    output reg [9:0]exponent,
    output reg [10:0]mantissa
    );
always @(*) begin
    if(mantissa_i[10] == 1'b1)begin
        assign exponent = exponent_i + 1'd1;
        assign mantissa = mantissa_i >> 1;
    end
    else begin
        assign exponent = exponent_i;
        assign mantissa = mantissa_i;
    end
end
endmodule
