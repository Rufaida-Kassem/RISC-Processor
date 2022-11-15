module RegFile #(parameter N = 16)(read_enable,write_enable, read_data1, read_data2, write_data, clk,rst, read_addr1,read_addr2, write_addr);
input read_enable, write_enable,clk, rst;
input [N-1:0] write_data;
output wire[N-1:0]read_data1;
output wire[N-1:0]read_data2;
//wire [N-1:0]read_data_send;
input[2:0] read_addr1;
input[2:0] read_addr2;
input[2:0] write_addr;
wire [7:0]arr_read_enable;
wire [7:0]arr_write_enable;  //we can only drive wires with a continuous assign   (wrong --> from dr.dina, we can drive regs as well 
//wire [N-1:0]arr_read_data[7:0];
integer j;

//hint --> here we send the same read_data to all reg   why ?
//cause inside the reg module, we put tri-state buffer which means that the reg_i won't write the value of the its data unless read_data of it = 1
genvar i;
generate
for(i = 0; i <= 7; i=i+1)
Register #(N) regs (arr_read_enable[i]&read_enable, arr_write_enable[i]&write_enable, read_data, write_data, rst, clk);
endgenerate


Decoder D_R1(read_addr1, arr_read_enable);
Decoder D_R2(read_addr2, arr_read_enable);

Decoder D_W(write_addr, arr_write_enable);



//assign read_data = arr_read_data[read_addr];

endmodule
