module WriteBack(input [15:0]Load,
                 input [15:0]Rd,
                 input Wb,
                 output reg[15:0] WriteData
               );
Mux16Bit(Load,Rd,Wb,WriteData);
endmodule
