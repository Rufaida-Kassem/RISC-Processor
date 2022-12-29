module controlUnit (
    output [1:0] mem_data_sel,
    input branch_taken,
    inout interrupt,
    input load_use,
    input[4:0] opCode,
    output[4:0] aluOp,
    output [1:0] aluSrc,
    output RegWR, MemR, MemWR, ldm, Mem_to_Reg, stack , branch,
    output[1:0] pc_sel,
    output pop_pc1, pop_pc2, pop_ccr, fetch_pc_enable
  );
  wire pc_to_stack1, pc_to_stack2, ccr_to_stack;
  wire MemWR_call, MemWR_int, MemWR_cu,
       MemR_rti, MemR_ret, MemR_cu,
       stack_int, stack_call, stack_cu, stack_rti, stack_ret,
       pc_to_stack1_call, pc_to_stack1_int, pc_to_stack2_call, pc_to_stack2_int,
       ccr_to_stack_int,
       pop_pc1_ret, pop_pc1_rti, pop_pc2_ret, pop_pc2_rti,
       pop_ccr_rti,
       load_pc_call,
       load_pc_jmps,
       freeze_pc_int, freeze_pc_call, freeze_pc_rti, freeze_pc_ret, freeze_pc,
       freeze_cu_int, freeze_cu_call, freeze_cu_rti, freeze_cu_ret, freeze_cu;
  assign branch = opCode[4] && ~opCode[3] && opCode[2];

  assign aluSrc = {(opCode[4] && ~opCode[3] && ~opCode[2] && ~opCode[1] && opCode[0]), (~opCode[4] && opCode[3] && opCode[2] && ~opCode[1] && opCode[0]) || (~opCode[4] && opCode[3] && opCode[2] && opCode[1] && ~opCode[0])};


  assign ldm = (opCode[4] && ~opCode[3] && ~opCode[2] && ~opCode[1] && opCode[0]);

  assign aluOp = opCode;

  assign MemR_cu = (opCode[4] && ~opCode[3] && ~opCode[2] && ~opCode[1] && ~opCode[0]) || (opCode[4] && ~opCode[3] && ~opCode[2] && opCode[1] && ~opCode[0]) || (opCode[4] && opCode[3] && ~opCode[2] && ~opCode[1] && opCode[0]) || (opCode[4] && opCode[3] && ~opCode[2] && opCode[1] && ~opCode[0]);
  assign MemWR_cu = (~opCode[4] && ~opCode[3] && opCode[2] && opCode[1] && opCode[0]) || (opCode[4] && ~opCode[3] && ~opCode[2] && opCode[1] && opCode[0]) || (opCode[4] && opCode[3] && opCode[2] && ~opCode[1] && ~opCode[0]);
  assign RegWR = (opCode == 5'b00011 || opCode == 5'b00100 || opCode == 5'b00101 || opCode == 5'b01000 || (opCode[4] == 1'b0 && opCode[3] == 1'b1) || opCode == 5'b10000 || opCode == 5'b10001 || opCode == 5'b10010); //(~opCode[4] && ~opCode[3] && ~opCode[2] && opCode[1] && opCode[0]) || (~opCode[4] && ~opCode[3] && opCode[2] && ~opCode[1] && ~opCode[0]) || (~opCode[4] && ~opCode[3] && opCode[2] && ~opCode[1] && opCode[0]) || (~opCode[4] && opCode[3] && ~opCode[2] && ~opCode[1] && ~opCode[0]) || (~opCode[4] && opCode[3] && ~opCode[2] && ~opCode[1] && opCode[0]) || (~opCode[4] && opCode[3] && ~opCode[2] && opCode[1] && ~opCode[0]) || (~opCode[4] && opCode[3] && ~opCode[2] && opCode[1] && opCode[0]) || (~opCode[4] && opCode[3] && opCode[2] && ~opCode[1] && ~opCode[0]) || (~opCode[4] && opCode[3] && opCode[2] && ~opCode[1] && opCode[0]) || (~opCode[4] && opCode[3] && opCode[2] && opCode[1] && ~opCode[0]) || (~opCode[4] && opCode[3] && opCode[2] && opCode[1] && opCode[0]) || (opCode[4] && ~opCode[3] && ~opCode[2] && ~opCode[1] && ~opCode[0]) || (opCode[4] && ~opCode[3] && ~opCode[2] && ~opCode[1] && opCode[0]) || (opCode[4] && ~opCode[3] && ~opCode[2] && opCode[1] && ~opCode[0]);
  assign Mem_to_Reg = (opCode[4] && ~opCode[3] && ~opCode[2] && ~opCode[1] && ~opCode[0]) || (opCode[4] && ~opCode[3] && ~opCode[2] && opCode[1] && ~opCode[0]);
  assign stack_cu = (~opCode[4] && opCode[3] && opCode[2] && opCode[1] && opCode[0]) || (~opCode[4] && ~opCode[3] && opCode[2] && opCode[1] && opCode[0]);

  assign portR = (~opCode[4] && opCode[3] && opCode[2] && opCode[1] && opCode[0]);
  assign portWR = (~opCode[4] && ~opCode[3] && opCode[2] && opCode[1] && ~opCode[0]);

  assign call = (opCode[4] && opCode[3] && ~opCode[2] && ~opCode[1] && ~opCode[0]);
  assign rti = (opCode[4] && opCode[3] && ~opCode[2] && opCode[1] && ~opCode[0]);
  assign ret = (opCode[4] && opCode[3] && ~opCode[2] && ~opCode[1] && opCode[0]);

  assign pc_to_stack1 = pc_to_stack1_int || pc_to_stack1_call;
  assign pc_to_stack2 = pc_to_stack2_int || pc_to_stack2_call;
  assign ccr_to_stack = ccr_to_stack_int;
  assign pop_pc1 = pop_pc1_rti || pop_pc1_ret;
  assign pop_pc2 = pop_pc2_rti || pop_pc2_ret;
  assign pop_ccr = pop_ccr_rti;
  assign freeze_cu = load_use || freeze_cu_call || freeze_cu_int || freeze_cu_ret || freeze_cu_rti;
  assign freeze_pc = freeze_pc_call || freeze_pc_int || freeze_pc_ret || freeze_pc_rti;

  assign fetch_pc_enable = ~ freeze_pc;
  assign mem_data_sel = pc_to_stack1 == 1'b1 ? 2'b01 : pc_to_stack2 == 1'b1 ? 2'b10 : ccr_to_stack == 1'b1 ? 2'b11 : 2'b0;
  assign pc_sel = pc_sel_int || pc_sel_call || pc_sel_ret || pc_sel_rti;
    callSM
    callSM_dut (
      .call (call ),
      .clk (clk ),
      .rst (rst ),
      .pc_to_stack1 (pc_to_stack1_call ),
      .pc_to_stack2 (pc_to_stack2_call ),
      .stack (stack_call ),
      .MemWR (MemWR_call ),
      .load_pc_call (load_pc_call ),
      .freeze_pc (freeze_pc ),
      .freeze_cu  ( freeze_cu),
      .pc_sel (pc_sel_call)
    );

  retSM
    retSM_dut (
      .ret (ret ),
      .clk (clk ),
      .rst (rst ),
      .pop_pc1 (pop_pc1 ),
      .pop_pc2 (pop_pc2 ),
      .stack (stack ),
      .MemR (MemR ),
      .freeze_pc (freeze_pc ),
      .freeze_cu  ( freeze_cu),
      .pc_sel (pc_sel_ret)
    );

  intSM
    intSM_dut (
      .interrupt (interrupt ),
      .clk (clk ),
      .rst (rst ),
      .ldm (ldm ),
      .load_use (load_use ),
      .ccr_to_stack (ccr_to_stack ),
      .pc_to_stack1 (pc_to_stack1 ),
      .pc_to_stack2 (pc_to_stack2 ),
      .stack (stack ),
      .MemWR (MemWR ),
      .freeze_pc (freeze_pc ),
      .freeze_cu  ( freeze_cu),
      .pc_sel (pc_sel_int)
    );

  rtiSM
    rtiSM_dut (
      .rti (rti ),
      .clk (clk ),
      .rst (rst ),
      .pop_ccr (pop_ccr ),
      .pop_pc1 (pop_pc1 ),
      .pop_pc2 (pop_pc2 ),
      .stack (stack ),
      .MemR (MemR ),
      .freeze_pc (freeze_pc ),
      .freeze_cu  ( freeze_cu),
      .pc_sel (pc_sel_rti)
    );

endmodule

//F D E M WB
//  F D E M WB
module ldmSM ();
endmodule

module callSM ( 
                 input call, clk, rst,
                 output reg pc_to_stack1, pc_to_stack2, stack, MemWR, load_pc_call, freeze_pc, freeze_cu,
                 output [1:0] pc_sel
                );
  reg     [1:0] current_state, next_state;
  // push pc from decode not from pc itself
  // code
  // calling
  // code     --> pc to be pushed before going to the procedure
  //we don't have to push ccr


  parameter idle_state = 0, push_pc1 = 1, push_pc2 = 2, load_pc = 3;

  always @(posedge clk, posedge rst)
  begin
    if(rst)
    begin
      current_state = idle_state;
    end
    if(clk)
    begin
      current_state = next_state;
    end
  end

  always @ (current_state, call)
  begin
    next_state = idle_state;
    case(current_state)
      idle_state:
      begin
        pc_sel = 2'b0;
        freeze_pc = 1'b0;
        freeze_cu = 1'b0;
        MemWR = 1'b0;
        stack = 1'b0;
        pc_to_stack2 = 1'b0;
        pc_to_stack1 = 1'b0;
        load_pc_call = 1'b0;
        if(call)
        begin
          next_state = push_pc1;
        end
      end
      push_pc1:
      begin
        freeze_pc = 1'b1;
        freeze_cu = 1'b1;
        next_state = push_pc2;
        MemWR = 1'b1;
        stack = 1'b1;
        pc_to_stack1 = 1'b1;

      end
      push_pc2:
        next_state = load_pc;
      MemWR = 1'b1;
      stack = 1'b1;
      pc_to_stack2 = 1'b1;

      load_pc:
      begin
        next_state = idle_state;
        load_pc_call = 1'b1;
        pc_sel = 2'b0;
      end
      default:
      begin
        next_state = idle_state;
      end
    endcase

  end



endmodule
module retSM (
    input ret, clk, rst,
    output reg pop_pc1, pop_pc2, stack, MemR, freeze_pc, freeze_cu,
    output [1:0] pc_sel
  );

  //we have to set pc to pc - 1 to fetch the correct instruction
  //as it gets incremented during the calling --> as we know the call is call in decode stage
  //so that the next instruction to the call is already get fetched and we will ignore this fetch
  reg     [1:0] current_state, next_state;

  parameter idle_state = 0, pop_pc1_state = 1, pop_pc2_state = 2;

  always @(posedge clk, posedge rst)
  begin
    if(rst)
    begin
      current_state = idle_state;
    end
    if(clk)
    begin
      current_state = next_state;
    end
  end

  always @ (current_state, call)
  begin
    next_state = idle_state;
    case(current_state)
      idle_state:
      begin
        pc_sel = 2'b0;
        freeze_cu = 1'b0;
        freeze_pc = 1'b0;
        MemR = 1'b0;
        stack = 1'b0;
        pop_pc2 = 1'b0;
        pop_pc1 = 1'b0;
        if(ret)
        begin
          next_state = pop_pc1_state;
        end
      end
      pop_pc2_state:
      begin
        freeze_cu = 1'b1;
        freeze_pc = 1'b1;
        MemR = 1'b1;
        stack = 1'b1;
        next_state = pop_pc1_state;
        pop_pc2 = 1'b1;
      end

      pop_pc1_state:
      begin
        next_state = idle_state;
        pop_pc1 = 1'b1;

      end
      default:
      begin
        next_state = idle_state;
      end
    endcase

  end




endmodule
module intSM (
    inout interrupt,
    input clk, rst, ldm, load_use,
    output reg ccr_to_stack , pc_to_stack1, pc_to_stack2, stack, MemWR, pc_intr_handler, freeze_pc, freeze_cu,
    output [1:0] pc_sel
  );
  reg     [2:0] current_state, next_state;
  parameter idle_state = 0, wait_ = 1, wait_ldm_load_use = 2, freezePc = 3, freezePc_cu = 4, push_pc1 = 5, push_pc2 = 6, push_ccr = 7;
   reg ack;
  assign interrupt = ack ? 0 : interrupt;


  always @(posedge clk, posedge rst)
  begin
    if(rst)
    begin
      current_state = idle_state;
    end
    if(clk)
    begin
      current_state = next_state;
    end
  end

  always @ (current_state, interrupt)
  begin
    case(current_state)
      idle_state:
      begin
        pc_sel = 2'b0;
        freeze_pc = 0;
        freeze_cu = 0;
        stack = 0;
        MemWR = 0;
        ccr_to_stack = 0;
        pc_to_stack1 = 0;
        pc_to_stack2 = 0;
        pc_intr_handler = 0;
        if(interrupt == 1)
        begin
          ack = 1'b1;
          next_state = wait_;
        end
        else
        begin
          ack = 1'b0;
          next_state = idle_state;
        end
      end
      wait_:
      begin
        if(ldm  ||  load_use)
        begin
          next_state = wait_ldm_load_use;
        end
        else
        begin
          next_state = freezePc;
        end
      end
      wait_ldm_load_use:
        next_state = freezePc;
      freezePc:
      begin
        freeze_pc = 1'b1;
        next_state = freezePc_cu;
      end
      freezePc_cu:
      begin
        freeze_cu = 1'b1;
        next_state = push_pc1;
      end
      push_pc1:
      begin
        next_state = push_pc2;
        pc_to_stack1 = 1;
        stack = 1;
        MemWR = 1;
      end
      push_pc2:
      begin
        next_state = push_ccr;
        pc_to_stack1 = 0;
        pc_to_stack2 = 1;
      end
      push_ccr:
      begin
        next_state = idle_state;
        ccr_to_stack = 1;
        pc_sel = 2'b0;
      end
      default:
      begin
        next_state = idle_state;
      end
    endcase

  end


endmodule
module rtiSM (
    input rti, clk, rst,
    output reg pop_ccr , pop_pc1, pop_pc2, stack, MemR, freeze_pc, freeze_cu,
    output [1:0] pc_sel
  );

  reg     [1:0] current_state, next_state;

  parameter idle_state = 0, pop_ccr_state = 1, pop_pc2_state = 2, pop_pc1_state = 3;

  always @(posedge clk, posedge rst)
  begin
    if(rst)
    begin
      current_state = idle_state;
    end
    if(clk)
    begin
      current_state = next_state;
    end
  end

  always @ (current_state, call)
  begin
    next_state = idle_state;
    case(current_state)
      idle_state:
      begin
        pc_sel = 2'b0;
        pop_ccr = 1'b0;
        freeze_cu = 1'b0;
        freeze_pc = 1'b0;
        MemR = 1'b0;
        stack = 1'b0;
        pop_pc2 = 1'b0;
        pop_pc1 = 1'b0;
        if(ret)
        begin
          next_state = pop_ccr_state;
        end
      end
      pop_ccr_state:
      begin
        next_state = pop_pc2_state;
        freeze_cu = 1'b1;
        freeze_pc = 1'b1;
        MemR = 1'b1;
        stack = 1'b1;
        pop_ccr = 1'b1;
      end
      pop_pc2_state:
      begin
        next_state = pop_pc1_state;
        pop_pc2 = 1'b1;

      end
      pop_pc1_state:
      begin
        next_state = idle_state;
        pop_pc1 = 1'b1;

      end
      default:
      begin
        next_state = idle_state;
      end
    endcase

  end


endmodule
