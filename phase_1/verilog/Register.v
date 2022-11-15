module Register #(parameter N = 16) (r_enable, w_enable, read_data, write_data, rst, clk);
  input r_enable, w_enable, clk, rst;
  input [N-1:0] write_data;
  output reg[N-1:0] read_data;
  reg [N-1:0]data;

  always @(negedge clk, posedge rst)
  begin
    if(rst)
    begin
      data = 0;
    end
    else if(w_enable)
    begin
      data = write_data;
    end
  end


  always @(posedge clk, posedge rst)
  begin
    if(rst)
      read_data = 'bz;
    else if(r_enable)
    begin
      read_data = data;
    end
    else
    begin
      read_data = 'bz;
    end
  end

endmodule
