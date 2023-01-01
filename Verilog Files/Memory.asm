#this is a comment 
#all numbers are in hexadecimal
#the reset signal is raised before this code is executed and the flags and the registers are set to zeros.
.ORG 0 #this is the interrupt code
AND R3,R4
ADD R1,R4
OUT R4
.ORG 20 #this is the instructions code
INC R2 
SHR R2,2 
INC R2
INC R2



