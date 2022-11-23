module Processor (
    clk, rst
  );
  input clk, rst;


  wire [15:0] instruction;
  wire [31:0] pc;
  reg [63:0] IFIDReg_new;  // 0000_0000_0000_0000 - PC[47:16] - instruction[15:0]
  reg [63:0] IFIDReg_old;  // 0000_0000_0000_0000 - PC - instruction
  reg [63:0] IDEReg_new;   // 4'b0 - MemR_sig[59] - MemWR_sig[58] - aluOp_sig (5 bits)[57:53] - aluSrc_sig[52] - op1[51:36] (value of first reg) - R_op2[35:20] (value of second reg) to be saved for WB - I_op2[19:4] (immediate) - RW_Out_addr[3:1] dest address - RW_sig_out[0]
  reg [63:0] IDEReg_old;   // same as above
  reg [31:0] IDEPCReg_new; // we separate it to reduce the size in case we put all in reg (as we will need to keep the size log to the base 2)
  reg [31:0] IDEPCReg_old; // same as above
  wire MemR_sig, MemWR_sig, RW_sig_out, aluSrc_sig, RW_Sig_in; //signals 3ady
  wire [15:0] I_op2, R_op2, op1, Reg_data;  // out from the IF  --  out from ID  --  out of ID  --  Back to ID (WB)
  wire [4:0] aluOp_sig;  //signal 3ady
  wire [2:0] RW_Out_addr, RW_In_addr;   // out from ID  --  back from ID  -->  they are equal shifted :|

//////////////////For Execute and Memory
  reg [36:0] EXMEMO_Reg_new;
  reg [36:0] EXMEMO_Reg_old;
  reg [35:0] MEMOWB_Reg_new;
  reg [35:0] MEMOWB_Reg_old;
  wire [2:0]Ccr;
  wire [15:0] MemoryAddress;
  wire [15:0] Out_Excute;
  wire [15:0] Out_Memo;
   

  IF 
  IF_dut (
    .clk (clk ),
    .rst ( rst ),
    .pc (pc ),
    .instruction  ( instruction)  //output
  );

    ID 
    ID_dut (
      .instruction (IFIDReg_old[15:0]),    //input
      .op1 (op1 ),                         //output
      . R_op2 ( R_op2 ),                   //output
      . I_op2 ( I_op2 ),                   //output
      .RW_Out_addr (RW_Out_addr ),         //output
      .RW_In_addr (MEMOWB_Reg_old[2:0]),   //input
      .aluOp_sig (aluOp_sig ),  //output
      .RW_sig_out (RW_sig_out ),  //output
      .aluSrc_sig ( aluSrc_sig ), //output
      .MemWR_sig ( MemWR_sig ), //output
      .MemR_sig ( MemR_sig ),
      .RW_Sig_in (MEMOWB_Reg_old[3] ), //input --> WB 
      .Reg_data  ( Reg_data),  //input  --> WB
      .clk (clk ),
      .rst ( rst )
    );
  
//////////////////For Execute and Memory
/////////////////////////Execute////////////////////////////////////
  Execution  Execute(.op1( IDEReg_old[51:36]),
                     .op2( IDEReg_old[35:20]),
                     .immediate( IDEReg_old[19:4]),
                     .AluOp( IDEReg_old[55:53]), 
                     .AluScr( IDEReg_old[52]),
                     .Mr( IDEReg_old[59] ),
                     .Mw( IDEReg_old[58]),
                     .Ccr(Ccr),
                    .MemoryAddress(MemoryAddress),
                    .Out(Out_Excute)
                 );
///////////////////////////Memory//////////////////////////////////
//  DataMemory Date_Memory(.MR( EXMEMO_Reg_old[5]  ),
//                     .MW( EXMEMO_Reg_old[4] ),
//                     .clk(clk),
//                     .rst(rst),
//                     .MemoAddreess(EXMEMO_Reg_old[17:6]),
//                     .data( EXMEMO_Reg_old[33:18]),
//                     .Out(Out_Memo));

  Memory #(.addBusWidth(12), .width(16), .instrORdata(0))
  Date_Memory (
    .clk (clk ),
    .rst ( rst ),
    .memR ( EXMEMO_Reg_old[5] ),
    .memWR ( EXMEMO_Reg_old[4] ),
    .dataWR ( EXMEMO_Reg_old[33:18] ),
    .addR (EXMEMO_Reg_old[17:6] ),
    .addWR ( EXMEMO_Reg_old[17:6] ),
    .dataR  ( Out_Memo)
  );

/////////////////////////////Write Back////////////////////////////////
WriteBack Write_Back(.Load( MEMOWB_Reg_old[35:20]),
                 .Rd( MEMOWB_Reg_old[19:4]),
                 .Wb( MEMOWB_Reg_old[3]),
                 .WriteData( Reg_data)
               );
//////////////////////////////////////////////////////////////

  always @(posedge clk , posedge rst)
  begin
    if(rst)
    begin
      IFIDReg_new = {16'b0, pc, instruction};  // pc --> firs location (initialized by the pcCircuit)   --  instruction: available at half the cycle (-ve edge)
    end
    else
    begin
      IDEReg_old = IDEReg_new;
      IDEPCReg_old = IDEPCReg_new;
      EXMEMO_Reg_old= EXMEMO_Reg_new;
      MEMOWB_Reg_old=MEMOWB_Reg_new;
      IFIDReg_old = IFIDReg_new;
      IFIDReg_new = {16'b0, pc, instruction};
    end

  end

  always @(negedge clk )
  begin
    IDEReg_new = {4'b0,MemR_sig, MemWR_sig, aluOp_sig, aluSrc_sig, op1, R_op2, instruction, RW_Out_addr, RW_sig_out};
    IDEPCReg_new = IFIDReg_old[47:16];
//=============================================Execute - Memory Buffer============================================//
// can get Error[12:0]
//{IDEReg_old[0]==Write Back sig,IDEReg_old[3:1]==Write Back Address}
    EXMEMO_Reg_new={Ccr,Out_Excute,MemoryAddress[12:0],MemR_sig, MemWR_sig,IDEReg_old[0],IDEReg_old[3:1]};
//=============================================Memory - Write Back Buffer========================================//
    MEMOWB_Reg_new={Out_Excute,Out_Memo, EXMEMO_Reg_old[3], EXMEMO_Reg_old[2:0]};
  end         
endmodule

