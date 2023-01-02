module WriteBack(
   input [15:0]Load,
                 input [15:0]Rd,
                 input Wb,
                 input Port_Write,
              //  input [15:0]output_port_pervious,
                 output reg[15:0] Write_Data,
                 output reg [15:0]output_port
               );
wire [15:0]Write_back_result;
//load -Rd reversed
Mux16Bit mux(Rd,Load,Wb,Write_back_result);
always @* begin
   if(Port_Write==1'b1) begin
      output_port=Write_back_result;
   end else if(Port_Write==1'b0) begin
      Write_Data=Write_back_result;
   end

end
// assign Write_Data=(Port_Write==1'b0)?Write_back_result:16'bz;
// assign output_port=(Port_Write==1'b1)?Write_back_result;
endmodule
