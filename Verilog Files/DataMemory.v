module DataMemory (input MR,
                    input MW,
                    input clk,
                    input rst,
                    input[11:0] MemoAddreess,
                    input[15:0] data,
                    output reg[15:0] Out
                                        );
reg [15:0] memo[0:2**11];
integer i;
always @(posedge clk,posedge rst) begin
 if(rst) begin
  for(i=0;i<(2**11);i=i+1)begin
       memo[i]=0;  
  end
 end
else if(MW==1'b1) begin
memo[MemoAddreess]=data;
end
end

always @(negedge clk,posedge rst) begin
if(rst) begin
Out=16'b0;
 end
else if(MR==1'b1) begin
Out=memo[MemoAddreess];
end
end
endmodule
