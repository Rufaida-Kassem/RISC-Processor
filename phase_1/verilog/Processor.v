module Processor (
    clk, rst
  );
  input clk, rst;
  wire memR, memWR, dataWR,
       wire [:] addR, addWR

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
      .read_enable (read_enable ),
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

