module sp_value(input [31:0] sp_in,output reg[31:0] sp_out,input rst);
always @* begin
if(rst) begin
sp_out = 2047;
end else begin
sp_out = sp_in;
end
end

endmodule