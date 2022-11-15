module ID #(parameter width = 16) (
    clk, instruction, MemR, MemWR, aluSrc, RegWR, aluOp, Op2Immid
  );
  input clk;
  input [width - 1 : 0] instruction;
  output read_enable;
  output [5 - 1 : 0] read_addr1, read_addr2;
  output [5 - 1 : 0] write_addr;
  output wire [2:0] aluOp, opCode;
  output wire RegWR, MemWR, MemR ;
  output wire aluSrc;
  output wire Op2Immid;
  reg fetchOp2 = 'b0;
  reg [2:0]opCode;

  assign Op2Immid = instruction;
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
    if(fetchOp2 == 1'b0)
    begin opCode <= instruction  [width - 1 : width - 5];
    read_addr1 <= instruction[width - 6 : width - 8];
    read_addr2 <= instruction[width - 9 : width - 11];
    read_enable <= 'b1;
    write_addr <= instruction[width - 12 : width - 14];
    end 
  end
endmodule
