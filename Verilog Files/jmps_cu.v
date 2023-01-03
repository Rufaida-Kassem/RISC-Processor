module jumpsCU (
    input clk, rst, branch,
    input [1:0] jtype,
    input [2:0] ccr,
    input [15:0] rdst,
    output[31:0] pc,
    output reg taken
  );
  parameter jz = 0,
            jmp = 3,
            jn = 1,
            jc = 2;
  // assign taken = (branch === 1'bx)? 1'b0:(branch == 1'b0) ? 1'b0 : (jtype == jmp) || (jtype == jz && ccr[0] == 1'b1) || (jtype == jn && ccr[2] == 1'b1) || (jtype == jc && ccr[3] == 1'b1);
  assign pc = {16'b0, rdst};
  always @*
  begin
    if(branch == 1'b1)
    begin
      if(jtype == 2'b0 && ccr[0] == 1'b1)
      begin
        taken = 1'b1;
      end
      else if(jtype == 2'b01 && ccr[0] == 1'b1)
      begin
        taken = 1'b1;
      end
      else if(jtype == 2'b10 && ccr[0] == 1'b1)
      begin
        taken = 1'b1;
      end
      else if(jtype == 2'b11)
      begin
        taken = 1'b1;
      end
      else
          taken = 1'b0;
    end
    else taken = 1'b0;
  end
endmodule
