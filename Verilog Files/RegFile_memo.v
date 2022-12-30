module RegFile_memo #(parameter N = 16) (read_enable,write_enable, read_data1, read_data2, write_data, clk,rst, read_addr1, read_addr2, write_addr);
  input read_enable, write_enable, clk, rst;
  input [N-1:0] write_data;
  output reg [N-1:0]read_data1;
  output reg [N-1:0]read_data2;
  input[2:0] read_addr1;
  input[2:0] read_addr2;
  input[2:0] write_addr;
  integer i;
  reg[N-1:0]arr_regs[7:0];

  always @(posedge clk, posedge rst)
  begin
    if(rst)
    begin
      for(i = 0; i < 8; i=i+1)
      begin
        arr_regs[i] = 0;//
      end
    end
    else if(write_enable)
    begin
      //arr_regs[write_addr] = 16'b1;
      arr_regs[write_addr] = write_data;
    end
  end

  always @(negedge clk, posedge rst)
  begin
    if(rst)
    begin
      read_data1= 'bz;
      read_data2 = 'bz;
    end
    else if(read_enable)
    begin
      read_data1 = arr_regs[read_addr1];
      read_data2 = arr_regs[read_addr2];
    end
    else
    begin
      read_data1 = 'bz;
      read_data2 = 'bz;
    end
  end

endmodule
