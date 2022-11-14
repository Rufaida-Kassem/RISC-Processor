module ID #(parameter width = 16) (
    clk, instruction, read_enable, read_addr1, read_addr2, write_addr, MemR, MemWR, aluSrc, RegWR, aluOp
  );
  input clk;
  input [width - 1 : 0] instruction;
  output read_enable;
  output [5 - 1 : 0] read_addr1, read_addr2;
  output [5 - 1 : 0] write_addr;
  output wire [2:0] aluOp, opCode;
  output wire RegWR, aluSrc, MemWR, MemR ;
  reg [2:0]opCode;
  RegFile 
  RegFile_dut (
    .read_enable (read_enable ),
    . write_enable ( write_enable ),
    .clk (clk ),
    . rst ( rst ),
    .write_data (write_data ),
    .read_data (read_data ),
    .read_addr (read_addr ),
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
    opCode <= instruction  [width - 1 : width - 3];
    

    read_addr1 <= instruction[25 : 21];
    read_addr2 <= instruction[20 : 16];
    read_enable <= 'b1;
    write_addr <= instruction[15 : 11];
  end
endmodule
