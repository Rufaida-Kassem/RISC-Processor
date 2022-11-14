module controlUnit (
    input clk,
    input[2:0] opCode,
    output[2:0] aluOp,
    output RegWR, MemR, MemWR, aluSrc

  );
  reg[2:0] opCodeReg;
  wire memRAluSrc;

  assign memRAluSrc = ~opCodeReg[2] & ~opCodeReg[1] & opCodeReg[0];
  assign MemR = memRAluSrc;
  assign aluSrc = memRAluSrc;
  assign aluOp = opCodeReg;
  assign MemWR = ~opCodeReg[2] & opCodeReg[1] & ~opCodeReg[0];
  assign RegWR = opCodeReg[2] ^ ( opCodeReg[1] | opCodeReg[0]);
  always @(posedge clk)
  begin
    opCodeReg <= opCode;
  end
endmodule
