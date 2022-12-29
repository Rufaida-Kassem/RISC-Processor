module increment_pc(
    input [31:0] pc,
    output reg [31:0] next_pc,
    input enable, clk
);


    assign next_pc = pc + 1;



endmodule