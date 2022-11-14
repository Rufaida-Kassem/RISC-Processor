module RegFile_memo #(parameter N = 16) (read_enable,write_enable, read_data,write_data, clk,rst, read_addr,write_addr);
input read_enable, write_enable, clk, rst;
input [N-1:0] write_data;
output reg [N-1:0]read_data;
input[2:0] read_addr;
input[2:0] write_addr;
integer i;
reg[N-1:0]arr_regs[7:0];

always @(negedge clk, posedge rst)
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
arr_regs[write_addr] = write_data;//
end
end

always @(posedge clk, posedge rst)
begin
if(rst)
begin
read_data = 'bz;
end
else if(read_enable)
begin
read_data = arr_regs[read_addr];//
end
else 
begin
read_data = 'bz;  
end
end

endmodule
