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
  Execution
    Execute(
      .op1( IDEReg[99:84]),
      .op2( IDEReg[83:67]),
      .inport(inputPort),
      .immediate( IDEReg[66:51]),
      .shiftAmmount({8'b0,IDEReg[116:109]}),   //modified
      .AluOp( IDEReg[106:102]),
      .AluScr(IDEReg[101:100]),
      .Inport(IDEReg[117]),   //modified
      .Branch(IDEReg[41]),
      .ExecuteMemoryForwarding(EXMEMO_Reg[15:30]),
      .MemoryWBForwarding(Reg_data),
      .Forward1Sel(2'b0),
      .Forward2Sel(2'b0),
      .Ccr(Ccr),
      .MemoryAddress(IDEReg[78:67]),  // you have to send the memoaddress that exists in the buffer IDEReg
      .Out(Out_Excute)
);
FullForwardingUnit fullforwardingunit(.CurrentRsrcAddress(),.CurrentRdstAddress(),.WriteMemoWriteBackAddress(),.WriteExcuMemoAddress,
                           output reg[1:0] SelectionSignalRcs, output reg[1:0] SelectionSignalRds
                           );
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