module Not(input[15:0] Rs,input Enable,output reg[15:0] Out,output reg[2:0] Ccr);
always@* begin
if(Enable == 1'b1) begin
Out = ~Rs;
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
Ccr = 3'bz;
end
end
endmodule
