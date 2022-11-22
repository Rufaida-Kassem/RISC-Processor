module pcCircuit #(parameter addressWidth = 32) (
    clk, rst, addR
  );
  input clk, rst;
  output reg [addressWidth - 1 : 0] addR;
  reg [addressWidth - 1 : 0] pc;

  //pc circuit
  always @(posedge clk , posedge rst)
  begin
    if(rst)
    begin
      pc <= 32'h20;
    end
    else if (clk)
    begin
      pc <= pc + 1;
      addR <= pc;  //update it before increasing the PC
    end
  end
endmodule


module IF (
    clk, rst, instruction, pc
  );

  input clk, rst;
  output [31:0] pc;
  output [15:0] instruction;

  assign pc [31:20] = 0;

  Memory #( .addBusWidth(20), .width(16) )
    instructions_memory  (
      .clk (clk ),
      .rst ( rst ),
      .memR ( 1'b1 ),
      .memWR ( 1'b0 ),
      .dataWR (16'b0),
      .addR (pc[19:0]),
      .addWR (20'b0),
      .dataR  (instruction),
      .instr_data(1'b1)
    );
    pcCircuit
    pcCircuit_dut (
      .clk (clk ),
      .rst ( rst ),
      .addR  ( pc)
    );


endmodule

