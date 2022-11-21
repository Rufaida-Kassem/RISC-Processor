module Execution(input [15:0]op1,
                 input [15:0]op2,
                 input[15:0]immediate,
                 input[2:0]AluOp, 
                 input AluScr,
                 input Mr,
                 input Mw,
                 output[2:0] Ccr,
                 output[15:0]MemoryAddress,
                 output[15:0] Out
                 );
wire [15:0] Rd;
 Mux16Bit muxRd(op2,immediate,AluScr,Rd);
 ALU alu(op1,Rd,AluOp,Ccr, Out);
assign MemoryAddress=Rd;
endmodule
