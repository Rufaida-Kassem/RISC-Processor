module ID #(parameter width = 16) (Mem_to_Reg
  input enable, load_use,
  input clk, rst,
  input [width - 1 : 0] instruction,
  output [15 : 0] op1, R_op2, I_op2,
  output [2 : 0] RW_Out_addr, //address
  input [2 : 0] RW_In_addr,
  output [4:0] aluOp_sig,
  output [1:0] aluSrc_sig,
  output RW_sig_out, MemWR_sig, MemR_sig , Mem_to_Reg, //signal
  input RW_Sig_in,
  input [15:0] Reg_data,
  output ldm, pc_to_stack_1, pc_to_stack_2, stack, pc_intr_handler, ccr_to_stack
  );
  wire [2 : 0] read_addr1, read_addr2;   // to read from RegFile
  wire [4:0] opCode;
  wire read_enable;

  //reg data back -- enable -- address
  // input       -- out in  -- out in

  RegFile_memo 
    RegFile_memo_dut (
      .read_enable (1'b1 ),
      .write_enable ( RW_Sig_in ),
      .clk ( clk ),
      .rst ( rst ),
      .write_data (Reg_data ),
      .read_data1 (op1 ),
      .read_data2 (R_op2 ),
      .read_addr1 (read_addr1 ),
      .read_addr2 (read_addr2 ),
      .write_addr  ( RW_In_addr)
    );

    controlUnit 
  controlUnit_dut (
    .interrupt (interrupt ),
    .load_use (load_use ),
    .opCode (opCode ),
    .aluOp (aluOp_sig ),
    .RegWR (RW_sig_out ),
    .MemR (MemR_sig ),
    .MemWR (MemWR_sig ),
    .aluSrc (aluSrc_sig ),
    .ldm (ldm ),
    .Mem_to_Reg (Mem_to_Reg ),
    .pc_to_stack_1 (pc_to_stack_1 ),
    .pc_to_stack_2 (pc_to_stack_2 ),
    .ccr_to_stack (ccr_to_stack ),
    .stack (stack ),
    .pc_intr_handler  ( pc_intr_handler)
  );


  assign opCode = instruction  [width - 1 : width - 5];
  assign read_addr1 = instruction[width - 6 : width - 8];
  assign read_addr2 = instruction[width - 9 : width - 11];
  assign read_enable = enable;
  assign RW_Out_addr = instruction[width - 9 : width - 11];  //instruction[width - 12 : width - 14];
  assign I_op2 = instruction[width - 1 : 0];
endmodule
