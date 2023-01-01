module pcCircuit #(parameter addressWidth = 32) (
    input pc_enable, rst, clk,
    input [31:0] branch_call_addr,
    input [1:0] pc_selection,
    output wire [addressWidth - 1 : 0] pc  // pc
  );
  wire [31:0] next_pc;

  increment_pc
    increment_pc_dut (
      .clk(clk),
      .pc (pc ),
      .next_pc (next_pc ),
      .enable  (pc_enable)
    );


  //take from cu --> enable of mux (freeze) and selection
  PC_Mux
    PC_Mux_dut (
      .clk(clk),
      .rst(rst),
      .interrupt_addr (32'b0),
      .first_instruction_addr (32'h20 ),
      .next_instruction_addr (next_pc ),
      .branch_call_addr (branch_call_addr ),
      .selection (pc_selection ),
      .pc_enable (pc_enable ),
      .pc (pc)
    );

endmodule


module IF (
    input clk, rst, pc_enable,
    input [1:0] pc_selection,
    input [31:0] branch_call_addr,
    output [31:0] pc_out,
    output reg [15:0] instruction,
    input pop_pc_low_sig, pop_pc_high_sig,
    input [15:0] pop_data
  );

  wire [31:0] pc, pc_mux;
  wire [15:0] instruction_temp;

  assign pc_out = pc + 1;

  assign pc = pop_pc_low_sig == 1'b1 ? {pc[31:16], pop_data} : pop_pc_high_sig == 1'b1 ? {pop_data, pc[15:0]} : pc_mux;

  Memory #( .addBusWidth(20), .width(16), .instrORdata(1) )
         instructions_memory  (
           .clk (clk ),
           .rst ( rst ),
           .memR ( 1'b1 ),    //we always read from it only (enabled 3la tool mesh mehtaga signal)
           .addR ( pc[19:0]),  // address to read the instruction
           .dataR  (instruction_temp),  // output
           .memWR ( 1'b0 ),   // disable 3la tool
           .dataWR (16'b0),   // nothing 3la tool
           .addWR (20'b0)     // nothing 3la tool
         );


  pcCircuit
    pcCircuit_dut (
      .pc_enable (pc_enable ),
      .pc_selection (pc_selection ),
      .rst (rst ),
      .clk (clk ),
      .branch_call_addr (branch_call_addr ),
      .pc  (pc_mux)
    );


    always @ (posedge clk)//, posedge rst)
    begin
      // if(rst)
      //   instruction = 16'b0;
      // else
        instruction = instruction_temp;
    end


endmodule

