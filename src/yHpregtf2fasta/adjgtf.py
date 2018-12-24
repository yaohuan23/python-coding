import re
def rebuidGtf(preGTF):
    Fileinputfile = open(str(preGTF), 'r')
    currentcirc=[]
    currentcircNum=0
    currentcirStart=9999999999999
    currentcirEnd=0
    current_exon=0
    pre_exon=""
    for line in Fileinputfile:
        line = line.strip()
        line_matrix = line.split("\t")
        if not re.match("^#",line_matrix[0]):
            if isTranscript(line_matrix) :
                print "\t".join(currentcirc)
                print pre_exon
                pre_exon = ""
                currentcirc = line_matrix
                currentcirStart = 9999999999999
                currentcirEnd = 0
                currentcirc = line_matrix
                currentcircNum = currentcircNum +1
                current_exon=1
                #currentcirStart = line_matrix[3]
                #currentcirEnd = line_matrix[4]
            else:
                if currentcirStart > int(line_matrix[3]):
                    currentcirStart = int(line_matrix[3])
                if currentcirEnd < int(line_matrix[4]):
                    currentcirEnd = int(line_matrix[4])
                exon_info = line_matrix[8]
                exon_info = exon_info.strip()
                exon_info_matrix = exon_info.split(";")
                exon_info_matrix[2] = 'exon_number "%d"' % current_exon
                current_exon = current_exon + 1
                line_matrix[8] = ";".join(exon_info_matrix)
                pre_exon = pre_exon + "\t".join(line_matrix) + "\n"
            currentcirc[3] = str(currentcirStart)
            currentcirc[4] = str(currentcirEnd)
            #print currentcirc
        else:
            print line
    Fileinputfile.close()

def isTranscript(line_matrix):
    if line_matrix[2] == "transcript":
        return True
    return False

def getBSJR(refFa,OutFile):
    Fileinputfile = open(str(refFa), 'r')
    OutFile = open(str(OutFile),'w')
    for line in Fileinputfile:
        line=line.strip()
        if not re.match("^>", line):
            OutFile.writelines(line + getBeginsubBase(line,50 if(50 <len(line)) else len(line)-1 ))
            OutFile.writelines("\n")
            #print line + getBeginsubBase(line,50 if(50 <len(line)) else len(line)-1 )
        else:
            OutFile.writelines( line )
            OutFile.writelines("\n")
    Fileinputfile.close()
    OutFile.close()

def getaroundBSJ(refFa,OutFile):
    Fileinputfile = open(str(refFa), 'r')
    OutFile = open(str(OutFile), 'w')
    for line in Fileinputfile:
        line = line.strip()
        if not re.match("^>", line):
            if len(line) >100:
                OutFile.writelines(getEndsubBase(line,50) + getBeginsubBase(line, 50 ))
                OutFile.writelines("\n")
            else:
                OutFile.writelines(line)
                OutFile.writelines("\n")
            # print line + getBeginsubBase(line,50 if(50 <len(line)) else len(line)-1 )
        else:
            OutFile.writelines(line)
            OutFile.writelines("\n")
    Fileinputfile.close()
    OutFile.close()
def getBeginsubBase(line,BaseNum):
    return line[0:BaseNum-1]

def getEndsubBase(line,BaseNum):
    return line[len(line)-BaseNum:len(line)]