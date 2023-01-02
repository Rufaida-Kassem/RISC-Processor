module PC_Mux (
    input clk, rst,
    input [31:0] interrupt_addr,
    input [31:0] first_instruction_addr,
    input [31:0] next_instruction_addr,
    input [31:0] branch_call_addr,
    //input [31:0] calling_addr,
    input [1:0] selection,
    input pc_enable,
    output  [31:0] pc_out
);
//f d e m wb
//  f d e m  wb
//    f d e  m  wb
reg [31:0] pc;
    assign pc_out =  pc;
always @(posedge clk, posedge rst)
begin
    if(rst)
        pc = 32'h20; 
    else if(clk)
    begin
        if(pc_enable)
        begin
            case (selection)
                2'b00: pc = next_instruction_addr;
                2'b01: pc = first_instruction_addr;
                2'b10: pc = 32'b0;
                2'b11: pc = branch_call_addr;
                default: pc = pc;
            endcase
        end
        
    end
end

endmodule