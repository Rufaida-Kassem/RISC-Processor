module Processor (
  input clk, rst, start,
  output [15:0] outputPort,
  input [15:0] inputPort,
  inout interrupt
  );
  
  wire [15:0] instruction;
  wire [31:0] pc;
  reg [63:0] IFIDReg_pre;
  reg [63:0] IFIDReg;   // 0000_0000_0000_0000 - PC[47:16] - instruction[15:0]
                        //pc 32
                        //instruction 16  

  reg [121:0] IDEReg_pre;
  reg [121:0] IDEReg;   // src_address     3bits    [121:119]
                        // portRW                   [118]
                        // portR                    [117]
                        // shift_amount  8bits      [116:109]         
                        // MemR_sig 1               [108]
                        // MemWR_sig 1              [107]
                        // aluOp_sig (5 bits)       [106:102]
                        // aluSrc_sig 2 bits        [101:100]
                        // op1 (value of first reg) 16 bits   [99:84]
                        // R_op2 (value of second reg) to be saved for WB  16 bits  [83:68]
                        // I_op2  (immediate)   16 bits       [67:52]
                        // RW_Out_addr (dest address) 3 bits  [51:49]
                        // RW_sig_out  1 bit        [48]
                        // mem_to_reg_sig 1 bit     [47]
                        // pop_pc1_sig 1 bit        [46]
                        // pop_pc2_sig 1 bit        [45]
                        // pop_ccr_sig 1 bit        [44]
                        // stack_sig  1bit   --> to select between the address of mem or stack    [43]
                        // fetch_pc_enable  1bit    [42]
                        // branch  1bit             [41]
                        // ldm  1bit                [40]
                        // freeze_cu  1bit          [39]
                        // call  1bit               [38]
                        // ret  1bit                [37]
                        // rti  1bit                [36]
                        // pc_sel 2 bits            [35:34]
                        // mem_data_sel  2bits      [33:32]
                        // pc_jmp 32 bits           [31:0]

  reg [31:0] IDEPC_Reg_pre;
  reg [31:0] IDEPC_Reg; // we separate it to reduce the size in case we put all in reg (as we will need to keep the size log to the base 2)


  wire [1:0] aluSrc_sig, mem_data_sel;
  wire MemR, MemWR, RW_sig_out; //signals 3ady
  wire [15:0] I_op2, R_op2, op1, Reg_data;  // out from the IF  --  out from ID  --  out of ID  --  Back to ID (WB)
  reg [15:0] Reg_data_2;
  wire [4:0] aluOp_sig;  //signal 3ady
  wire [2:0] RW_Out_addr;   // out from ID 
  wire load_use, mem_to_Reg_sig, fetch_pc_enable, stack_sig, pop_ccr_sig, 
       pop_pc2_sig, pop_pc1_sig; 
  wire [1:0] pc_sel;
  wire call, ret, rti;
  wire branch, freeze_cu;

  wire [8:0] shift_amount;

  wire portR, portWR;




  //////////////////For Execute and Memory
  reg [81:0] EXMEMO_Reg_pre;
  reg [81:0] EXMEMO_Reg; //86 bits ==>//[81:79] ==> Ccr
                         //[78:63] ==> ALuout
                         //[62:51] ==> Memoryaddress
                         //[50] ==> portRW IDEReg[118]
                         //[49] ==> portR IDEReg[117]
                         //[48] ==> MemR_sig IDEReg[108]
                         //[47] ==> MemWR_sig IDEReg[107]
                         //[46:42] ==> aluOp IDEReg[106:102]
                         //[41:39] ==> Rw_out_addr IDEReg[51:49]
                         //[38] ==> RW_sig_out IDEReg[48]
                         //[37] ==> mem_to_reg_sig IDEReg[47]
                         //[36] ==> stack_sig IDEReg[43]
                         //[35] ==> branch IDEReg[41]
                        //[34] ==> ldm IDEReg[40]
                        //[33:32] ==> mem_data_sel IDEReg[33:32]
                        //[31:0] ==> pc IDEReg[31:0]

  reg [37:0] MEMOWB_Reg_pre;
  reg [37:0] MEMOWB_Reg;//=>[36:21]Aluout
                        //=>[20:5]memoout
                        //=>[4]outPort
                        //=>[3]Memo/Alu select
                        //=>[2:0]write back reg
  wire [2:0]Ccr;
  wire [15:0] Out_Excute;
  wire [15:0]MemoryAddress;
  wire [15:0] Out_Memo;
  wire ldm;
  wire [31:0] pc_jmp;
  wire [2:0] src_address;
  wire [1:0]Forward1Sel,Forward2Sel;
  wire fetch_pc_enable_oring;


  assign fetch_pc_enable_oring = (rst == 1'b1) ? 1'b1 : fetch_pc_enable;

  IF 
    IF_dut (
      .clk (clk ),
      .rst (rst ),
      .pc_enable (fetch_pc_enable_oring ),
      .pc_selection (pc_sel ),
      .branch_call_addr (pc_jmp ),
      .pc_out (pc ),  //output --> next instruction address
      .instruction  ( instruction),  //output
      .pop_pc_low_sig (pop_pc1_sig),
      .pop_pc_high_sig (pop_pc2_sig),
      .pop_data (16'b0)
    );

  ID 
    ID_dut (
      .interrupt (interrupt ), //to change
      .load_use (1'b0 ), //to change
      .mem_to_Reg_sig (mem_to_Reg_sig ),
      .pop_pc1_sig (pop_pc1_sig ),
      .pop_pc2_sig (pop_pc2_sig ),
      .pop_ccr_sig (pop_ccr_sig ),
      .stack_sig (stack_sig ),
      .fetch_pc_enable (fetch_pc_enable ),
      .aluOp (aluOp_sig ),
      .aluSrc (aluSrc_sig ),
      .RegWR (RW_sig_out ),
      .MemR (MemR ),
      .MemWR (MemWR ),
      .ldm (ldm ),
      .branch (branch ),
      .freeze_cu (freeze_cu ),
      .call (call ),
      .rti (rti ),
      .ret (ret ),
      .pc_sel (pc_sel ),
      .mem_data_sel (mem_data_sel ),
      .ccr (Ccr), //to change
      .clk (clk ),
      .rst (rst ),
      .instruction (IFIDReg[15:0] ),
      .pc_jmp  ( pc_jmp),
      .shift_amount (shift_amount),
      .Reg_data(Reg_data),
      .op1(op1),
      .I_op2 (I_op2),
      .R_op2(R_op2),
      .RW_In_addr(MEMOWB_Reg[2:0]),
      .RW_Out_addr(RW_Out_addr),
      .RW_Sig_in(MEMOWB_Reg[37]),
      .portR(portR),
      .portWR(portWR),
      .src_address(src_address)
    );
  

  //////////////////For Execute and Memory
  /////////////////////////Execute////////////////////////////////////
  Execution Execute(
      .op1( IDEReg[99:84]),
      .op2( IDEReg[83:68]),
      .inport(inputPort),
      .immediate( IDEReg[67:52]),
      .shiftAmmount({8'b0,IDEReg[116:109]}),   //modified
      .AluOp( IDEReg[106:102]),
      .AluScr(IDEReg[101:100]),
      .Inport(IDEReg[117]),   //modified
      .Branch(IDEReg[41]),
      .ExecuteMemoryForwarding(EXMEMO_Reg[78:63]),
      .MemoryWBForwarding(Reg_data),
      .Forward1Sel( Forward1Sel),
      .Forward2Sel( Forward2Sel),
      .Ccr(Ccr),
      .MemoryAddress(MemoryAddress),  // you have to send the memoaddress that exists in the buffer IDEReg
      .Out(Out_Excute)
);
FullForwardingUnit fullforwardingunit(.CurrentRsrcAddress(IDEReg[121:119]),.CurrentRdstAddress(IDEReg[51:49]),.WriteMemoWriteBackAddress(),.WriteExcuMemoAddress(),.SelectionSignalRcs(Forward1Sel),.SelectionSignalRds(Forward2Sel));
/////////////////////////////////////////////////////////////Memory////////////////////////////////////////////////////////

DataMemory Date_Memory (.clk(clk),
                    .rst(rst),
                    .MR(EXMEMO_Reg[48]),
                    .MW(EXMEMO_Reg[47]),
                    .MemoAddreess(EXMEMO_Reg[62:51]),
                    .Ccr(EXMEMO_Reg[81:79]),
                    .AluOut(EXMEMO_Reg[78:63]),
                    .PcLow(EXMEMO_Reg[15:0]),
                    .PcHigh(EXMEMO_Reg[31:16]),
                    .sel1(EXMEMO_Reg[33:32]),
                    .sel2(EXMEMO_Reg[36]),
                    .Out1(Out_Memo));
/////////////////////////////////////////////////////////////Write Back///////////////////////////////////////////////////////
   //=>//[37]==>writeout
          //[36:21]Aluout
                        //=>[20:5]memoout
                        //=>[4]outPort
                        //=>[3]Memo/Alu select
                        //=>[2:0]write back reg
WriteBack Write_Back(
  .Load( MEMOWB_Reg[20:5]),
  .Rd( MEMOWB_Reg[36:21]),
  .Wb( MEMOWB_Reg[3]),
  .Port_Write(MEMOWB_Reg[4]),
  //.output_port_pervious(16'b0),//Eman
  .Write_Data(Reg_data),
  .output_port(outputPort));
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



  
always @ (posedge clk, posedge rst)
    begin
      if(rst)
      begin
        IFIDReg  = 0;
        IDEReg = 0;
        IDEPC_Reg = 0;
        EXMEMO_Reg = 0;
        MEMOWB_Reg = 0;
      end
      else// if(clk)    //and ~aluSrc_sig
      begin
        MEMOWB_Reg ={EXMEMO_Reg[38],EXMEMO_Reg[78:63],Out_Memo, EXMEMO_Reg[50],EXMEMO_Reg[37], EXMEMO_Reg[41:39]};
        EXMEMO_Reg ={Ccr,Out_Excute,MemoryAddress[11:0],
                    IDEReg[118],IDEReg[117],IDEReg[108],IDEReg[107],
                    IDEReg[106:102],IDEReg[51:49],IDEReg[48],IDEReg[47],
                   IDEReg[43],IDEReg[41],IDEReg[40],IDEReg[33:32],IDEReg[31:0]};
        IDEPC_Reg = IFIDReg[47:16];
        IDEReg [121:119] = src_address;
        IDEReg [118:0] = {portWR, portR, shift_amount,MemR, MemWR, aluOp_sig, aluSrc_sig, op1, R_op2,I_op2, 
                  RW_Out_addr, RW_sig_out, mem_to_Reg_sig, pop_pc1_sig, pop_pc2_sig,
                  pop_ccr_sig, stack_sig, fetch_pc_enable, branch, ldm, freeze_cu, call, ret,
                  rti, pc_sel, mem_data_sel, pc_jmp};
        IFIDReg  = {16'b0, pc, instruction};  
        Reg_data_2 = Reg_data;
      end
    end





  // always @ (posedge clk, posedge rst)
//     begin
//       if(rst)
//       begin
//         IFIDReg  = 0;
//         IDEReg = 0;
//         IDEPC_Reg = 0;
//         EXMEMO_Reg = 0;
//         MEMOWB_Reg = 0;
//       end
//       else
//       begin
//         MEMOWB_Reg = MEMOWB_Reg_pre;
//         EXMEMO_Reg = EXMEMO_Reg_pre;
//         IDEPC_Reg = IDEPC_Reg_pre;
//         IDEReg = IDEReg_pre;
//         IFIDReg  = IFIDReg_pre;
//         Reg_data_2 = Reg_data;
//       end
//     end



//     always @ (negedge clk, posedge rst)
//     begin
//       if(rst)
//       begin
//         IFIDReg_pre  = 0;
//         IDEReg_pre = 0;
//         IDEPC_Reg_pre = 0;
//         EXMEMO_Reg_pre = 0;
//         MEMOWB_Reg_pre = 0;
//       end
//       else
//       begin
//         MEMOWB_Reg_pre ={EXMEMO_Reg_pre[38],EXMEMO_Reg_pre[78:63],Out_Memo, EXMEMO_Reg_pre[50],EXMEMO_Reg_pre[37], EXMEMO_Reg_pre[41:39]};
//         EXMEMO_Reg_pre ={Ccr,Out_Excute,MemoryAddress[11:0],
//                     IDEReg_pre[118],IDEReg_pre[117],IDEReg_pre[108],IDEReg_pre[107],
//                     IDEReg_pre[106:102],IDEReg_pre[51:49],IDEReg_pre[48],IDEReg_pre[47],
//                    IDEReg_pre[43],IDEReg_pre[41],IDEReg_pre[40],IDEReg_pre[33:32],IDEReg_pre[31:0]};
//         IDEPC_Reg_pre = IFIDReg_pre[47:16];
//         IDEReg_pre [121:119] = src_address;
//         IDEReg_pre [118:0] = {portWR, portR, shift_amount,MemR, MemWR, aluOp_sig, aluSrc_sig, op1, R_op2,I_op2, 
//                   RW_Out_addr, RW_sig_out, mem_to_Reg_sig, pop_pc1_sig, pop_pc2_sig,
//                   pop_ccr_sig, stack_sig, fetch_pc_enable, branch, ldm, freeze_cu, call, ret,
//                   rti, pc_sel, mem_data_sel, pc_jmp};
//         IFIDReg_pre  = {16'b0, pc, instruction};  
//         Reg_data_2 = Reg_data;
//       end
//     end


endmodule




