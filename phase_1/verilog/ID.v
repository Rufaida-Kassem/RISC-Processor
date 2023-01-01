module ID #(parameter width = 16) (
    enable,ldm,
    instruction, RW_sig_out, aluSrc_sig, MemWR_sig, MemR_sig, RW_Sig_in, Reg_data, aluOp_sig, op1, R_op2, I_op2, RW_Out_addr, RW_In_addr, clk, rst
  );
  input interrupt, load_use;
  output mem_to_Reg_sig,
         pop_pc1_sig,
         pop_pc2_sig,
         pop_ccr_sig,
         stack_sig,
         fetch_pc_enable
         ;
  output [1:0] pc_sel, mem_data_sel;
  input[2:0] ccr;
  input enable;
  input clk, rst;
  input [width - 1 : 0] instruction;
  wire [2 : 0] read_addr1, read_addr2;   // to read from RegFile
  wire [4:0] opCode;
  wire read_enable;
  output [31:0] pc_jmp,
         wire branch_taken, branch_sig;

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
      .branch_taken (branch_taken ),
      .interrupt (interrupt ),
      .load_use (load_use ),
      .opCode (opCode ),
      .aluOp (aluOp_sig ),
      .aluSrc (aluSrc_sig ),
      .RegWR (RW_sig_out ),
      .MemR (MemR_sig ),
      .MemWR (MemWR_sig ),
      .ldm (ldm ),
      .Mem_to_Reg (mem_to_Reg_sig ),
      .stack (stack_sig ),
      .branch (branch_sig ),
      .pc_sel (pc_sel ),
      .pop_pc1 (pop_pc1_sig ),
      .pop_pc2 (pop_pc2_sig ),
      .pop_ccr (pop_ccr_sig ),
      .fetch_pc_enable  ( fetch_pc_enable),
      .mem_data_sel (mem_data_sel)
    );

  jumpsCU
    jumpsCU_dut (
      .clk (clk ),
      .rst (rst ),
      .branch (branch_sig ),
      .jtype (opCode[1:0] ),
      .ccr (ccr ),
      .rdst (R_op2),
      .pc (pc_jmp ),
      .taken  ( branch_taken)
    );

  assign opCode = instruction  [width - 1 : width - 5];
  assign read_addr1 = instruction[width - 6 : width - 8];
  assign read_addr2 = instruction[width - 9 : width - 11];
  assign read_enable = enable;
  assign RW_Out_addr = instruction[width - 9 : width - 11];  //instruction[width - 12 : width - 14];
  assign I_op2 = instruction[width - 1 : 0];
endmodule
