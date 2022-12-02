module controlUnit (
    input enable,
    input[4:0] opCode,
    output[4:0] aluOp,
    output RegWR, MemR, MemWR, aluSrc
  );
  wire memRAluSrc;

  assign memRAluSrc = ~opCode[4] & ~opCode[3] & ~opCode[2] & ~opCode[1] & opCode[0];
  assign MemR = memRAluSrc;
  assign aluSrc = (enable == 1'b1) ? memRAluSrc : 1'b0;
  assign aluOp = opCode;
  assign MemWR = ~opCode[4] & ~opCode[3] & ~opCode[2] & opCode[1] & ~opCode[0];
  assign RegWR = ~opCode[4] & ~opCode[3] & (opCode[2] ^ ( opCode[1] | opCode[0]));
endmodule
