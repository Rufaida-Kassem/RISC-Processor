module PC_Mux (
    input [31:0] interrupt_addr,
    input [31:0] first_instructoin_addr,
    input [31:0] next_instruction_addr,
    input [31:0] branch_addr,
    //input [31:0] calling_addr,
    input [1:0] selection,
    input enable,
    output reg [31:0] pc
);

always @(*)
begin
    if(enable)
    begin
        case (selection)
            00: interrupt_addr
            01: first_instruction_addr
            10: next_instruction_addr
            11: branch_addr
            default: pc = pc
        endcase
    end
end

    
endmodule