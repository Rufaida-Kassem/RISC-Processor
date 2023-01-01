file = "Memory"
read_file = open(file + ".asm", "r",encoding='utf-8')
array = ["0000000000000000" for i in range(2000)]
array_counter = 0 
s=0
lines = read_file.readlines()
for i in range(len(lines)):
    line = lines[i].split()
    if len(line) > 0:
        if(not lines[i].startswith("#")):  
            if(lines[i].startswith(".ORG")):
                next_line = lines[i + 1].split()
                print(next_line)
                # s=int(line[1], 16)
                # if(s == 32):
                #      array[array_counter] = '11010'+'00000000000'
                array_counter = int(line[1], 16)
                print(array_counter)
            # *********************ONE OPERAND********************
            if(lines[i].startswith("NOP")):
                array[array_counter] = "0000000000000000"
                array_counter += 1 
            if(lines[i].startswith("SETC")):
                array[array_counter] = "0000100000000000"
                array_counter += 1 
            if(lines[i].startswith("CLRC")):
                array[array_counter] = "0001000000000000"
                array_counter += 1 
            if(lines[i].startswith("NOT")):
                array[array_counter] = "00011000"
                if(line[1] == 'R0'): 
                    # 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
                    array[array_counter] = array[array_counter]+"000"+"00000"
                elif(line[1] == 'R1'):
                    array[array_counter] = array[array_counter]+"001"+"00000"
                elif(line[1] == 'R2'): 
                    array[array_counter] = array[array_counter]+"010"+"00000"
                elif(line[1] == 'R3'): 
                    array[array_counter] = array[array_counter]+"011"+"00000"
                elif(line[1] == 'R4'): 
                    array[array_counter] = array[array_counter]+"100"+"00000"
                elif(line[1] == 'R5'): 
                    array[array_counter] = array[array_counter]+"101"+"00000"
                elif(line[1] == 'R6'): 
                    array[array_counter] = array[array_counter]+"110"+"00000"
                else: 
                    array[array_counter] = array[array_counter]+"111"+"00000"
                array_counter += 1
            if(lines[i].startswith("INC")):
                array[array_counter] = "00100000"
                if(line[1] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"+"00000"
                if(line[1] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"+"00000"
                if(line[1] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"+"00000"
                if(line[1] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"+"00000"
                if(line[1] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"+"00000"
                if(line[1] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"+"00000"
                if(line[1] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"+"00000"
                if(line[1] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"+"00000"
                array_counter += 1 
            if(lines[i].startswith("DEC")):
                array[array_counter] = "00101000"
                if(line[1] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"+"00000"
                if(line[1] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"+"00000"
                if(line[1] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"+"00000"
                if(line[1] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"+"00000"
                if(line[1] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"+"00000"
                if(line[1] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"+"00000"
                if(line[1] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"+"00000"
                if(line[1] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"+"00000"
                array_counter += 1 
            if(lines[i].startswith("OUT")):
                array[array_counter] = "00110000"
                if(line[1] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"+"00000"
                if(line[1] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"+"00000"
                if(line[1] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"+"00000"
                if(line[1] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"+"00000"
                if(line[1] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"+"00000"
                if(line[1] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"+"00000"
                if(line[1] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"+"00000"
                if(line[1] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"+"00000"
                array_counter += 1 
            if(lines[i].startswith("IN ")):
                array[array_counter] = "01111000"
                if(line[1] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"+"00000"
                if(line[1] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"+"00000"
                if(line[1] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"+"00000"
                if(line[1] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"+"00000"
                if(line[1] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"+"00000"
                if(line[1] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"+"00000"
                if(line[1] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"+"00000"
                if(line[1] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"+"00000"
                array_counter += 1 
            #*********************TWO OPERAND******************** 
            if(lines[i].startswith("MOV")):
                array[array_counter] = "01000"
                reg = line[1].split(',')
                if(reg[0] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"
                if(reg[0] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"
                if(reg[0] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"
                if(reg[0] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"
                if(reg[0] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"
                if(reg[0] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"
                if(reg[0] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"
                if(reg[0] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"
                ############### destination
                if(reg[1] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"+"00000"
                if(reg[1] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"+"00000"
                if(reg[1] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"+"00000"
                if(reg[1] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"+"00000"
                if(reg[1] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"+"00000"
                if(reg[1] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"+"00000"
                if(reg[1] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"+"00000"
                if(reg[1] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"+"00000"
                array_counter += 1 
            if(lines[i].startswith("ADD")):
                array[array_counter] = "01001"
                reg = line[1].split(',')
                if(reg[0] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"
                if(reg[0] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"
                if(reg[0] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"
                if(reg[0] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"
                if(reg[0] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"
                if(reg[0] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"
                if(reg[0] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"
                if(reg[0] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"
                ############### destination
                if(reg[1] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"+"00000"
                if(reg[1] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"+"00000"
                if(reg[1] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"+"00000"
                if(reg[1] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"+"00000"
                if(reg[1] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"+"00000"
                if(reg[1] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"+"00000"
                if(reg[1] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"+"00000"
                if(reg[1] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"+"00000"
                array_counter += 1 
            if(lines[i].startswith("SUB")):
                array[array_counter] = "01010"
                reg = line[1].split(',')
                if(reg[0] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"
                if(reg[0] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"
                if(reg[0] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"
                if(reg[0] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"
                if(reg[0] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"
                if(reg[0] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"
                if(reg[0] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"
                if(reg[0] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"
                ############### destination
                if(reg[1] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"+"00000"
                if(reg[1] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"+"00000"
                if(reg[1] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"+"00000"
                if(reg[1] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"+"00000"
                if(reg[1] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"+"00000"
                if(reg[1] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"+"00000"
                if(reg[1] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"+"00000"
                if(reg[1] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"+"00000"
                array_counter += 1 
            if(lines[i].startswith("AND")):
                array[array_counter] = "01011"
                reg = line[1].split(',')
                if(reg[0] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"
                if(reg[0] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"
                if(reg[0] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"
                if(reg[0] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"
                if(reg[0] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"
                if(reg[0] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"
                if(reg[0] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"
                if(reg[0] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"
                ############### destination
                if(reg[1] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"+"00000"
                if(reg[1] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"+"00000"
                if(reg[1] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"+"00000"
                if(reg[1] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"+"00000"
                if(reg[1] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"+"00000"
                if(reg[1] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"+"00000"
                if(reg[1] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"+"00000"
                if(reg[1] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"+"00000"
                array_counter += 1 
            if(lines[i].startswith("OR")):
                array[array_counter] = "01100"
                reg = line[1].split(',')
                if(reg[0] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"
                if(reg[0] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"
                if(reg[0] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"
                if(reg[0] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"
                if(reg[0] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"
                if(reg[0] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"
                if(reg[0] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"
                if(reg[0] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"
                ############### destination
                if(reg[1] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"+"00000"
                if(reg[1] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"+"00000"
                if(reg[1] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"+"00000"
                if(reg[1] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"+"00000"
                if(reg[1] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"+"00000"
                if(reg[1] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"+"00000"
                if(reg[1] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"+"00000"
                if(reg[1] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"+"00000"
                array_counter += 1 
            if(lines[i].startswith("SHL")):
                array[array_counter] = "01101"
                reg = line[1].split(',')
                if(reg[0] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"
                if(reg[0] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"
                if(reg[0] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"
                if(reg[0] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"
                if(reg[0] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"
                if(reg[0] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"
                if(reg[0] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"
                if(reg[0] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"
                ############### destination
                array[array_counter]  = array[array_counter] + '{0:08b}'.format(int(reg[1], 16))
                array_counter += 1 
            if(lines[i].startswith("SHR")):
                array[array_counter] = "01110"
                reg = line[1].split(',')
                if(reg[0] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"
                if(reg[0] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"
                if(reg[0] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"
                if(reg[0] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"
                if(reg[0] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"
                if(reg[0] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"
                if(reg[0] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"
                if(reg[0] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"
                ############### destination
                array[array_counter]  = array[array_counter] + '{0:08b}'.format(int(reg[1], 16))
                array_counter += 1
            #*********************MEMORY******************** 
            if(lines[i].startswith("PUSH")):
                array[array_counter] = "00111"
                if(line[1] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000" + "00000000"
                if(line[1] == 'R1'): 
                    array[array_counter] = array[array_counter] + "000" + "00100000"
                if(line[1] == 'R2'): 
                    array[array_counter] = array[array_counter] + "000" + "01000000"
                if(line[1] == 'R3'): 
                    array[array_counter] = array[array_counter] + "000" + "01100000"
                if(line[1] == 'R4'): 
                    array[array_counter] = array[array_counter] + "000" + "10000000"
                if(line[1] == 'R5'): 
                    array[array_counter] = array[array_counter] + "000" + "10100000"
                if(line[1] == 'R6'): 
                    array[array_counter] = array[array_counter] + "000" + "11000000"
                if(line[1] == 'R7'): 
                    array[array_counter] = array[array_counter] + "000" + "11100000"
                array_counter += 1
            if(lines[i].startswith("POP")):
                array[array_counter] = "10000"
                if(line[1] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000" + "00000000"
                if(line[1] == 'R1'): 
                    array[array_counter] = array[array_counter] + "000" + "00100000"
                if(line[1] == 'R2'): 
                    array[array_counter] = array[array_counter] + "000" + "01000000"
                if(line[1] == 'R3'): 
                    array[array_counter] = array[array_counter] + "000" + "01100000"
                if(line[1] == 'R4'): 
                    array[array_counter] = array[array_counter] + "000" + "10000000"
                if(line[1] == 'R5'): 
                    array[array_counter] = array[array_counter] + "000" + "10100000"
                if(line[1] == 'R6'): 
                    array[array_counter] = array[array_counter] + "000" + "11000000"
                if(line[1] == 'R7'): 
                    array[array_counter] = array[array_counter] + "000" + "11100000"
                array_counter += 1
            if(lines[i].startswith("LDM")):
                array[array_counter] = "01001"
                reg = line[1].split(',')
                array[array_counter + 1] = '{0:016b}'.format(int(reg[1], 16))
                if(reg[0] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000" + "00000000"
                if(reg[0] == 'R1'): 
                    array[array_counter] = array[array_counter] + "000" + "00100000"
                if(reg[0] == 'R2'): 
                    array[array_counter] = array[array_counter] + "000" + "01000000"
                if(reg[0] == 'R3'): 
                    array[array_counter] = array[array_counter] + "000" + "01100000"
                if(reg[0] == 'R4'): 
                    array[array_counter] = array[array_counter] + "000" + "10000000"
                if(reg[0] == 'R5'): 
                    array[array_counter] = array[array_counter] + "000" + "10100000"
                if(reg[0] == 'R6'): 
                    array[array_counter] = array[array_counter] + "000" + "11000000"
                if(reg[0] == 'R7'): 
                    array[array_counter] = array[array_counter] + "000" + "11100000"
                array_counter += 2 
            if(lines[i].startswith("LDD")):
                array[array_counter] = "10010"
                reg = line[1].split(',')
                ############### Rsrc 1
                if(reg[0] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"
                if(reg[0] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"
                if(reg[0] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"
                if(reg[0] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"
                if(reg[0] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"
                if(reg[0] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"
                if(reg[0] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"
                if(reg[0] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"
                ############### destination
                if(reg[1] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"+"00000"
                if(reg[1] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"+"00000"
                if(reg[1] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"+"00000"
                if(reg[1] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"+"00000"
                if(reg[1] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"+"00000"
                if(reg[1] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"+"00000"
                if(reg[1] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"+"00000"
                if(reg[1] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"+"00000"
                array_counter += 1 
            if(lines[i].startswith("STD")):
                array[array_counter] = "10011"
                reg = line[1].split(',')
                ############### Rsrc 1
                if(reg[0] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"
                if(reg[0] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"
                if(reg[0] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"
                if(reg[0] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"
                if(reg[0] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"
                if(reg[0] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"
                if(reg[0] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"
                if(reg[0] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"
                ############### destination
                if(reg[1] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"+"00000"
                if(reg[1] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"+"00000"
                if(reg[1] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"+"00000"
                if(reg[1] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"+"00000"
                if(reg[1] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"+"00000"
                if(reg[1] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"+"00000"
                if(reg[1] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"+"00000"
                if(reg[1] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"+"00000"
                array_counter += 1
            if(lines[i].startswith("JZ")):
                array[array_counter] = "10100000"
                if(line[1] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"+"00000"
                if(line[1] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"+"00000"
                if(line[1] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"+"00000"
                if(line[1] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"+"00000"
                if(line[1] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"+"00000"
                if(line[1] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"+"00000"
                if(line[1] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"+"00000"
                if(line[1] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"+"00000"
                array_counter += 1  
            if(lines[i].startswith("JN")):
                array[array_counter] = "10101000"
                if(line[1] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"+"00000"
                if(line[1] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"+"00000"
                if(line[1] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"+"00000"
                if(line[1] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"+"00000"
                if(line[1] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"+"00000"
                if(line[1] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"+"00000"
                if(line[1] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"+"00000"
                if(line[1] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"+"00000"
                array_counter += 1  
            if(lines[i].startswith("JC")):
                array[array_counter] = "10110000"
                if(line[1] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"+"00000"
                if(line[1] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"+"00000"
                if(line[1] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"+"00000"
                if(line[1] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"+"00000"
                if(line[1] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"+"00000"
                if(line[1] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"+"00000"
                if(line[1] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"+"00000"
                if(line[1] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"+"00000"
                array_counter += 1  
            if(lines[i].startswith("JMP")):
                array[array_counter] = "10111000"
                if(line[1] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"+"00000"
                if(line[1] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"+"00000"
                if(line[1] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"+"00000"
                if(line[1] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"+"00000"
                if(line[1] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"+"00000"
                if(line[1] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"+"00000"
                if(line[1] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"+"00000"
                if(line[1] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"+"00000"
                array_counter += 1  
            if(lines[i].startswith("CALL")):
                array[array_counter] = "11000000"
                if(line[1] == 'R0'): 
                    array[array_counter] = array[array_counter] + "000"+"00000"
                if(line[1] == 'R1'): 
                    array[array_counter] = array[array_counter] + "001"+"00000"
                if(line[1] == 'R2'): 
                    array[array_counter] = array[array_counter] + "010"+"00000"
                if(line[1] == 'R3'): 
                    array[array_counter] = array[array_counter] + "011"+"00000"
                if(line[1] == 'R4'): 
                    array[array_counter] = array[array_counter] + "100"+"00000"
                if(line[1] == 'R5'): 
                    array[array_counter] = array[array_counter] + "101"+"00000"
                if(line[1] == 'R6'): 
                    array[array_counter] = array[array_counter] + "110"+"00000"
                if(line[1] == 'R7'): 
                    array[array_counter] = array[array_counter] + "111"+"00000"
                array_counter += 1  
            ################################ branch (JZ, JN, JC, JMP, CALL) same of (OUT) & (RET) same of (IN)
            if(lines[i].startswith("RTI") | lines[i].startswith("RET")):
                if(lines[i].startswith("RET")):
                    array[array_counter] = "11001"
                if(lines[i].startswith("RTI")):
                    array[array_counter] = "11010"
                array[array_counter] = array[array_counter] + "00000000000"
                array_counter += 1 
            
write_file = open(file + ".mif", "w")
for arr in array:
        write_file.write(arr)
        write_file.write('\n')
write_file.close()