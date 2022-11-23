module ID #(parameter width = 16) (
    instruction, RW_sig_out, aluSrc_sig, MemWR_sig, MemR_sig, RW_Sig_in, Reg_data, aluOp_sig, op1, R_op2, I_op2, RW_Out_addr, RW_In_addr, clk, rst
  );
  input clk, rst;
  input [width - 1 : 0] instruction;
  wire [2 : 0] read_addr1, read_addr2;   // to read from RegFile
  output [15 : 0] op1, R_op2, I_op2;
  output [2 : 0] RW_Out_addr;  //address
  input [2 : 0] RW_In_addr;
  wire [4:0] opCode;
  output wire [4:0] aluOp_sig;
  output wire RW_sig_out, aluSrc_sig, MemWR_sig, MemR_sig ;  //signal
  input RW_Sig_in;
  input [15:0] Reg_data;

  //reg data back -- enable -- address
  // input       -- out in  -- out in

    RegFile_memo 
    RegFile_memo_dut (
      .read_enable (read_enable ),
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
      .opCode (opCode ),
      .aluOp (aluOp_sig ),
      .RegWR (RW_sig_out ),
      .MemR (MemR_sig ),
      .MemWR (MemWR_sig ),
      .aluSrc  ( aluSrc_sig)
    );

  assign opCode = instruction  [width - 1 : width - 5];
  assign read_addr1 = instruction[width - 6 : width - 8];
  assign read_addr2 = instruction[width - 9 : width - 11];
  assign read_enable = 1'b1;
  assign RW_Out_addr = instruction[width - 9 : width - 11];  //instruction[width - 12 : width - 14];
  assign I_op2 = instruction[width - 1 : 0];
endmodule
