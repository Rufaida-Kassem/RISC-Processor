module increment_pc(
    input [31:0] pc,
    output [31:0] next_pc,
    input enable
);

always @ (posedge clk)
begin
    if(enable)
        next_pc = pc + 1;
    else
        next_pc = pc;  // make sure
    
end


endmodule