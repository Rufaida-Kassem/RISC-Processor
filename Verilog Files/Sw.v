module Sw(input[15:0] ImmediateValue,input Enable,output reg[15:0] Out);
  always@*
  begin
    if(Enable == 1'b1)
    begin
      Out = ImmediateValue;
    end
    else
    begin
      Out = 16'bz;
    end
  end
endmodule
