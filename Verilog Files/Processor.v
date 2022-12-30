module Processor (
  input clk, rst, start,
  output reg [15:0] outputPort,
  input [15:0] inputPort,
  inout interrupt
  );
  
  wire [15:0] instruction;
  wire [31:0] pc;
  reg [63:0] IFIDReg;  // 0000_0000_0000_0000 - PC[47:16] - instruction[15:0]
                        //pc 32
                        //instruction 16



  reg [118:0] IDEReg;   // portRW                   [118]
                        // portR                    [117]
                        // shift_amount  8bits      [116:109]         
                        // MemR_sig 1               [108]
                        // MemWR_sig 1              [107]
                        // aluOp_sig (5 bits)       [106:102]
                        // aluSrc_sig 2 bits        [101:100]
                        // op1 (value of first reg) 16 bits   [99:84]
                        // R_op2 (value of second reg) to be saved for WB  16 bits  [83:67]
                        // I_op2  (immediate)   16 bits       [66:51]
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

  reg [31:0] IDEPCReg; // we separate it to reduce the size in case we put all in reg (as we will need to keep the size log to the base 2)


  wire [1:0] aluSrc_sig, mem_data_sel;
  wire MemR, MemWR, RW_sig_out, RW_Sig_in; //signals 3ady
  wire [15:0] I_op2, R_op2, op1, Reg_data;  // out from the IF  --  out from ID  --  out of ID  --  Back to ID (WB)
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
  reg [85:0] EXMEMO_Reg; //86 bits ==>  all Control signals(15 bit)
                                        // Alu out(16 bit)
                                        // Address(12bit)
                                        // Ccr(3bits)
                                        // ALu op(5bits)
                                        // write address(3 bit)
                                        // Pc(32 bit)
  reg [35:0] MEMOWB_Reg;
  wire [2:0]Ccr;
  //wire [15:0] MemoryAddress;
  wire [15:0] Out_Excute;
  wire [15:0] Out_Memo;
  wire ldm;
  wire [31:0] pc_jmp;


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
      .instruction  ( instruction)  //output
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
      .ccr (3'b0 ), //to change
      .enable (decode_enable ),
      .clk (clk ),
      .rst (rst ),
      .instruction (IFIDReg[15:0] ),
      .pc_jmp  ( pc_jmp),
      .shift_amount (shift_amount),
      .Reg_data(Reg_data),
      .op1(op1),
      .R_op2(R_op2),
      .RW_In_addr(MEMOWB_Reg[2:0]),
      .RW_Out_addr(RW_Out_addr),
      .RW_Sig_in(MEMOWB_Reg[3]),
      .portR(portR),
      .portWR(portWR)
    );
  

  //////////////////For Execute and Memory
  /////////////////////////Execute////////////////////////////////////
//   Execution
//     Execute(
//       .op1( IDEReg[99:84]),
//       .op2( IDEReg[83:67]),
//       .inport(16'b0),
//       .immediate( IDEReg[66:51]),
//       .shiftAmmount(IDEReg[116:109]),   //modified
//       .AluOp( IDEReg[106:102]),
//       .AluScr(IDEReg[101:100]),
//       .Inport(IDEReg[117]),   //modified
//       .Branch(IDEReg[41]),
//       .ExecuteMemoryForwarding(16'b0),
//       .MemoryWBForwarding(16'b0),
//       .Forward1Sel(2'b0),
//       .Forward2Sel(2'b0),
//       .Ccr(Ccr),
//       .MemoryAddress(IDEReg[78:67]),  // you have to send the memoaddress that exists in the buffer IDEReg
//       .Out(Out_Excute)
// );

// Memory 
//   #(.addBusWidth(12), .width(16), .instrORdata(0))
//          Date_Memory (
//            .clk (clk ),
//            .rst ( rst ),
//            .memR ( EXMEMO_Reg[5] ),
//            .memWR ( EXMEMO_Reg[4] ),
//            .dataWR ( EXMEMO_Reg[33:18] ),
//            .addR (EXMEMO_Reg[17:6] ),
//            .addWR ( EXMEMO_Reg[17:6] ),
//            .dataR  ( Out_Memo)
//          );

//   /////////////////////////////Write Back////////////////////////////////
// WriteBack 
//   Write_Back(.Load( MEMOWB_Reg[35:20]),
//   .Rd( MEMOWB_Reg[19:4]),
//   .Wb( MEMOWB_Reg[3]),
//   .Port_Write(1'b0),
//   .output_port_pervious(16'b0),
//   .Write_Data(Reg_data),
//   .output_port(outputPort));

