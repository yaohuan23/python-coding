import re
def rmBEStag(inputfile,outputfile):
    Filebedfile = open(str(inputfile), 'r')
    FileOut = open(str(outputfile),'w')
    #print FileOut
    for line in Filebedfile:
        line=line.strip()
        line_matrix = line.split("\t")
        if re.match("^[1-3]S",str(line_matrix[5])):
            numB=int(line_matrix[5][0:1])
            Samline = rmBeginS(line_matrix,numB)
            FileOut.writelines(line)
            FileOut.writelines("\r")
        #print line_matrix[5]
    Filebedfile.close()
    FileOut.close()
def rmBeginS(lineSam_matrix,numB):
    #lineSam_matrix
    print lineSam_matrix[1]
    print lineSam_matrix[7]
    lineSam_matrix[1] = str(int(lineSam_matrix[1]) - numB)
    lineSam_matrix
    print "\t".join(lineSam_matrix)
    return "\t".join(lineSam_matrix)
