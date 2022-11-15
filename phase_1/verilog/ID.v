module ID #(parameter width = 16) (
    clk, instruction, MemR, MemWR, aluSrc, RegWR, aluOp, Op2Immid
  );
  reg ack;
  wire fetchOp2;
  input clk;
  input [width - 1 : 0] instruction;
  output read_enable;
  reg [2 : 0] read_addr1, read_addr2;
  output reg [2 : 0] op1, R_op2, I_op2;
  output [2 : 0] write_addr;
  reg [4:0] opCode;
  output reg [4:0] aluOp;
  output wire RegWR, aluSrc, MemWR, MemR ;
  RegFile
    RegFile_dut (
      .read_enable (read_enable ),
      . write_enable ( write_enable ),
      .clk (clk ),
      . rst ( rst ),
      .write_data (write_data ),
      .read_data1 (read_data1 ),
      .read_data2 (read_data2 ),
      .read_addr1 (read_addr1 ),
      .read_addr2 (read_addr2 ),
      .write_addr  ( write_addr)
    );


  controlUnit
    controlUnit_dut (
      .clk (clk ),
      .opCode (opCode),
      .aluOp (aluOp ),
      .RegWR (RegWR ),
      .MemR (MemR ),
      .MemWR (MemWR ),
      .aluSrc  ( aluSrc)
    );



  always @(posedge clk)
  begin
    //TODO: decode the op code
    if(fetchOp2 == 1'b0)
    begin
      opCode <= instruction  [width - 1 : width - 5];
      read_addr1 <= instruction[width - 6 : width - 8];
      read_addr2 <= instruction[width - 9 : width - 11];
      read_enable <= 'b1;
      write_addr <= instruction[width - 12 : width - 14];
    end
    else
    begin
      ack = 1'b1;
      I_op2 = instruction[width - 1 : 0];

    end
  end
endmodule
