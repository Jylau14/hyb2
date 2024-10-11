#!/usr/bin/env python

import pandas as pd
import os
import sys

name = str(sys.argv[1])
val = int(sys.argv[2])
#create df for new row with 0 values, since code takes first row regardless of 'p'
new_row = pd.DataFrame({'x': 0, 'y': 0, 'p': 0 , 'f':0, 'a':0}, index = [0])
for filename in os.listdir('.'):
    if filename.startswith('DESeq_' + name) and filename.endswith("heatmap.txt"):
        data = pd.read_csv(filename, sep="	", skiprows=1, header=None)
        data.columns = ["x", "y", "p", "f", "a"] # assigning name to columns
        data = pd.concat([new_row, data[:]]).reset_index(drop = True) #insert new row in data, resetting index to 0
        output_file_red = open(name + "_" + str(val) + "range_pos_enrichment.txt","w")
        output_file_blue = open(name + "_" + str(val) + "range_neg_enrichment.txt","w")
        
        x_red = []
        y_red = []
        f_red = []
        a_red = []
        x_blue = []
        y_blue = []
        f_blue = []
        a_blue = []
        initial = True              
#write unique values of data in x_list and y_list, excluding a range of value (+/- (value)) that were written into x_list and y_list but found in data
#x_list, y_list written into output through loops iterating through all rows from data
#red = positive/red in DESeq heatmap, blue otherwise
        for index, row in data.iterrows():
            if x_red:
                flag = True
                for i in range(len(x_red)):
                    if (((row['x']) <= x_red[i] + val) and ((row['x']) >= x_red[i] - val) and ((row['y']) <= y_red[i] + val) and ((row['y']) >= y_red[i] - val) or ((row['p']) <= 0)):
                        flag = False
                        break
                if flag:
                    x_red.append(row['x'])
                    y_red.append(row['y'])
                    f_red.append(row['f'])
                    a_red.append(row['a'])
                    output_file_red.write(str(int(row['x'])) + "	" + str(int(row['y'])) + "	" + str((row['f'])) + "	" + str((row['a'])) + "\n")
            else:
                x_red.append(row['x'])
                y_red.append(row['y'])
                f_red.append(row['f'])
                a_red.append(row['a'])
                output_file_red.write(str(int(row['x'])) + "	" + str(int(row['y'])) + "	" + str((row['f'])) + "	" + str((row['a'])) + "\n")
        for index, row in data.iterrows():
            if x_blue:
                flag = True
                for i in range(len(x_blue)):
                    if (((row['x'] <= x_blue[i] + val) and (row['x'] >= x_blue[i] - val)) and ((row['y'] <= y_blue[i] + val) and (row['y'] >= y_blue[i] - val)) or (row['p'] >= 0)):
                        flag = False
                        break
                if flag:
                    x_blue.append(row['x'])
                    y_blue.append(row['y'])
                    f_blue.append(row['f'])
                    a_blue.append(row['a'])
                    output_file_blue.write(str(int(row['x'])) + "	" + str(int(row['y'])) + "	" + str((row['f'])) + "	" + str((row['a'])) + "\n")
            else:
                x_blue.append(row['x'])
                y_blue.append(row['y'])
                f_blue.append(row['f'])
                a_blue.append(row['a'])
                output_file_blue.write(str(int(row['x'])) + "	" + str(int(row['y'])) + "	" + str((row['f'])) + "	" + str((row['a'])) + "\n")
#flush any data not yet written to file
output_file_red.flush()
output_file_blue.flush()
