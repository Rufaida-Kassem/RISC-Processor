module Ldm(input[15:0] ImmediateValue,input Enable,input [2:0]previousflags,output reg[15:0] Out,output reg [2:0] Ccr);
always@* begin
if(Enable == 1'b1) begin
Out = ImmediateValue;
Ccr = previousflags;
end else begin
Out = 16'bz;
Ccr = 3'bz;
end
end
endmodule
module Sw(input[15:0] ImmediateValue,input Enable,input [2:0]previousflags,output reg[15:0] Out,output reg [2:0] Ccr);
always@* begin
if(Enable == 1'b1) begin
Out = ImmediateValue;
Ccr = previousflags;
end else begin
Out = 16'bz;
Ccr = 3'bz;
end
end
endmodule
module LDD(input[15:0] Rs,input Enable,input [2:0]previousflags,output reg[15:0] Out,output reg [2:0] Ccr);
always@* begin
if(Enable == 1'b1) begin
Out = Rs;
Ccr = previousflags;
end 
else begin
Out = 16'bz;
Ccr = 3'bz;
end
end
endmodule
// module POP(input[15:0] Rds,input Enable,output reg[15:0] Out);
// always@* begin
// if(Enable == 1'b1) begin
// Out = Rds;
// end else begin
// Out = 16'bz;
// end
// end
// endmodule

module PUSH(input[15:0] Rds,input Enable,input [2:0]previousflags,output reg[15:0] Out,output reg [2:0] Ccr);
always@* begin
if(Enable == 1'b1) begin
Out = Rds;
Ccr = previousflags;
end else begin
Out = 16'bz;
Ccr = 3'bz;
end
end
endmodule