module FullForwardingUnit(input[2:0] CurrentRsrcAddress,CurrentRdstAddress,WriteMemoWriteBackAddress,WriteExcuMemoAddress,
                           output reg[1:0] SelectionSignalRcs, output reg[1:0] SelectionSignalRds
                           );

always @* begin
   if(CurrentRsrcAddress==WriteExcuMemoAddress) begin
    SelectionSignalRcs=2'b01;
   end
   else if(CurrentRsrcAddress==WriteMemoWriteBackAddress) begin
    SelectionSignalRcs=2'b10;
   end
   else begin
         SelectionSignalRcs=2'b00; 
      end
      
   if(CurrentRdstAddress==WriteMemoWriteBackAddress) begin
   SelectionSignalRds=2'b10;
   end
   else if(CurrentRdstAddress==WriteExcuMemoAddress) begin
   SelectionSignalRds=2'b10;
   end
   else begin
   SelectionSignalRds=2'b00;
   end
end

endmodule
