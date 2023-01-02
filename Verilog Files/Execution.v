module Execution(input rst,
                 input [15:0]op1,
                 input [15:0]op2,
                 input[15:0] inport,
                 input[15:0]immediate,
                 input [15:0] shiftAmmount,
                 input[4:0]AluOp, 
                 input[1:0] AluScr,
                 input Inport,
                 input Branch,
                 input [15:0] ExecuteMemoryForwarding,
                 input [15:0] MemoryWBForwarding,
                 input[1:0] Forward1Sel,
                 input[1:0] Forward2Sel,
                 inout [2:0] Ccr,
                 output [15:0]MemoryAddress,
                 output [15:0] Out
                 );
wire [15:0] InOp1Sel,Op1,InOp2Sel,Op2;
wire signalJump;

// always @(posedge rst) begin
// if(rst) begin
// Out = 16'b0;
// MemoryAddress = 16'b0;
// end
// end
// setCcrValue setCCR(.rst(rst),.Ccr(Ccr));
//////////////OPERAND 1//////////////////////////////////////
Mux16Bit muxRd(.a(op1),.b(inport),.sel(Inport),.out(InOp1Sel)); //Selection between inport and src 1
Mux3x1  muxOp1(.a(InOp1Sel),.b(ExecuteMemoryForwarding),.c(MemoryWBForwarding),.sel(Forward1Sel),.out(Op1)); //Selected op1 of Alu
///////////////OPERAND 2//////////////////////////////
Mux3x1  muxForwardSel(.a(op2),.b(ExecuteMemoryForwarding),.c(MemoryWBForwarding),.sel(Forward2Sel),.out(InOp2Sel)); //Selected between op2 and forwarding
Mux3x1  muxOp2(.a(InOp2Sel),.b(immediate),.c(shiftAmmount),.sel(AluScr),.out(Op2));//Selected op2 of Alu

ALU alu(Op1,Op2,AluOp,inport,Ccr, Out,signalJump);
assign MemoryAddress=(Branch == 1'b0)?op1:op2;
endmodule
