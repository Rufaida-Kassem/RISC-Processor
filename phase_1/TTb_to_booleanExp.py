# import pandas lib as pd
import pandas as pd
import numpy as np
# # read by default 1st sheet of an excel file
# cuExcelSheet = pd.read_excel('control_unit_circuit.xlsx')
# for col in cuExcelSheet.columns:
# df = pd.ExcelFile('control_unit_circuit.xlsx').parse('Sheet2') #you could add index_col=0 if there's an index
x=[]
# colName = input("please, enter column name in excel sheet2:\n")
# x.append(df.bool)
functionFile = open("truthTable.txt","r") 
# \n is placed to indicate EOL (End of Line)
while (f := functionFile.readline()):
    x.append(bool(int(f)))
functionFile.close() #to change file access modes
inputs = np.array(['(~A4 & ~A3 & ~A2 & ~A1 & ~A0))',
                   ' | (~A4 & ~A3 & ~A2 & ~A1 & A0)',
                   ' | (~A4 & ~A3 & ~A2 & A1 & ~A0)',
                   ' | (~A4 & ~A3 & ~A2 & A1 & A0)',
                   ' | (~A4 & ~A3 & A2 & ~A1 & ~A0)',
                   ' | (~A4 & ~A3 & A2 & ~A1 & A0)',
                   ' | (~A4 & ~A3 & A2 & A1 & ~A0)',
                   ' | (~A4 & ~A3 & A2 & A1 & A0)',
                   ' | (~A4 & A3 & ~A2 & ~A1 & ~A0)',
                   ' | (~A4 & A3 & ~A2 & ~A1 & A0)',
                   ' | (~A4 & A3 & ~A2 & A1 & ~A0)',
                   ' | (~A4 & A3 & ~A2 & A1 & A0)',
                   ' | (~A4 & A3 & A2 & ~A1 & ~A0)',
                   ' | (~A4 & A3 & A2 & ~A1 & A0)',
                   ' | (~A4 & A3 & A2 & A1 & ~A0)',
                   ' | (~A4 & A3 & A2 & A1 & A0)',
                   ' | (A4 & ~A3 & ~A2 & ~A1 & ~A0)',
                   ' | (A4 & ~A3 & ~A2 & ~A1 & A0)',
                   ' | (A4 & ~A3 & ~A2 & A1 & ~A0)',
                   ' | (A4 & ~A3 & ~A2 & A1 & A0)',
                   ' | (A4 & ~A3 & A2 & ~A1 & ~A0)',
                   ' | (A4 & ~A3 & A2 & ~A1 & A0)',
                   ' | (A4 & ~A3 & A2 & A1 & ~A0)',
                   ' | (A4 & ~A3 & A2 & A1 & A0)',
                   ' | (A4 & A3 & ~A2 & ~A1 & ~A0)',
                   ' | (A4 & A3 & ~A2 & ~A1 & A0)',
                   ' | (A4 & A3 & ~A2 & A1 & ~A0)',
                   ' | (A4 & A3 & ~A2 & A1 & A0)',
                   ' | (A4 & A3 & A2 & ~A1 & ~A0)',
                   ' | (A4 & A3 & A2 & ~A1 & A0)',
                   ' | (A4 & A3 & A2 & A1 & ~A0)',
                   ' | (A4 & A3 & A2 & A1 & A0'])
functionFile = open("function.txt","w") 
# \n is placed to indicate EOL (End of Line)
functionFile.writelines(inputs[x])
functionFile.close() #to change file access modes