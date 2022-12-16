module WriteBack(input [15:0]Load,
                 input [15:0]Rd,
                 input Wb,
                 output wire[15:0] WriteData
               );
Mux16Bit mux(Rd,Load,Wb,WriteData);
endmodule
