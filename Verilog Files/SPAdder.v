module SPAdder(input[31:0] SP,
                output reg[31:0]Out,output reg Cout );

always @* begin
  {Cout,Out}=SP+1;
end

endmodule
