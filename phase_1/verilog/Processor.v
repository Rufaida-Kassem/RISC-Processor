module Processor (
    clk, rst
  );
  input clk, rst;
  wire [15:0] instruction

  IF
    IF_dut (
      .clk (clk ),
      . rst ( rst ),
      .instruction  ( instruction)
    );

  ID
    ID_dut (
      .clk (clk ),
      .instruction (instruction ),
      .read_enable ('b1 ),
      .op1 (op1 ),
      .R_op2 (R_op2 ),
      .I_op2 (I_op2 ),
      .write_addr (write_addr ),
      .aluOp (aluOp ),
      .RegWR (RegWR ),
      .aluSrc (aluSrc ),
      .MemWR (MemWR ),
      .MemR  ( MemR)
    );

endmodule

