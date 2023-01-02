vsim work.Processor_tb
add wave -position insertpoint  \
sim:/Processor_tb/clk \
sim:/Processor_tb/inputPort \
sim:/Processor_tb/interrupt \
sim:/Processor_tb/outputPort \
sim:/Processor_tb/rst \
sim:/Processor_tb/start\
sim:/Processor_tb/Processor_dut/Execute/Ccr \
sim:/Processor_tb/Processor_dut/IF_dut/pc \
sim:/Processor_tb/Processor_dut/Date_Memory/Sp \
sim:/Processor_tb/Processor_dut/ID_dut/RegFile_memo_dut/read_addr1 \
sim:/Processor_tb/Processor_dut/ID_dut/RegFile_memo_dut/read_addr2 \
sim:/Processor_tb/Processor_dut/ID_dut/RegFile_memo_dut/read_data1 \
sim:/Processor_tb/Processor_dut/ID_dut/RegFile_memo_dut/read_data2 
run