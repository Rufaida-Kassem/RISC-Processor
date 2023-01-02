module ID #(parameter width = 16) (
    output ldm_value,
    input interrupt,
    output ack,
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
    output [2:0] src_address,   // src_address
    output flush
  );
  // wire mem_to_Reg_sig_cu,
  //      pop_pc1_sig_cu,
  //      pop_pc2_sig_cu,
  //      pop_ccr_sig_cu,
  //      stack_sig_cu,
  //      fetch_pc_enable_cu;
  // wire [4:0] aluOp_cu;
  // wire [1:0] aluSrc_cu;
  // wire RegWR_cu, MemR_cu, MemWR_cu, ldm_cu, branch_cu;
  // wire call_cu, rti_cu, ret_cu;
  // wire [1:0] pc_sel_cu, mem_data_sel_cu;
  // wire [31:0] pc_jmp_cu;
  // wire [2:0] RW_Out_addr_cu;
  // wire portR_cu, portWR_cu;

  //reg data back -- enable -- address
  // input       -- out in  -- out in
  wire [2:0] read_addr1, read_addr2;   // to read from RegFile
  wire [4:0] opCode;
  wire branch_taken;


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
      .ack(ack),
      .load_use (load_use ),
      .opCode (opCode ),
      .aluOp (aluOp ),
      .aluSrc (aluSrc ),
      .RegWR (RegWR ),
      .MemR (MemR),
      .MemWR (MemWR),
      .ldm (ldm ),
      .Mem_to_Reg (mem_to_Reg_sig ),
      .stack (stack_sig ),
      .branch (branch ),
      .pc_sel (pc_sel ),
      .pop_pc1 (pop_pc1_sig ),
      .pop_pc2 (pop_pc2_sig ),
      .pop_ccr (pop_ccr_sig ),
      .fetch_pc_enable  ( fetch_pc_enable),
      .mem_data_sel (mem_data_sel),
      .freeze_cu(freeze_cu),
      .call(call),
      .ret(ret),
      .rti(rti),
      .portR(portR),
      .portWR(portWR),
      .flush(flush),
      .ldm_value(ldm_value)
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



  assign opCode = (ldm_value == 1'b1) ? 5'b0: instruction  [width - 1 : width - 5];
  assign read_addr1 = instruction[width - 6 : width - 8];   //[10:8]
  assign read_addr2 = (aluSrc[0] == 1'b1) ? instruction[width - 6 : width - 8] : instruction[width - 9 : width - 11];
  assign RW_Out_addr = read_addr2;
  assign src_address = read_addr1;
  assign I_op2 = instruction[width - 1 : 0];
  assign shift_amount = instruction [7:0];


  // reg current_state, next_state;
  // parameter idle_state = 0, flush_state = 1;
  // always @ (posedge clk, posedge rst)
  // begin
  //   if(rst)
  //     current_state = idle_state;
  //   else
  //     begin
  //       current_state = next_state;
  //     end

  // end

  // always @(current_state, flush)
  // begin
  //   next_state = idle_state;
  //   case(current_state)
  //     idle_state:
  //     begin
  //       if(flush)
  //       begin
  //         next_state = flush_state;
  //       end
  //     end
  //     flush_state:
  //     begin
        
  //     end
  //   endcase
    
  // end


  // assign mem_to_Reg_sig = flush == 1'b1 ? 'b0: mem_to_Reg_sig_cu;
  // assign pop_pc1_sig = flush == 1'b1 ? 'b0: pop_pc1_sig_cu;
  // assign pop_pc2_sig = flush == 1'b1 ? 'b0: pop_pc2_sig_cu;
  // assign pop_ccr_sig = flush == 1'b1 ? 'b0: pop_ccr_sig_cu;
  // assign stack_sig = flush == 1'b1 ? 'b0: stack_sig_cu;
  // assign fetch_pc_enable = flush == 1'b1 ? 'b0: fetch_pc_enable_cu;
  // assign aluOp = flush == 1'b1 ? 'b0: aluOp_cu;
  // assign aluSrc = flush == 1'b1 ? 'b0: aluSrc_cu;
  // assign RegWR = flush == 1'b1 ? 'b0: RegWR_cu;
  // assign MemR = flush == 1'b1 ? 'b0: MemR_cu;
  // assign MemWR = flush == 1'b1 ? 'b0: MemWR_cu;
  // assign ldm  = flush == 1'b1 ? 'b0: ldm_cu;
  // assign branch = flush == 1'b1 ? 'b0: branch_cu;
  // assign call = flush == 1'b1 ? 'b0: call_cu ;
  // assign rti = flush == 1'b1 ? 'b0: rti_cu;
  // assign ret = flush == 1'b1 ? 'b0: ret_cu;
  // assign pc_sel = flush == 1'b1 ? 'b0: pc_sel_cu;
  // assign mem_data_sel = flush == 1'b1 ? 'b0: mem_data_sel_cu;
  // assign portR = flush == 1'b1 ? 'b0: portR_cu;
  // assign portWR = flush == 1'b1 ? 'b0:portWR_cu;

endmodule
