module HazardDetectionUnit(input[4:0] opcode,
                            input[2:0] CurrentRsrcAddress,CurrentRdstAddress,PrevRdstAddress,
                            output reg FreezePC);

always @* begin
    //LDD & POP Instruction 
    if(opcode == 5'b10010 | opcode == 5'b01111) begin
        if(CurrentRsrcAddress == PrevRdstAddress | CurrentRdstAddress == PrevRdstAddress)begin
            //Hazard detected
            FreezePC = 1'b1;
        end else begin
            FreezePC = 1'b0;
        end
    end else begin
        FreezePC = 1'b0;
    end
end

endmodule