import re
def rmBEStag(inputfile,outputfile):
    Filebedfile = open(str(inputfile), 'r')
    FileOut = open(str(outputfile),'w')
    #print FileOut
    for line in Filebedfile:
        line=line.strip()
        line_matrix = line.split("\t")
        blockNum = int(line_matrix[9])
        if blockNum > 1:
            startPo = line_matrix[1]
            #EndPo = line_matrix[2]
            bedLen_matrix = str(line_matrix[10]).split(",")
            bedPo_matrix = str(line_matrix[11]).split(",")
            i = 0
            while i < blockNum :
                if int(bedLen_matrix[i]) >3 :
                    line_matrix[9] = "1"
                    line_matrix[1] = str(int(startPo) + int(bedPo_matrix[i]))
                    line_matrix[2] = str(int(line_matrix[1]) + int(bedLen_matrix[i]) -1)
                    line_matrix[10] = bedLen_matrix[i]
                    line_matrix[11] = "0"
                    line_matrix[6] = line_matrix[1]
                    line_matrix[7] = line_matrix[2]
                    FileOut.writelines("\t".join(line_matrix))
                    FileOut.writelines("\n")
                i+=1
        else:
            FileOut.writelines("\t".join(line_matrix))
            FileOut.writelines("\n")
        #print bedLen_matrix[1]
        #print bedPo_matrix[1]
    Filebedfile.close()
    FileOut.close()
def rmBeginS(lineSam_matrix,numB):
    print "\t".join(lineSam_matrix)
    return "\t".join(lineSam_matrix)
