module Processor_tb;

  reg clk = 0;
  reg  rst = 0;
  Processor 
  Processor_dut (
    .clk (clk ),
    .rst  ( rst)
  );
  initial begin
    begin
        rst = 1'b1;
        #20
        rst = 1'b0;

    end
  end

  always
    #10  clk = ! clk ;

endmodule
