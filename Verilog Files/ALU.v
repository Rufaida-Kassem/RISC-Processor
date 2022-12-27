module ALU(input [15:0]Rs,
           input [15:0]Rd,
           input[4:0]AluOp, 
           inout[2:0] Ccr,
            output[15:0] Out,
	    output signalJump
                 );
//1- decoding
 wire [31:0] DecOut;
 Decoder deco(AluOp,DecOut);
////////////////////////////////////ONE OPERANDS MODULE//////////////////////////
//0-NOP
//1-Not
 Not not_ins(.Rds(Rd),.Enable(DecOut[1]),.previousflags(Ccr),.Out(Out),.Ccr(Ccr));
//2-SETC
SETC setc_ins(.Enable(DecOut[2]),.previousflags(Ccr),.Ccr(Ccr));
//3-CLRC
CLRC clrc_ins(.Enable(DecOut[3]),.previousflags(Ccr),.Ccr(Ccr));
//4-INC
INC inc_ins(.Rds(Rd),.Enable(DecOut[4]),.Out(Out),.previousflags(Ccr),.Ccr(Ccr));
//5-DEC
DEC dec_ins(.Rds(Rd),.Enable(DecOut[5]),.Out(Out),.previousflags(Ccr),.Ccr(Ccr));
//6-OUT
OUT out_ins(.Rds(Rd),.Enable(DecOut[6]),.Out(Out));
//7-IN
IN in_ins(.Rds(Rd),.Enable(DecOut[7]),.Out(Out));

////////////////////////////////////TWO OPERANDS MODULE//////////////////////////
Mov movOp(.Rs(Rs),.Enable(DecOut[8]),.Out(Out));
Addition addOp (.Rs(Rs),.Rd(Rd),.Enable(DecOut[9]),.previousflags(Ccr), .Ccr(Ccr),.Out(Out));  

Subtraction subOp(.Rs(Rs),.Rd(Rd),.Enable(DecOut[10]),.previousflags(Ccr),.Ccr(Ccr),.Out(Out));

Anding andOp(.Rs(Rs),.Rd(Rd),.Enable(DecOut[11]),.previousflags(Ccr),.Ccr(Ccr),.Out(Out));

Oring orOp(.Rs(Rs),.Rd(Rd),.Enable(DecOut[12]),.previousflags(Ccr),.Ccr(Ccr),.Out(Out));
////////////////////////////////////SHIFT AMOUNT TO BE CHECKED//////////////////////////////////////////
ShiftLeft leftOp(.Rs(Rs),.shiftAmmount(Rd),.Enable(DecOut[13]),.previousflags(Ccr),.Ccr(Ccr),.Out(Out));

ShiftRight rightOp(.Rs(Rs),.shiftAmmount(Rd),.Enable(DecOut[14]),.previousflags(Ccr),.Ccr(Ccr),.Out(Out));


////////////////////////////////////MEMORY OPERATION MODULE//////////////////////////
//Push 15
PUSH push_ins(.Rds(Rd),.Enable(DecOut[15]),.Out(Out));
//Pop 16
// POP pop_ins(.Rds(Rd),.Enable(DecOut[16]),.Out(Out));
//Ldm 17
Ldm ldm_ins(.ImmediateValue(Rd),.Enable(DecOut[17]),.Out(Out));
//Ldd 18
LDD ldd_ins(.Rs(Rs),.Enable(DecOut[18]),.Out(Out));
//SW 19
Sw sw_ins(.ImmediateValue(Rs),.Enable(DecOut[19]),.Out(Out));
//////////////////////////////////BRANCH OPERATION MODULE//////////////////////////
jumpConditionallyZero zeroOp(.flag(Ccr),.Enable(DecOut[20]),.flagChanged(Ccr),.signalJump(signalJump));
jumpConditionallyNegative negativeOp(.flag(Ccr),.Enable(DecOut[21]),.flagChanged(Ccr),.signalJump(signalJump));
jumpConditionallyCarry carryOp(.flag(Ccr),.Enable(DecOut[22]),.flagChanged(Ccr),.signalJump(signalJump));
 //jump 23
 //call 24
 // ret 25
 //rtI 26
 //reset 27
 // interrupt 28
endmodule
