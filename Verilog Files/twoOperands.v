////////////////////Mov////////////////////////////
module Mov(input [15:0]Rs,
                 input Enable,
                 input [2:0]previousflags,
                 output reg[15:0] Out,
                 output reg [2:0] Ccr
               );
always@ * begin
//Assign Carry flag 
if( Enable==1'b1)
begin
 Out = Rs;
 Ccr = previousflags;
end
else begin
Out=16'bz;
Ccr = 3'bz;
end
end
endmodule

////////////////////Addition//////////////////////////// 
module Addition(input [15:0]Rs,
                 input [15:0]Rd,
                 input Enable,
                input [2:0]previousflags,
                output reg[15:0] Out,
                output reg [2:0] Ccr
               );
always@ * begin
//Assign Carry flag 
if( Enable==1'b1)
begin
 {Ccr[2],Out}=Rs+Rd;
//Assign zero flag to one if out is zeros
Ccr[0] = (Out == 15'b0) ? 1'b1 : 1'b0 ;
//Assign negative flag to one if out is less than zero
Ccr[1] = (Out[15]== 1'b1) ? 1'b1 : 1'b0 ;
end
else begin
Out=16'bz;
Ccr=3'bz;
end
end
endmodule

////////////////////Subtraction//////////////////////////// 
module Subtraction(input [15:0]Rs,
                 input [15:0]Rd,
                 input Enable,
                input [2:0]previousflags,
                output reg[15:0] Out,
                output reg [2:0] Ccr
               );
always@ * begin
//Assign Carry flag 
if( Enable==1'b1)
begin
 {Ccr[2],Out}=Rs-Rd;
//Assign zero flag to one if out is zeros
Ccr[0] = (Out == 15'b0) ? 1'b1 : 1'b0 ;
//Assign negative flag to one if out is less than zero
Ccr[1] = (Out[15]== 1'b1) ? 1'b1 : 1'b0 ;
end
else begin
Out=16'bz;
Ccr=3'bz;
end
end
endmodule


////////////////////Anding//////////////////////////// 
module Anding(input [15:0]Rs,
                 input [15:0]Rd,
                 input Enable,
                 input [2:0]previousflags,
                 output reg[15:0] Out,
                 output reg [2:0] Ccr
               );
always@ * begin
//Assign Carry flag 
if( Enable==1'b1)
begin
 {Ccr[2],Out}=Rs & Rd;
//Assign zero flag to one if out is zeros
Ccr[0] = (Out == 15'b0) ? 1'b1 : 1'b0 ;
//Assign negative flag to one if out is less than zero
Ccr[1] = (Out[15]== 1'b1) ? 1'b1 : 1'b0 ;
end
else begin
Out=16'bz;
Ccr=3'bz;
end
end
endmodule
////////////////////Oring//////////////////////////// 
module Oring(input [15:0]Rs,
                 input [15:0]Rd,
                 input Enable,
                 input [2:0]previousflags,
                 output reg[15:0] Out,
                 output reg [2:0] Ccr
               );
always@ * begin
//Assign Carry flag 
if( Enable==1'b1)
begin
 {Ccr[2],Out}=Rs | Rd;
//Assign zero flag to one if out is zeros
Ccr[0] = (Out == 15'b0) ? 1'b1 : 1'b0 ;
//Assign negative flag to one if out is less than zero
Ccr[1] = (Out[15]== 1'b1) ? 1'b1 : 1'b0 ;
end
else begin
Out=16'bz;
Ccr=3'bz;
end
end
endmodule
////////////////////Shift Left//////////////////////////// 
module ShiftLeft(input [15:0]Rs,
                 input [15:0]shiftAmmount,
                 input Enable,
                 input [2:0]previousflags,
                 output reg[15:0] Out,
                 output reg [2:0] Ccr
               );
always@ * begin
//Assign Carry flag 
if( Enable==1'b1)
begin
//Keep sign of value
 {Ccr[2],Out}=Rs << shiftAmmount;
//Assign zero flag to one if out is zeros
Ccr[0] = (Out == 15'b0) ? 1'b1 : 1'b0 ;
//Assign negative flag to one if out is less than zero
Ccr[1] = (Out[15]== 1'b1) ? 1'b1 : 1'b0 ;
end
else begin
Out=16'bz;
Ccr=3'bz;
end
end
endmodule


////////////////////Shift Left//////////////////////////// 
module ShiftRight(input [15:0]Rs,
                 input [15:0]shiftAmmount,
                 input Enable,
                 input [2:0]previousflags,
                 output reg[15:0] Out,
                 output reg [2:0] Ccr
               );
always@ * begin
//Assign Carry flag 
if( Enable==1'b1)
begin
//Keep sign of value
 {Ccr[2],Out}=Rs >>> shiftAmmount;
//Assign zero flag to one if out is zeros
Ccr[0] = (Out == 15'b0) ? 1'b1 : 1'b0 ;
//Assign negative flag to one if out is less than zero
Ccr[1] = (Out[15]== 1'b1) ? 1'b1 : 1'b0 ;
end
else begin
Out=16'bz;
Ccr=3'bz;
end
end
endmodule
