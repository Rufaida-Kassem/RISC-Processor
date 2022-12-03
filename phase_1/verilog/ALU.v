module ALU(input [15:0]Rs,
           input [15:0]Rd,
           input[2:0]AluOp, 
            output[2:0] Ccr,
            output[15:0] Out
                 );
//1- decoding
wire [7:0] DecOut;
 Decoder deco(AluOp,DecOut);
// adding
Addition addOp (Rs,Rd,DecOut[3], Ccr, Out);   
//LDM
Ldm ldmOp (Rd ,DecOut[1], Out);
//NOT
 Not notOp ( Rd, DecOut[4], Out, Ccr);
//STD
 Sw swOp( Rs,DecOut[2] ,Out);
endmodule
