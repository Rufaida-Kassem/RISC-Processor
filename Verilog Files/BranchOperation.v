module jumpConditionallyZero(input[2:0] flag,input Enable,output reg [2:0]flagChanged,output reg signalJump);
always @* begin
if(Enable) begin
signalJump = (flag[0] == 1'b1) ? 1'b1:1'b0;
flagChanged[0]= 1'b0;
flagChanged[1]= flag[1];
flagChanged[2]= flag[2];
end else begin	
signalJump = 1'bz;
flagChanged=3'bz;
end
end
endmodule
module jumpConditionallyNegative(input[2:0] flag,input Enable,output reg [2:0]flagChanged,output reg signalJump);
always @* begin
if(Enable) begin
signalJump = (flag[1] == 1'b1) ? 1'b1:1'b0;
flagChanged[1]= 1'b0;
flagChanged[0]= flag[0];
flagChanged[2]= flag[2];
end else begin	
signalJump = 1'bz;
flagChanged=3'bz;
end
end
endmodule
module jumpConditionallyCarry(input[2:0] flag,input Enable,output reg [2:0]flagChanged,output reg signalJump);
always @* begin
if(Enable) begin
signalJump = (flag[2] == 1'b1) ? 1'b1:1'b0;
flagChanged[2]= 1'b0;
flagChanged[0]= flag[0];
flagChanged[1]= flag[1];
end else begin	
signalJump = 1'bz;
flagChanged=3'bz;
end
end
endmodule