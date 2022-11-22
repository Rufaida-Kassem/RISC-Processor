module Processor_tb;

  reg clk = 0;
  reg  rst = 0;
  Processor 
  Processor_dut (
    .clk (clk ),
    . rst  (  rst)
  );
  initial begin
    begin
        rst = 1'b1;
        #10
        rst = 1'b0;
      $finish;
    end
  end

  always
    #5  clk = ! clk ;

endmodule
