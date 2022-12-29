module HazardDetectionUnit(input[4:0] opcode,
                            input[2:0] CurrentRsrcAddress,CurrentRdstAddress,PrevRdstAddress,
                            output reg StallFetch,StallCu,FreezePC);

always @* begin
    //LDD & POP Instruction 
    if(opcode == 5'b10010 | opcode == 5'b01111) begin
        if(CurrentRsrcAddress == PrevRdstAddress | CurrentRdstAddress == PrevRdstAddress)begin
            //Hazard detected
            StallFetch = 1'b1;
            StallCu = 1'b1;
            FreezePC = 1'b1;
        end else begin
            StallFetch = 1'b0;
            StallCu = 1'b0;
            FreezePC = 1'b0;
        end
    end else begin
        StallFetch = 1'b0;
        StallCu = 1'b0;
        FreezePC = 1'b0;
    end
end

endmodule