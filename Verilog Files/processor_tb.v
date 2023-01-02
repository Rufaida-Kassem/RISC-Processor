module Processor_tb;

  reg clk = 0;
  reg  rst = 0;
  reg  start = 0;
  wire [15:0] outputPort;
  reg [15:0] inputPort;
  wire interrupt;
  // Processor
  //   Processor_dut (
  //     .clk (clk ),
  //     .rst  ( rst),
  //     .start (start)
  //   );
assign interrupt = 1'b0;

Processor
  Processor_dut (
    .clk (clk ),
    .rst (rst ),
    .start (start ),
    .outputPort (outputPort ),
    .inputPort (inputPort ),
    .interrupt  ( interrupt)
  );



  initial
  begin
    begin
      rst = 1'b1;
      #20
       rst = 1'b0;
      start = 1'b1;
      inputPort = 16'h0019;

    end
      #70
  inputPort = 16'h000F;
      #20
  inputPort = 16'hF320;
  //     #20
  // inputPort = 16'hF320;
  end



  always
    #10  clk = ! clk ;

endmodule
