// module HazardDetectionUnit(input[4:0] opcode,
//                             input[2:0] CurrentRsrcAddress,CurrentRdstAddress,PrevRdstAddress,
//                             output reg FreezePC);

// // assign FreezePC = 

// always @* begin
//     //LDD & POP Instruction 
//     if(opcode == 5'b10010 | opcode == 5'b10000) begin
//         if(CurrentRsrcAddress == PrevRdstAddress || CurrentRdstAddress == PrevRdstAddress)begin
//             //Hazard detected
//             FreezePC = 1'b1;
//         end else begin
//             FreezePC = 1'b0;
//         end
//     end else begin
//         FreezePC = 1'b0;
//     end
// end

// endmodule


module HazardDetectionUnit (
    input clk, rst,
    input[4:0] opcode,
    input[2:0] CurrentRsrcAddress,CurrentRdstAddress,PrevRdstAddress,
    output reg freeze_pc
  );

  //we have to set pc to pc - 1 to fetch the correct instruction
  //as it gets incremented during the calling --> as we know the call is call in decode stage
  //so that the next instruction to the call is already get fetched and we will ignore this fetch
  reg     [1:0] current_state, next_state;

  parameter idle_state = 0,stall = 1;

  always @(posedge clk, posedge rst)
  begin
    if(rst)
    begin
      current_state = idle_state;

    end
    if(clk)
    begin
      current_state = next_state;


    end
  end
  always @ (current_state, opcode)
  begin
    next_state = idle_state;
    case(current_state)
      idle_state:
      begin
        freeze_pc = 1'b0;
        if(((opcode == 5'b10010 | opcode == 5'b10000) & (CurrentRsrcAddress == PrevRdstAddress | CurrentRdstAddress == PrevRdstAddress)))
        begin
          next_state = stall;
          freeze_pc = 1'b1;
        end
      end
      stall:
      begin
        next_state = idle_state;
         freeze_pc = 1'b0;
      end
      default:
      begin
        next_state = idle_state;
      end
    endcase

  end




endmodule
