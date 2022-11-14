module pcCircuit #(parameter addressWidth = 32) (
    clk, rst, addR
  );
  input clk, rst;
  output reg [addressWidth - 1 : 0] addR;
  reg [addressWidth - 1 : 0] pc;

  //pc circuit
  always @(posedge clk , posedge rst)
  begin
    if(rst)
    begin
      pc <= 32'h20;
    end
    else if (clk)
    begin
      pc <= pc + 1;
      addR <= pc;
    end
  end
endmodule

