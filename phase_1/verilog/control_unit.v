module controlUnit (
    input enable,
    input[4:0] opCode,
    output[4:0] aluOp,
    output RegWR, MemR, MemWR, aluSrc, ldm, Mem_to_Reg, 
  );

  assign aluSrc = {(opCode[4] & ~opCode[3] & ~opCode[2] & ~opCode[1] & opCode[0]), (~opCode[4] & opCode[3] & opCode[2] & ~opCode[1] & opCode[0]) | (~opCode[4] & opCode[3] & opCode[2] & opCode[1] & ~opCode[0])};
  assign MemR = (opCode[4] & ~opCode[3] & ~opCode[2] & ~opCode[1] & ~opCode[0]) | (opCode[4] & ~opCode[3] & ~opCode[2] & opCode[1] & ~opCode[0]) | (opCode[4] & opCode[3] & ~opCode[2] & ~opCode[1] & opCode[0]) | (opCode[4] & opCode[3] & ~opCode[2] & opCode[1] & ~opCode[0]);
  assign ldm = (opCode[4] & ~opCode[3] & ~opCode[2] & ~opCode[1] & opCode[0]);
  assign aluOp = opCode;
  assign MemWR = (~opCode[4] & ~opCode[3] & opCode[2] & opCode[1] & opCode[0]) | (opCode[4] & ~opCode[3] & ~opCode[2] & opCode[1] & opCode[0]) | (opCode[4] & opCode[3] & opCode[2] & ~opCode[1] & ~opCode[0]);
  assign RegWR = (~opCode[4] & ~opCode[3] & ~opCode[2] & opCode[1] & opCode[0]) | (~opCode[4] & ~opCode[3] & opCode[2] & ~opCode[1] & ~opCode[0]) | (~opCode[4] & ~opCode[3] & opCode[2] & ~opCode[1] & opCode[0]) | (~opCode[4] & opCode[3] & ~opCode[2] & ~opCode[1] & ~opCode[0]) | (~opCode[4] & opCode[3] & ~opCode[2] & ~opCode[1] & opCode[0]) | (~opCode[4] & opCode[3] & ~opCode[2] & opCode[1] & ~opCode[0]) | (~opCode[4] & opCode[3] & ~opCode[2] & opCode[1] & opCode[0]) | (~opCode[4] & opCode[3] & opCode[2] & ~opCode[1] & ~opCode[0]) | (~opCode[4] & opCode[3] & opCode[2] & ~opCode[1] & opCode[0]) | (~opCode[4] & opCode[3] & opCode[2] & opCode[1] & ~opCode[0]) | (~opCode[4] & opCode[3] & opCode[2] & opCode[1] & opCode[0]) | (opCode[4] & ~opCode[3] & ~opCode[2] & ~opCode[1] & ~opCode[0]) | (opCode[4] & ~opCode[3] & ~opCode[2] & ~opCode[1] & opCode[0]) | (opCode[4] & ~opCode[3] & ~opCode[2] & opCode[1] & ~opCode[0]);
  assign Mem_to_Reg = (opCode[4] & ~opCode[3] & ~opCode[2] & ~opCode[1] & ~opCode[0]) | (opCode[4] & ~opCode[3] & ~opCode[2] & opCode[1] & ~opCode[0]);
  assign portR = (~opCode[4] & opCode[3] & opCode[2] & opCode[1] & opCode[0]);
  assign portWR = (~opCode[4] & ~opCode[3] & opCode[2] & opCode[1] & ~opCode[0]);
  assign stack = (~opCode[4] & opCode[3] & opCode[2] & opCode[1] & opCode[0]);
  assign pc_to_stack = (~opCode[4] & opCode[3] & opCode[2] & opCode[1] & opCode[0]);
  assign Mem_to_pc = (~opCode[4] & opCode[3] & opCode[2] & opCode[1] & opCode[0]);
  assign call =  | (opCode[4] & opCode[3] & ~opCode[2] & ~opCode[1] & ~opCode[0]);
  assign rti = (opCode[4] & opCode[3] & ~opCode[2] & opCode[1] & ~opCode[0]);
  assign ret = (opCode[4] & opCode[3] & ~opCode[2] & ~opCode[1] & opCode[0]);
  assign pop_pc1 = 0;
  assign pop_pc2 = 0;
  assign pop_ccr = 0;
  assign ccr_to_stack = 0;
endmodule



module callSM (
  input call, clk, rst,
  output pc_to_stack_1, pc_to_stack_2, stack, MemWR
);
  
endmodule
module retSM (
  input ret, clk, rst,
  output pop_pc1, pop_pc2, stack, MemR
);
  
endmodule
module intSM (
  input interrupt, clk, rst,
  output ccr_to_stack , pc_to_stack_1, pc_to_stack_2, stack, MemWR
);
  
endmodule
module rtiSM (
  input rti, clk, rst,
  output pop_ccr , pop_pc1, pop_pc2, stack, MemR
);
  
endmodule