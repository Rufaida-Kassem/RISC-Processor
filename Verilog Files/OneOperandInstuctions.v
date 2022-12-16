module Not(input[15:0] Rds,input Enable,output reg[15:0] Out,output reg[2:0] Ccr);
always@* begin
if(Enable == 1'b1) begin
Out = ~Rds;
//Assign zero flag to one if out is zeros
if(Out == 15'b0) begin
Ccr[0] = 1'b1;
end else begin
Ccr[0] = 1'b0;
end
//Assign negative flag to one if out is less than zero
if(Out[15] == 1'b1) begin
Ccr[1] = 1'b1;
end else begin
Ccr[1] = 1'b0;
end
end else begin
Out = 16'bz;
end
end
endmodule

module SETC(input Enable,output reg[2:0] Ccr);
always@* begin
if(Enable == 1'b1) begin
Ccr[2]=1;
end
end
endmodule

module CLRC(input Enable,output reg[2:0] Ccr);
always@* begin
if(Enable == 1'b1) begin
Ccr[2]=0;
end
end
endmodule

module INC(input[15:0] Rds,input Enable,output reg[15:0] Out,output reg[2:0] Ccr);
always@* begin
if(Enable == 1'b1) begin
Out = Rds+1;
//Assign zero flag to one if out is zeros
if(Out == 15'b0) begin
Ccr[0] = 1'b1;
end else begin
Ccr[0] = 1'b0;
end
//Assign negative flag to one if out is less than zero
if(Out[15] == 1'b1) begin
Ccr[1] = 1'b1;
end else begin
Ccr[1] = 1'b0;
end
end else begin
Out = 16'bz;
end
end
endmodule

module DEC(input[15:0] Rds,input Enable,output reg[15:0] Out,output reg[2:0] Ccr);
always@* begin
if(Enable == 1'b1) begin
Out = Rds-1;
//Assign zero flag to one if out is zeros
if(Out == 15'b0) begin
Ccr[0] = 1'b1;
end else begin
Ccr[0] = 1'b0;
end
//Assign negative flag to one if out is less than zero
if(Out[15] == 1'b1) begin
Ccr[1] = 1'b1;
end else begin
Ccr[1] = 1'b0;
end
end else begin
Out = 16'bz;
end
end
endmodule
module OUT(input[15:0] Rds,input Enable,output reg[15:0] Out);
always@* begin
if(Enable == 1'b1) begin
Out = Rds;
end
else begin
Out = 16'bz;
end
end
endmodule
module IN(input[15:0] Rds,input Enable,output reg[15:0] Out);
always@* begin
if(Enable == 1'b1) begin
Out = Rds;
end
else begin
Out = 16'bz;
end
end
endmodule