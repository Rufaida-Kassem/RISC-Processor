module Processor (
    clk, rst, start
  );
  input clk, rst, start;
  wire [15:0] instruction;
  wire [31:0] pc;
  wire [1:0] aluSrc_sig;
  reg [63:0] IFIDReg;  // 0000_0000_0000_0000 - PC[47:16] - instruction[15:0]
  reg [63:0] IDEReg;   // 4'b0 - MemR_sig[59] - MemWR_sig[58] - aluOp_sig (5 bits)[57:53] - aluSrc_sig[52] - op1[51:36] (value of first reg) - R_op2[35:20] (value of second reg) to be saved for WB - I_op2[19:4] (immediate) - RW_Out_addr[3:1] dest address - RW_sig_out[0]
  reg [31:0] IDEPCReg; // we separte it to reduce the size in case we put all in reg (as we will need to keep the size log to the base 2)
  wire MemR_sig, MemWR_sig, RW_siga_out, RW_Sig_in, Mem_to_Reg; //signals 3ady
  wire [15:0] I_op2, R_op2, op1, Reg_data;  // out from the IF  --  out from ID  --  out of ID  --  Back to ID (WB)
  wire [4:0] aluOp_sig;  //signal 3ady
  wire [2:0] RW_Out_addr, RW_In_addr;   // out from ID  --  back from ID  -->  they are equal shifted :|
//                                                                                                                                                       000000001000xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_0001001000100000_001_1
  //////////////////For Execute and Memory
  reg [36:0] EXMEMO_Reg;
  reg [35:0] MEMOWB_Reg;
  wire [2:0]Ccr;
  wire [15:0] MemoryAddress;
  wire [15:0] Out_Excute;
  wire [15:0] Out_Memo;

  wire fetch_enable, decode_enable;
  wire ldm;

  wire pc_to_stack_1, pc_to_stack_2, stack, ccr_to_stack, pc_intr_handler;

  reg     [2:0] current_state, next_state;
  parameter idle_state = 0, fetch_state = 1, decode_state = 2, execute_state = 3, memory_state = 4, write_back_state = 5;

  IF
    IF_dut (
      .enable(fetch_enable),
      .clk (clk ),
      .rst ( rst ),
      .pc (pc ),
      .instruction  ( instruction)  //output
    );


  ID 
    ID_dut (
      .enable (enable ),
      .load_use (1'b0 ),
      .clk (clk ),
      .rst (rst ),
      .instruction (instruction ),
      .op1 (op1 ),
      .R_op2 (R_op2 ),
      .I_op2 (I_op2 ),
      .RW_Out_addr (RW_Out_addr ),
      .RW_In_addr (RW_In_addr ),
      .aluOp_sig (aluOp_sig ),
      .RW_sig_out (RW_sig_out ),
      .Mem_to_Reg(Mem_to_Reg),
      .aluSrc_sig (aluSrc_sig ),
      .MemWR_sig (MemWR_sig ),
      .MemR_sig (MemR_sig ),
      .RW_Sig_in (RW_Sig_in ),
      .Reg_data (Reg_data ),
      .ldm (ldm ),
      .pc_to_stack_1 (pc_to_stack_1 ),
      .pc_to_stack_2 (pc_to_stack_2 ),
      .stack (stack ),
      .pc_intr_handler (pc_intr_handler ),
      .ccr_to_stack  ( ccr_to_stack)
    );


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




  //////////////////For Execute and Memory
  /////////////////////////Execute////////////////////////////////////
  Execution  Execute(.op1( IDEReg[51:36]),
                     .op2( IDEReg[35:20]),
                     .immediate( IDEReg[19:4]),
                     .AluOp( IDEReg[55:53]),
                     .AluScr( IDEReg[52]),
                     .Mr( IDEReg[59] ),
                     .Mw( IDEReg[58]),
                     .Ccr(Ccr),
                     .MemoryAddress(MemoryAddress),
                     .Out(Out_Excute)
                    );
  ///////////////////////////Memory//////////////////////////////////

  Memory #(.addBusWidth(12), .width(16), .instrORdata(0))
         Date_Memory (
           .clk (clk ),
           .rst ( rst ),
           .memR ( EXMEMO_Reg[5] ),
           .memWR ( EXMEMO_Reg[4] ),
           .dataWR ( EXMEMO_Reg[33:18] ),
           .addR (EXMEMO_Reg[17:6] ),
           .addWR ( EXMEMO_Reg[17:6] ),
           .dataR  ( Out_Memo)
         );

  /////////////////////////////Write Back////////////////////////////////
  WriteBack Write_Back(.Load( MEMOWB_Reg[35:20]),
                       .Rd( MEMOWB_Reg[19:4]),
                       .Wb( MEMOWB_Reg[3]),
                       .WriteData( Reg_data)
                      );


    assign fetch_enable  = 1'b1;
    assign decode_enable  = 1'b1;

    
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
        MEMOWB_Reg ={Out_Excute,Out_Memo, EXMEMO_Reg[3], EXMEMO_Reg[2:0]};
        EXMEMO_Reg ={Ccr,Out_Excute,MemoryAddress[12:0],IDEReg[59], IDEReg[58],IDEReg[0],IDEReg[3:1]};
        IDEPCReg = IFIDReg[47:16];
        IDEReg = {3'b0,MemR_sig, MemWR_sig, aluOp_sig, aluSrc_sig, op1, R_op2, instruction, RW_Out_addr, RW_sig_out};
        IFIDReg  = {16'b0, pc, instruction};
        
        
      end
    end


    endmodule
