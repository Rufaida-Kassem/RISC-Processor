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
    clk, rst, instruction
  );
  input clk, rst;
  wire pc;
  output [15:0] instruction;

  pcCircuit
    pcCircuit_dut (
      .clk (clk ),
      .rst ( rst ),
      .addR  ( pc)
    );
  Memory
    instructions_memory #(20, 32) (
      .clk (clk ),
      .rst ( rst ),
      .memR ( 'b1 ),
      .memWR ( 'b0 ),
      .dataWR (0),
      .addR (pc),
      .addWR (0),
      .dataR  (instruction)
    );


endmodule

