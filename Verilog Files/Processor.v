module Processor (
    clk, rst, start
  );
  input clk, rst, start;
  wire [15:0] instruction;
  wire [31:0] pc;
  reg [63:0] IFIDReg;  // 0000_0000_0000_0000 - PC[47:16] - instruction[15:0]
  reg [63:0] IDEReg;   // 4'b0 - MemR_sig[59] - MemWR_sig[58] - aluOp_sig (5 bits)[57:53] - aluSrc_sig[52] - op1[51:36] (value of first reg) - R_op2[35:20] (value of second reg) to be saved for WB - I_op2[19:4] (immediate) - RW_Out_addr[3:1] dest address - RW_sig_out[0]
  reg [31:0] IDEPCReg; // we separate it to reduce the size in case we put all in reg (as we will need to keep the size log to the base 2)
  wire MemR_sig, MemWR_sig, RW_sig_out, aluSrc_sig, RW_Sig_in; //signals 3ady
  wire [15:0] I_op2, R_op2, op1, Reg_data;  // out from the IF  --  out from ID  --  out of ID  --  Back to ID (WB)
  wire [4:0] aluOp_sig;  //signal 3ady
  wire [2:0] RW_Out_addr, RW_In_addr;   // out from ID  --  back from ID  -->  they are equal shifted :|




  //////////////////For Execute and Memory
  reg [85:0] EXMEMO_Reg; //86 bits ==>  all Control signals(15 bit)
                                        // Alu out(16 bit)
                                        // Address(12bit)
                                        // Ccr(3bits)
                                        // ALu op(5bits)
                                        // write address(3 bit)
                                        // Pc(32 bit)
  reg [35:0] MEMOWB_Reg;
  wire [2:0]Ccr;
  wire [15:0] MemoryAddress;
  wire [15:0] Out_Excute;
  wire [15:0] Out_Memo;
  wire [15:0] outputPort;
  reg fetch_enable, decode_enable;
  wire ldm;

  reg     [2:0] current_state, next_state;
  parameter idle_state = 0, fetch_state = 1, decode_state = 2, execute_state = 3, memory_state = 4, write_back_state = 5;

  IF
    IF_dut (
      .enable(fetch_enable),
      .clk (clk ),
      .rst ( rst ),
      .pc (pc ),
      .instruction  ( instruction)  //output
    );

  ID
    ID_dut (
      .enable(decode_enable),
      .instruction (IFIDReg[15:0]),    //input
      .op1 (op1 ),                         //output
      . R_op2 ( R_op2 ),                   //output
      . I_op2 ( I_op2 ),                   //output
      .RW_Out_addr (RW_Out_addr ),         //output
      .RW_In_addr (MEMOWB_Reg[2:0]),   //input
      .aluOp_sig (aluOp_sig ),  //output
      .RW_sig_out (RW_sig_out ),  //output
      .aluSrc_sig ( aluSrc_sig ), //output
      .MemWR_sig ( MemWR_sig ), //output
      .MemR_sig ( MemR_sig ),
      .RW_Sig_in (MEMOWB_Reg[3] ), //input --> WB
      .Reg_data  ( Reg_data),  //input  --> WB
      .clk (clk ),
      .rst ( rst ),
      .ldm(ldm)
    );

  //////////////////For Execute and Memory
  /////////////////////////Execute////////////////////////////////////
  Execution  Execute(.op1( IDEReg[51:36]),
                     .op2( IDEReg[35:20]),
                     .inport(16'b0),
                     .immediate( IDEReg[19:4]),
                     .shiftAmmount(16'b0),
                     .AluOp( IDEReg[57:53]),
                     .AluScr(2'b00),
                     .Inport(1'b0),
                     .Branch(1'b0),
                     .ExecuteMemoryForwarding(16'b0),
                     .MemoryWBForwarding(16'b0),
                     .Forward1Sel(2'b0),
                     .Forward2Sel(2'b0),
                     .Ccr(Ccr),
                     .MemoryAddress(MemoryAddress),
                     .Out(Out_Excute)
                    );
  Memory #(.addBusWidth(12), .width(16), .instrORdata(0))
         Date_Memory (
           .clk (clk ),
           .rst ( rst ),
           .memR ( EXMEMO_Reg[5] ),
           .memWR ( EXMEMO_Reg[4] ),
           .dataWR ( EXMEMO_Reg[33:18] ),
           .addR (EXMEMO_Reg[17:6] ),
           .addWR ( EXMEMO_Reg[17:6] ),
           .dataR  ( Out_Memo)
         );

  /////////////////////////////Write Back////////////////////////////////
  WriteBack Write_Back(.Load( MEMOWB_Reg[35:20]),
                       .Rd( MEMOWB_Reg[19:4]),
                       .Wb( MEMOWB_Reg[3]),
                       .Port_Write(1'b0),
                       .output_port_pervious(16'b0),
                       .Write_Data(Reg_data),
                       .output_port(outputPort)
                      );

    always @ (current_state, start, ldm)
    begin
      case (current_state)
        idle_state:
          if(start & ~rst)
          begin
            next_state  = fetch_state;
          end
        fetch_state:
        begin
          next_state  = decode_state;
          fetch_enable  = 1'b1;
        end
        decode_state:
        begin
          next_state  = execute_state;
          decode_enable = 1'b1;
          IFIDReg  = {16'b0, pc, instruction};
          fetch_enable = 1'b0;    
          if(ldm)
            fetch_enable = 1'b1;
        end
        execute_state:
        begin
          next_state  = memory_state;
          fetch_enable  = 1'b0;
          IDEReg = {4'b0,MemR_sig, MemWR_sig, aluOp_sig, aluSrc_sig, op1, R_op2, instruction, RW_Out_addr, RW_sig_out};
          IDEPCReg = IFIDReg[47:16];
          decode_enable  = 1'b0;
          
          //fetch_enable = 1'b0;  //changed here doaa
        end
          
        memory_state:
        begin
          next_state  = write_back_state;
          //[85:83] ==> Ccr
          //[82:67] ==> ALuout
          //[66:55] ==> Memoryaddress
          //[54:40] ==> ControlSignals
          //[39:35] ==> Alu op ==> must take from decode buffer need bits
          //[34:32] ==> Write address
          //[31:0] ==> Pc
          EXMEMO_Reg ={Ccr,Out_Excute,MemoryAddress[11:0],IDEReg[59], IDEReg[58],IDEReg[0],1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,aluOp_sig,IDEReg[3:1],pc};
        end
        write_back_state:
        begin
          next_state  = fetch_state;
          //[35:20] ==> ALu out
          //[19:4] ==> Memout
          //[3] ==> wb selector
          //[2:0] reg address
          MEMOWB_Reg ={EXMEMO_Reg[33:18],Out_Memo, EXMEMO_Reg[3], EXMEMO_Reg[2:0]};
        end
        default:
          next_state = idle_state;
      endcase
    end

      always @ (posedge clk or posedge rst)
      begin
        if (rst)
          current_state  = idle_state;
        else
          if(clk)    //and ~aluSrc_sig
          begin
            current_state  = next_state;
          end
      end
    endmodule
