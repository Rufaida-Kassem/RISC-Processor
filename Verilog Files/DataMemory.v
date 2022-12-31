module Mux12Bit(a,b,sel,out);
input [11:0] a,b;
input sel;
output [11:0]out;
assign out=(sel)?b:a;
endmodule


module Mux4x1(a,b,c,d,sel,out);
input [15:0] a,b,c,d;
input [1:0] sel;
output [15:0]out;
assign out=(sel == 2'b00) ? a:
           (sel == 2'b01) ? b:
           (sel == 2'b10) ? c:
           (sel == 2'b11) ? d:16'bz;
endmodule

module DataMemory (input clk,
                    input rst,
                    input MR,
                    input MW,
                    input[11:0] MemoAddreess,
                    input[2:0] Ccr,
                    input[15:0] AluOut,
                    input[15:0] PcLow,
                    input[15:0] PcHigh,
                    input[4:0]OpCode,
                    input [1:0] sel1,
                    input sel2,
                    output reg[15:0] Out1);
reg [31:0] sp;
wire [11:0] addressSelect;
wire [15:0] extendCcr;
wire [15:0] dataSelected;
assign extendCcr = {12'b0,Ccr};
wire [31:0] Sp;
wire [15:0] out_memo;
SPAdder StackAdder(.SP(sp),.Out(Sp),.OpCode(OpCode));

Mux12Bit addressSel(.a(sp[11:0]),.b(MemoAddreess),.sel(sel2),.out(addressSelect));
Mux4x1 dataSel(.a(AluOut),.b(PcLow),.c(PcHigh),.d(extendCcr),.sel(sel1),.out(dataSelected));

Memory #(.addBusWidth(12), .width(16), .instrORdata(0))
         Date_Memory (
           .clk (clk ),
           .rst ( rst ),
           .memR ( MR ),
           .memWR ( MW ),
           .dataWR ( dataSelected ),
           .addR (addressSelect ),
           .addWR ( addressSelect ),
           .dataR  (out_memo)
         );
assign Out1 = out_memo;
endmodule
