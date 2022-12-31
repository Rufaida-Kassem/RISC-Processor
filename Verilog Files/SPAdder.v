module SPAdder(input[31:0] SP,input[4:0]OpCode,
                output reg[31:0]Out );

always @* begin
  if(OpCode==5'b01111)begin
Out=SP+1;
  end
   else if(OpCode==5'b10000)begin
Out=SP-1;
  end
end

endmodule
