module ID #(parameter width = 16) (
  inout interrupt, 
  input load_use,
  output mem_to_Reg_sig,
         pop_pc1_sig,
         pop_pc2_sig,
         pop_ccr_sig,
         stack_sig,
         fetch_pc_enable,
  output[4:0] aluOp,
  output [1:0] aluSrc,
  output RegWR, MemR, MemWR, ldm , branch,
  output freeze_cu,
  output call, rti, ret,
  output [1:0] pc_sel, mem_data_sel,
  input[2:0] ccr,
  input clk, rst,
  input [width - 1 : 0] instruction,
  output [31:0] pc_jmp,
  output [7:0] shift_amount,
  input [15:0] Reg_data,
  output [15:0] op1, R_op2, I_op2,
  input [2:0] RW_In_addr,
  output [2:0] RW_Out_addr,
  input RW_Sig_in,
  output portR, portWR,
  output [2:0] src_address   // src_address
 );

  wire mem_to_Reg_sig_cu,
        pop_pc1_sig_cu,
        pop_pc2_sig_cu,
        pop_ccr_sig_cu,
        stack_sig_cu,
        fetch_pc_enable_cu;
  wire [4:0] aluOp_cu;
  wire [1:0] aluSrc_cu;
  wire RegWR, MemR, MemWR, ldm , branch_cu;
  wire call, rti, ret_cu;
  wire [1:0] pc_sel, mem_data_sel_cu;
  wire [31:0] pc_jmp_cu;
  wire [7:0] shift_amount_cu;
  wire [15:0] op1, R_op2, I_op2_cu;
  wire [2:0] RW_Out_addr_cu;
  wire portR, portWR_cu;
  wire [2:0] src_address_cu;   // src_address



  wire [2:0] read_addr1, read_addr2;   // to read from RegFile
  wire [4:0] opCode;
  wire branch_taken;

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
      .clk(clk),
      .rst(rst),
      .branch_taken (branch_taken ),
      .interrupt (interrupt ),
      .load_use (load_use ),
      .opCode (opCode ),
      .aluOp (aluOp ),
      .aluSrc (aluSrc ),
      .RegWR (RegWR_cu ),
      .MemR (MemR_cu),
      .MemWR (MemWR_cu),
      .ldm (ldm_cu ),
      .Mem_to_Reg (mem_to_Reg_sig_cu ),
      .stack (stack_sig_cu ),
      .branch (branch_cu ),
      .pc_sel (pc_sel_cu ),
      .pop_pc1 (pop_pc1_sig_cu ),
      .pop_pc2 (pop_pc2_sig_cu ),
      .pop_ccr (pop_ccr_sig_cu ),
      .fetch_pc_enable  ( fetch_pc_enable_cu),
      .mem_data_sel (mem_data_sel_cu),
      .freeze_cu(freeze_cu_cu),
      .call(call_cu),
      .ret(ret_cu),
      .rti(rti_cu),
      .portR(portR_cu),
      .portWR(portWR_cu)
   );

  jumpsCU
    jumpsCU_dut (
      .clk (clk ),
      .rst (rst ),
      .branch (branch ),
      .jtype (opCode[1:0] ),
      .ccr (ccr ),
      .rdst (R_op2),
      .pc (pc_jmp ),
      .taken  (branch_taken)
    );



  assign opCode = instruction  [width - 1 : width - 5];
  assign read_addr1 = instruction[width - 6 : width - 8];   //[10:8]
  assign read_addr2 = (aluSrc[0] == 1'b1) ? instruction[width - 6 : width - 8] : instruction[width - 9 : width - 11];
  assign RW_Out_addr = read_addr2;
  assign src_address = read_addr1;
  assign I_op2 = instruction[width - 1 : 0];
  assign shift_amount = instruction [7:0];
  
  wire mem_to_Reg_sig_cu,
  pop_pc1_sig_cu,
  pop_pc2_sig_cu,
  pop_ccr_sig_cu,
  stack_sig_cu,
  fetch_pc_enable_cu;
wire [4:0] aluOp_cu;
wire [1:0] aluSrc_cu;
wire RegWR_cu, MemR_cu, MemWR_cu, ldm_cu, branch_cu;
wire call_cu, rti_cu, ret_cu;
wire [1:0] pc_sel_cu, mem_data_sel_cu;
wire [31:0] pc_jmp_cu;
wire [2:0] RW_Out_addr_cu;
wire portR_cu, portWR_cu;

assign mem_to_Reg_sig = freeze_cu == 1'b1 ? 'b0: mem_to_Reg_sig_cu;
assign pop_pc1_sig = freeze_cu == 1'b1 ? 'b0: pop_pc1_sig_cu;
assign pop_pc2_sig = freeze_cu == 1'b1 ? 'b0: pop_pc2_sig_cu;
assign pop_ccr_sig = freeze_cu == 1'b1 ? 'b0: pop_ccr_sig_cu;
assign stack_sig = freeze_cu == 1'b1 ? 'b0: stack_sig_cu;
assign fetch_pc_enable = freeze_cu == 1'b1 ? 'b0: fetch_pc_enable_cu;
assign aluOp = freeze_cu == 1'b1 ? 'b0: aluOp_cu;
assign aluSrc = freeze_cu == 1'b1 ? 'b0: aluSrc_cu;
assign RegWR = freeze_cu == 1'b1 ? 'b0: RegWR_cu;
assign MemR = freeze_cu == 1'b1 ? 'b0: MemR_cu;
assign MemWR = freeze_cu == 1'b1 ? 'b0: MemWR_cu;
assign ldm  = freeze_cu == 1'b1 ? 'b0: ldm_cu;
assign branch = freeze_cu == 1'b1 ? 'b0: branch_cu;
assign call = freeze_cu == 1'b1 ? 'b0: call_cu ;
assign rti = freeze_cu == 1'b1 ? 'b0: rti_cu;
assign ret = freeze_cu == 1'b1 ? 'b0: ret_cu;
assign pc_sel = freeze_cu == 1'b1 ? 'b0: pc_sel_cu;
assign mem_data_sel = freeze_cu == 1'b1 ? 'b0: mem_data_sel_cu;
assign portR = freeze_cu == 1'b1 ? 'b0: portR_cu;
assign portWR = freeze_cu == 1'b1 ? 'b0:portWR_cu ;

endmodule
