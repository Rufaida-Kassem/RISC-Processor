module jumpConditionally(input flag,Enable,output flagChanged,output signalJump);
always @* begin
if(Enable) begin
assign signalJump = (flag == 1'b1) ? 1'b1:1'b0;
assign flagChanged = 1'b0;
end else begin	
flagChanged = 1'bz;
out = 16'bz;
end
end
endmodule
