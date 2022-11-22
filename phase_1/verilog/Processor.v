module Processor (
    clk, rst
  );
  input clk, rst;


  wire [15:0] instruction;
  wire [31:0] pc;
  reg [63:0] IFIDReg_new;
  reg [63:0] IFIDReg_old;
  reg [63:0] IDEReg_new;
  reg [63:0] IDEReg_old;
  reg [31:0] IDEPCReg_new;
  reg [31:0] IDEPCReg_old;
  wire MemR_sig, MemWR_sig, RW_sig_out, aluSrc_sig, RW_Sig_in;
  wire [15:0] I_op2, R_op2, op1, Reg_data;
  wire [4:0] aluOp_sig;
  wire [2:0] RW_Out_addr, RW_In_addr; 

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
    . rst ( rst ),
    .pc (pc ),
    .instruction  ( instruction)
  );

    ID 
    ID_dut (
      .instruction (IFIDReg_old ),
      .op1 (op1 ),
      . R_op2 ( R_op2 ),
      . I_op2 ( I_op2 ),
      .RW_Out_addr (RW_Out_addr ),
      .RW_In_addr (MEMOWB_Reg_old[2:0]),
      .aluOp_sig (aluOp_sig ),
      .RW_sig_out (RW_sig_out ),
      . aluSrc_sig ( aluSrc_sig ),
      . MemWR_sig ( MemWR_sig ),
      . MemR_sig ( MemR_sig ),
      .RW_Sig_in (RW_Sig_in ),
      .Reg_data  ( Reg_data)
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
 DataMemory Date_Memory(.MR( EXMEMO_Reg_old[5]  ),
                    .MW( EXMEMO_Reg_old[4] ),
                    .clk(clk),
                    .rst(rst),
                    .MemoAddreess(EXMEMO_Reg_old[17:6]),
                    .data( EXMEMO_Reg_old[33:18]),
                    .Out(Out_Memo));
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
      IFIDReg_new = {16'b0, pc, instruction};
    end
    else
    begin
      if(IDEReg_old[48] == 1'b1)
      begin
        IDEReg_old[15:0] = IDEReg_new[15:0];
      end
      else
      begin
        IDEReg_old = IDEReg_new;
      end
      IDEPCReg_old = IDEPCReg_new;
      EXMEMO_Reg_old= EXMEMO_Reg_new;
     MEMOWB_Reg_old=MEMOWB_Reg_new;
      IFIDReg_old = IFIDReg_new;
      IFIDReg_new = {16'b0, pc, instruction};
    end

  end

  always @(negedge clk )
  begin
    IDEReg_new = {4'b0,MemR_sig, MemWR_sig, aluOp_sig, aluSrc_sig, op1, R_op2, I_op2, RW_Out_addr, RW_sig_out};
    IDEPCReg_new = IFIDReg_old[47:16];
//=============================================Execute - Memory Buffer============================================//
// can get Error[12:0]
//{IDEReg_old[0]==Write Back sig,IDEReg_old[3:1]==Write Back Address}
    EXMEMO_Reg_new={Ccr,Out_Excute,MemoryAddress[12:0],MemR_sig, MemWR_sig,IDEReg_old[0],IDEReg_old[3:1]};
//=============================================Memory - Write Back Buffer========================================//
    MEMOWB_Reg_new={Out_Excute,Out_Memo, EXMEMO_Reg_old[3], EXMEMO_Reg_old[2:0]};
  end         
endmodule

