`timescale 1ns/1ns
module Processor_tb;

  reg clk = 0;
  reg  rst = 0;
  reg  start = 0;
  wire [15:0] outputPort;
  wire [15:0] inputPort;
  reg interrupt;
  reg raise_interrupt;
  wire ack;
  // Processor
  //   Processor_dut (
  //     .clk (clk ),
  //     .rst  ( rst),
  //     .start (start)
  //   );
//assign interrupt = raise_interrupt ? 1'b1 : interrupt;

Processor
  Processor_dut (
    .clk (clk ),
    .rst (rst ),
    .start (start ),
    .outputPort (outputPort ),
    .inputPort (inputPort ),
    .interrupt  ( interrupt),
    .ack(ack)
  );



  initial
  begin
    begin
      rst = 1'b1;
      interrupt = 1'b0;
      #20
       rst = 1'b0;
      start = 1'b1;

      #30
      interrupt = 1'b1;



    end
  end

  always @ (ack)
  begin
    if(ack)
      interrupt = 1'b0;
  end

  always
    #10  clk = ! clk ;

endmodule
