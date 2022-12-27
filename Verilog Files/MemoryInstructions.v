module Ldm(input[15:0] ImmediateValue,input Enable,output reg[15:0] Out);
always@* begin
if(Enable == 1'b1) begin
Out = ImmediateValue;
end else begin
Out = 16'bz;
end
end
endmodule
module Sw(input[15:0] ImmediateValue,input Enable,output reg[15:0] Out);
always@* begin
if(Enable == 1'b1) begin
Out = ImmediateValue;
end else begin
Out = 16'bz;
end
end
endmodule
module LDD(input[15:0] Rs,input Enable,output reg[15:0] Out);
always@* begin
if(Enable == 1'b1) begin
Out = Rs;
end 
else begin
Out = 16'bz;
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

module PUSH(input[15:0] Rds,input Enable,output reg[15:0] Out);
always@* begin
if(Enable == 1'b1) begin
Out = Rds;
end else begin
Out = 16'bz;
end
end
endmodule