module ID #(parameter width = 16) (
    clk, instruction, MemR, MemWR, aluSrc, RegWR, aluOp, I_op2
  );
  reg ack;
  wire fetchOp2;
  input clk;
  input [width - 1 : 0] instruction;
  reg [2 : 0] read_addr1, read_addr2;
  output reg [2 : 0] op1, R_op2, I_op2;
  output [2 : 0] RW_Out_addr;  //address
  input [2 : 0] RW_In_addr;
  reg [4:0] opCode;
  output reg [4:0] aluOp_sig;
  output reg RW_sig_out, aluSrc_sig, MemWR_sig, MemR_sig ;  //signal
  input RW_Sig_in;
  input [15:0] Reg_data;

  //reg data back -- enable -- address
  // input       -- out in  -- out in

  RegFile
    RegFile_dut (
      .read_enable ('b1 ),
      .write_enable ( RW_sig ),
      .clk (clk ),
      .rst ( rst ),
      .write_data (write_data ),
      .read_data1 (read_data1 ),
      .read_data2 (read_data2 ),
      .read_addr1 (read_addr1 ),
      .read_addr2 (read_addr2 ),
      .write_addr  ( RW_In)
    );


  controlUnit
    controlUnit_dut (
      .clk (clk ),
      .opCode (opCode ),
      .aluOp (aluOp ),
      .RegWR (RW_sig),
      .MemR (MemR ),
      .MemWR (MemWR ),
      .aluSrc (aluSrc ),
      .stall (fetchOp2 ),
      .ackIn  ( ackIn)
    );



  always @(posedge clk)
  begin
    //TODO: decode the op code
    if(fetchOp2 == 1'b0)
    begin
      ack = 'b0;
      opCode <= instruction  [width - 1 : width - 5];
      read_addr1 <= instruction[width - 6 : width - 8];
      read_addr2 <= instruction[width - 9 : width - 11];
      read_enable <= 'b1;
      write_addr <= instruction[width - 12 : width - 14];
      op1 <= instruction[width]
    end
    else
    begin
      ack = 1'b1;
      I_op2 = instruction[width - 1 : 0];
    end
  end
endmodule
