
module Memory #(parameter addBusWidth = 32, width = 16) (
    clk, rst, memR, memWR, addR, addWR, dataWR, dataR
);
    input clk, rst, memR, memWR;
    input [width - 1 : 0] dataWR;
    input [addBusWidth - 1 : 0] addR, addWR;
    output reg [width - 1 : 0] dataR;
    reg [width - 1 : 0] memory [0 : 2**addBusWidth - 1];
    integer i;

    always @(posedge clk , posedge rst) begin
        if(rst)
        begin
            $readmemh("mem.mem", memory);
        end
        else if (clk & memWR) begin
            memory[addWR] <= dataWR;
        end
    end

    always @(negedge clk) begin
        if (clk & memR) begin
            dataR <= memory[addWR];
        end
    end

endmodule