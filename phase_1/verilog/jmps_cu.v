module jumpsCU (
    input clk, rst, branch,
    input [1:0] jtype,
    input [2:0] ccr,
    input [15:0] rdst,
    output[31:0] pc,
    output taken
  );
  parameter jz = 1,
  jmp = 0,
  jn = 2,
  jc = 3;
  assign taken = (branch == 1'b0) ? 1'b0 : (jtype == jmp) || (jtype == jz && ccr[0] == 1'b1) || (jtype == jn && ccr[2] == 1'b1) || (jtype == jc && ccr[3] == 1'b1);
  assign pc = (taken == 1'b1)? {16'b0, rdst} : 32'b0;

endmodule


////////To be moved to control unit/////////////////////////
//branch = opCode[4] & ~opCode[3] & opCode[2]