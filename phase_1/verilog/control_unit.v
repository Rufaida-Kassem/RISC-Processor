module controlUnit (
    input clk,
    input[2:0] opCode,
    output[2:0] aluOp,
    output RegWR, MemR, MemWR, aluSrc

  );
  wire memRAluSrc;

  assign memRAluSrc = ~opCode[2] & ~opCode[1] & opCode[0];
  assign MemR = memRAluSrc;
  assign aluSrc = memRAluSrc;
  assign aluOp = opCode;
  assign MemWR = ~opCode[2] & opCode[1] & ~opCode[0];
  assign RegWR = opCode[2] ^ ( opCode[1] | opCode[0]);

endmodule
