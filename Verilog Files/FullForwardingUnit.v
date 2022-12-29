module FullForwardingUnit(input[7:0] CurrentRsrcAddress,CurrentRdstAddress,WriteMemoWriteBackAddress,WriteExcuMemoAddress,
                           output reg[1:0] SelectionSignal
                           );

always @* begin
   if(CurrentRsrcAddress==WriteExcuMemoAddress||CurrentRdstAddress==WriteExcuMemoAddress) begin
    SelectionSignal=2'b01;
   end
   else if(CurrentRsrcAddress==WriteMemoWriteBackAddress||CurrentRdstAddress==WriteMemoWriteBackAddress) begin
    SelectionSignal=2'b10;
   end
   else begin
      SelectionSignal=2'b00;
    end
end

endmodule
