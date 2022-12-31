module SPAdder(input[31:0] SP,
    input stack,
    input MemWR,   //push
    input MemR,    //pop       
    output reg[31:0]Out
     );

always @* begin
  if(stack)
  begin
    if(MemWR)
        Out = SP - 1;
    else if(MemR)
        Out = SP + 1;
  end
end

endmodule
