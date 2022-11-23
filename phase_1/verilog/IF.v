module pcCircuit #(parameter addressWidth = 32) (
    clk, rst, addR
  );
  input clk, rst;
  output reg [addressWidth - 1 : 0] addR;  // pc
  reg [addressWidth - 1 : 0] pc;

  //pc circuit
  always @(posedge clk , posedge rst)
  begin
    if(rst)
    begin
      pc <= 32'h20;   // the first location as we leave the first part for the interrupt
    end
    else if (clk)
    begin
      pc <= pc + 1;  //word addressable so add only 1
      addR <= pc;    //update it before increasing the PC   (non-blocking)
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

  Memory #( .addBusWidth(20), .width(16), .instrORdata(1) )
    instructions_memory  (
      .clk (clk ),
      .rst ( rst ),
      .memR ( 1'b1 ),    //we always read from it only (enabled 3la tool mesh mehtaga signal)
      .addR (pc[19:0]),  // address to read the instruction
      .dataR  (instruction),  // output

      .memWR ( 1'b0 ),   // disable 3la tool
      .dataWR (16'b0),   // nothing 3la tool
      .addWR (20'b0)     // nothing 3la tool
    );
    pcCircuit
    pcCircuit_dut (
      .clk (clk ),
      .rst ( rst ),
      .addR  ( pc)  // to update the pc only
    );


endmodule

