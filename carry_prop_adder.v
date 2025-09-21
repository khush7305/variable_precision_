module carry_prop_adder(
input [10:0] in1,
input [10:0] in2,
output [10:0] sum
    );
    wire [11:0]in3;
    assign in3[0] = 0;
    fullAdder fa0(.a(in1[0]),.b(in2[0]),.c(in3[0]),.sum(sum[0]),.cout(in3[1]));
    fullAdder fa1(.a(in1[1]),.b(in2[1]),.c(in3[1]),.sum(sum[1]),.cout(in3[2]));
    fullAdder fa2(.a(in1[2]),.b(in2[2]),.c(in3[2]),.sum(sum[2]),.cout(in3[3]));
    fullAdder fa3(.a(in1[3]),.b(in2[3]),.c(in3[3]),.sum(sum[3]),.cout(in3[4]));
    fullAdder fa4(.a(in1[4]),.b(in2[4]),.c(in3[4]),.sum(sum[4]),.cout(in3[5]));
    fullAdder fa5(.a(in1[5]),.b(in2[5]),.c(in3[5]),.sum(sum[5]),.cout(in3[6]));
    fullAdder fa6(.a(in1[6]),.b(in2[6]),.c(in3[6]),.sum(sum[6]),.cout(in3[7]));
    fullAdder fa7(.a(in1[7]),.b(in2[7]),.c(in3[7]),.sum(sum[7]),.cout(in3[8]));
    fullAdder fa8(.a(in1[8]),.b(in2[8]),.c(in3[8]),.sum(sum[8]),.cout(in3[9]));
    fullAdder fa9(.a(in1[9]),.b(in2[9]),.c(in3[9]),.sum(sum[9]),.cout(in3[10]));
    fullAdder fa10(.a(in1[10]),.b(in2[10]),.c(in3[10]),.sum(sum[10]),.cout(in3[11]));
endmodule
    
module fullAdder(
    input a,    
    input b,
    input c,
    output sum,
    output cout
);
assign sum = a^b^c;
assign cout = (a&b) | (a&c) | (b&c);
endmodule