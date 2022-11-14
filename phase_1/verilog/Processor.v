Memory 
instructions_memory (
  .clk (clk ),
  . rst ( rst ),
  . memR ( 'b1 ),
  . memWR ( memWR ),
  .dataWR (dataWR ),
  .addR (addR ),
  . addWR ( addWR ),
  .dataR  ( dataR)
);

Memory 
data_memory (
  .clk (clk ),
  . rst ( rst ),
  . memR ( memR ),
  . memWR ( memWR ),
  .dataWR (dataWR ),
  .addR (addR ),
  . addWR ( addWR ),
  .dataR  ( dataR)
);

RegFile 
RegFile_dut (
  .read_enable (read_enable ),
  . write_enable ( write_enable ),
  . clk ( clk ),
  . rst ( rst ),
  .write_data (write_data ),
  .read_addr (read_addr ),
  . write_addr ( write_addr ),
  .read_data  ( read_data)
);

IF 
IF_dut (
  .clk (clk ),
  . rst ( rst ),
  .programStartAdd (programStartAdd ),
  .addR (addR ),
  .memR  ( memR)
);

ID 
ID_dut (
  .clk (clk ),
  .instruction (instruction ),
  .read_enable (read_enable ),
  .read_addr1 (read_addr1 ),
  . read_addr2 ( read_addr2 ),
  .write_addr (write_addr ),
  .control_signals  ( control_signals)
);

