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
      .RW_In_addr (RW_In_addr ),
      .aluOp_sig (aluOp_sig ),
      .RW_sig_out (RW_sig_out ),
      . aluSrc_sig ( aluSrc_sig ),
      . MemWR_sig ( MemWR_sig ),
      . MemR_sig ( MemR_sig ),
      .RW_Sig_in (RW_Sig_in ),
      .Reg_data  ( Reg_data)
    );
  

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

      IFIDReg_old = IFIDReg_new;
      IFIDReg_new = {16'b0, pc, instruction};
    end

  end

  always @(negedge clk )
  begin
    IDEReg_new = {4'b0,MemR_sig, MemWR_sig, aluOp_sig, aluSrc_sig, op1, R_op2, I_op2, RW_Out_addr, RW_sig_out};
    IDEPCReg_new = IFIDReg_old[47:16];
  end         
endmodule

