module controlUnit (
    input enable, interrupt, load_use,
    input[4:0] opCode,
    output[4:0] aluOp,
    output RegWR, MemR, MemWR, aluSrc, ldm, Mem_to_Reg, pc_to_stack_1, pc_to_stack_2, ccr_to_stack, stack, pc_intr_handler
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
  //assign pc_to_stack = (~opCode[4] & opCode[3] & opCode[2] & opCode[1] & opCode[0]);
  //assign Mem_to_pc = (~opCode[4] & opCode[3] & opCode[2] & opCode[1] & opCode[0]);
  assign call = (opCode[4] & opCode[3] & ~opCode[2] & ~opCode[1] & ~opCode[0]);
  assign rti = (opCode[4] & opCode[3] & ~opCode[2] & opCode[1] & ~opCode[0]);
  assign ret = (opCode[4] & opCode[3] & ~opCode[2] & ~opCode[1] & opCode[0]);
  assign pop_pc1 = 0;
  assign pop_pc2 = 0;
  assign pop_ccr = 0;
  //assign ccr_to_stack = 0;

  intSM 
  intSM_dut (
    .interrupt (interrupt ),
    .clk (clk ),
    .rst (rst ),
    .ldm (ldm ),
    .load_use (load_use ),
    .ccr_to_stack (ccr_to_stack ),
    .pc_to_stack_1 (pc_to_stack_1 ),
    .pc_to_stack_2 (pc_to_stack_2 ),
    .stack (stack ),
    .MemWR (MemWR ),
    .pc_intr_handler  ( pc_intr_handler)
  );


  
endmodule
