module ID (
    clk, instruction, read_enable, read_addr1, read_addr2, write_addr, control_signals
);
    input clk;
    input [32 - 1 : 0] instruction;
    output read_enable;
    output [5 - 1 : 0] read_addr1, read_addr2;
    output [5 - 1 : 0] write_addr;
    output [8 - 1 : 0] control_signals;


always @(posedge clk) begin
    //TODO: decode the op code

    read_addr1 <= instruction[25 : 21];
    read_addr2 <= instruction[20 : 16];
    read_enable <= 'b1;
    write_addr <= instruction[15 : 11];
end
endmodule