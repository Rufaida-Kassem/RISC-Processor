module ALU(input [15:0]Rs,
           input [15:0]Rd,
           input[4:0]AluOp, 
            output[2:0] Ccr,
            output[15:0] Out,
	    output signalJump
                 );
//1- decoding
wire [31:0] DecOut;
 Decoder deco(AluOp,DecOut);
////////////////////////////////////ONE OPERANDS MODULE//////////////////////////
//0-NOP
//1-Not
 Not not_ins(.Rds(Rd),.Enable(DecOut[1]),.Out(Out),.Ccr(Ccr));
//2-SETC
SETC setc_ins(.Enable(DecOut[2]),.Ccr(Ccr));
//3-CLRC
CLRC clrc_ins(.Enable(DecOut[3]),.Ccr(Ccr));
//4-INC
INC inc_ins(.Rds(Rd),.Enable(DecOut[4]),.Out(Out),.Ccr(Ccr));
//5-DEC
DEC dec_ins(.Rds(Rd),.Enable(DecOut[5]),.Out(Out),.Ccr(Ccr));
//6-OUT
OUT out_ins(.Rds(Rd),.Enable(DecOut[6]),.Out(Out));
//7-IN
IN in_ins(.Rds(Rd),.Enable(DecOut[7]),.Out(Out));

////////////////////////////////////TWO OPERANDS MODULE//////////////////////////
//Mov movOp(.Rs(Rs),.Enable(DecOut[2]),.Out(Out));
//Addition addOp (.Rs(Rs),.Rd(Rd),.Enable(DecOut[3]), .Cccr(Ccr),.Out(Out));  

//Subtraction subOp(.Rs(Rs),.Rd(Rd),.Enable(DecOut[4]),.Ccr(Ccr),.Out(Out));

//Anding andOp(.Rs(Rs),.Rd(Rd),.Enable(DecOut[5]),.Ccr(Ccr),.Out(Out));

//Oring orOp(.Rs(Rs),.Rd(Rd),.Enable(DecOut[6]),.Ccr(Ccr),.Out(Out));
/////////////////////SHIFT AMOUNT TO BE CHECKED//////////////////////////////////////////
//ShiftLeft leftOp(.Rs(Rs),.shiftAmmount(Rd[7:0]),.Enable(DecOut[7]),.Ccr(Ccr),.Out(Out));

//ShiftRight rightOp(.Rs(Rs),.shiftAmmount(Rd[7:0]),.Enable(DecOut[8]),.Ccr(Ccr),.Out(Out));


////////////////////////////////////MEMORY OPERATION MODULE//////////////////////////
//Push 15
PUSH push_ins(.Rds(Rd),.Enable(DecOut[15]),.Out(out));
//Pop 16
POP pop_ins(.Rds(Rd),.Enable(DecOut[16]),.Out(Out));
//Ldm 17
Ldm ldm_ins(.ImmediateValue(Rd),.Enable(DecOut[17]),.Out(Out));
//Ldd 18
LDD ldd_ins(.Rs(Rs),.Enable(DecOut[18]),.Out(Out));
//SW 19
Sw sw_ins(.ImmediateValue(Rs),.Enable(DecOut[19]),.Out(Out));
////////////////////////////////////BRANCH OPERATION MODULE//////////////////////////
//jumpConditionally zeroOp(.flag(Ccr[0]),.Enable(DecOut[14]),.flagChanged(Ccr[0]),.signalJump(signalJump));
//jumpConditionally negativeOp(.flag(Ccr[1]),.Enable(DecOut[15]),.flagChanged(Ccr[1]),.signalJump(signalJump));
//jumpConditionally carryOp(.flag(Ccr[2]),.Enable(DecOut[16]),.flagChanged(Ccr[2]),.signalJump(signalJump));
 
//LDM
//Ldm ldmOp (Rd ,DecOut[1], Out);
//NOT
// Not notOp ( Rd, DecOut[4], Out, Ccr);
//STD
// Sw swOp( Rs,DecOut[2] ,Out);
endmodule