always @ (posedge clk, posedge rst)
    begin
      if(rst)
      begin
        IFIDReg  = 0;
        IDEReg = 0;
        IDEPCReg = 0;
        EXMEMO_Reg = 0;
        MEMOWB_Reg = 0;
      end
      else if(clk)    //and ~aluSrc_sig
      begin

        MEMOWB_Reg ={EXMEMO_Reg[33:18],Out_Memo, EXMEMO_Reg[3], EXMEMO_Reg[2:0]};
        EXMEMO_Reg ={Ccr, Out_Excute, IDEReg[78:67], IDEReg[108], IDEReg[107], IDEReg[48],
        1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0, aluOp_sig, IDEReg[51:49], pc};
        IDEPCReg = IFIDReg[47:16];
        IDEReg = {MemR, MemWR, aluOp_sig, aluSrc_sig, op1, R_op2, instruction, 
                  RW_Out_addr, RW_sig_out, mem_to_Reg_sig, pop_pc1_sig, pop_pc2_sig,
                  pop_ccr_sig, stack_sig, fetch_pc_enable, branch, ldm, freeze_cu, call, ret,
                  rti, pc_sel, mem_data_sel, pc_jmp};
        IFIDReg  = {16'b0, pc, instruction};  
      end
    end


endmodule


  // always @ (current_state, start, ldm)
//   begin
//     case (current_state)
//       idle_state:
//         if(start & ~rst)
//         begin
//           next_state  = fetch_state;
//         end
//       fetch_state:
//       begin
//         next_state  = decode_state;
//         fetch_enable  = 1'b1;
//       end
//       decode_state:
//       begin
//         next_state  = execute_state;
//         decode_enable = 1'b1;
//         IFIDReg  = {16'b0, pc, instruction};
//         fetch_enable = 1'b0;    
//         if(ldm)
//           fetch_enable = 1'b1;
//       end
//       execute_state:
//       begin
//         next_state  = memory_state;
//         fetch_enable  = 1'b0;
//         IDEReg = {4'b0,MemR_sig, MemWR_sig, aluOp_sig, aluSrc_sig, op1, R_op2, instruction, RW_Out_addr, RW_sig_out};
//         IDEPCReg = IFIDReg[47:16];
//         decode_enable  = 1'b0;
        
//         //fetch_enable = 1'b0;  //changed here doaa
//       end
        
//       memory_state:
//       begin
//         next_state  = write_back_state;
//         //[85:83] ==> Ccr
//         //[82:67] ==> ALuout
//         //[66:55] ==> Memoryaddress
//         //[54:40] ==> ControlSignals
//         //[39:35] ==> Alu op ==> must take from decode buffer need bits
//         //[34:32] ==> Write address
//         //[31:0] ==> Pc
//         EXMEMO_Reg ={Ccr,Out_Excute,MemoryAddress[11:0],IDEReg[59], IDEReg[58],IDEReg[0],1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,aluOp_sig,IDEReg[3:1],pc};
//       end
//       write_back_state:
//       begin
//         next_state  = fetch_state;
//         //[35:20] ==> ALu out
//         //[19:4] ==> Memout
//         //[3] ==> wb selector
//         //[2:0] reg address
//         MEMOWB_Reg ={EXMEMO_Reg[33:18],Out_Memo, EXMEMO_Reg[3], EXMEMO_Reg[2:0]};
//       end
//       default:
//         next_state = idle_state;
//     endcase
//   end

//     always @ (posedge clk or posedge rst)
//     begin
//       if (rst)
//         current_state  = idle_state;
//       else
//         if(clk)    //and ~aluSrc_sig
//         begin
//           current_state  = next_state;
//         end
//     end











     // ID
  //   ID_dut (
  //     .enable(decode_enable),
  //     .instruction (IFIDReg[15:0]),    //input
  //     .op1 (op1 ),                         //output
  //     . R_op2 ( R_op2 ),                   //output
  //     . I_op2 ( I_op2 ),                   //output
  //     .RW_Out_addr (RW_Out_addr ),         //output
  //     .RW_In_addr (MEMOWB_Reg[2:0]),   //input
  //     .aluOp_sig (aluOp_sig ),  //output
  //     .RW_sig_out (RW_sig_out ),  //output
  //     .aluSrc_sig ( aluSrc_sig ), //output
  //     .MemWR_sig ( MemWR_sig ), //output
  //     .MemR_sig ( MemR_sig ),
  //     .RW_Sig_in (MEMOWB_Reg[3] ), //input --> WB
  //     .Reg_data  ( Reg_data),  //input  --> WB
  //     .clk (clk ),
  //     .rst ( rst ),
  //     .ldm(ldm)
  //   );
