module Addition(input [15:0]Rs,
                 input [15:0]Rd,
                 input Enable,
                 output reg[2:0] Ccr,
                 output reg[15:0] Out
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
