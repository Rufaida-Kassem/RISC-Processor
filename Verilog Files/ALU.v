module ALU(input [15:0]Rs,
           input [15:0]Rd,
           input[4:0]AluOp, 
            output[2:0] Ccr,
            output[15:0] Out,
	    output signalJump,
                 );
//1- decoding
wire [31:0] DecOut;
 Decoder deco(AluOp,DecOut);
////////////////////////////////////ONE OPERANDS MODULE//////////////////////////

////////////////////////////////////TWO OPERANDS MODULE//////////////////////////
Mov movOp(.Rs(Rs),.Enable(DecOut[2]),.Out(Out));
Addition addOp (.Rs(Rs),.Rd(Rd),.Enable(DecOut[3]), .Cccr(Ccr),.Out(Out));  

Subtraction subOp(.Rs(Rs),.Rd(Rd),.Enable(DecOut[4]),.Ccr(Ccr),.Out(Out));

Anding andOp(.Rs(Rs),.Rd(Rd),.Enable(DecOut[5]),.Ccr(Ccr),.Out(Out));

Oring orOp(.Rs(Rs),.Rd(Rd),.Enable(DecOut[6]),.Ccr(Ccr),.Out(Out));
/////////////////////SHIFT AMOUNT TO BE CHECKED//////////////////////////////////////////
ShiftLeft leftOp(.Rs(Rs),.shiftAmmount(Rd[7:0]),.Enable(DecOut[7]),.Ccr(Ccr),.Out(Out));

ShiftRight rightOp(.Rs(Rs),.shiftAmmount(Rd[7:0]),.Enable(DecOut[8]),.Ccr(Ccr),.Out(Out));


////////////////////////////////////MEMORY OPERATION MODULE//////////////////////////


////////////////////////////////////BRANCH OPERATION MODULE//////////////////////////
jumpConditionally zeroOp(.flag(Ccr[0]),.Enable(DecOut[14]),.flagChanged(Ccr[0]),.signalJump(signalJump));
jumpConditionally negativeOp(.flag(Ccr[1]),.Enable(DecOut[15]),.flagChanged(Ccr[1]),.signalJump(signalJump));
jumpConditionally carryOp(.flag(Ccr[2]),.Enable(DecOut[16]),.flagChanged(Ccr[2]),.signalJump(signalJump));
 
//LDM
Ldm ldmOp (Rd ,DecOut[1], Out);
//NOT
 Not notOp ( Rd, DecOut[4], Out, Ccr);
//STD
 Sw swOp( Rs,DecOut[2] ,Out);
endmodule
