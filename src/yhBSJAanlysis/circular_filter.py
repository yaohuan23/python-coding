import circnum2junctionnum
def junctionFilter(bedfile,cutNum,fileName, cutPercent):
    bedfile=str(bedfile)
    Filebedfile = open(bedfile,'r')
    fileName = str(fileName[0] + ".txt")
    outPut=open(fileName,'w')
    maxjun=getMaxjun(bedfile)
    for line in Filebedfile:
        line = line.strip()
        line_matrix = line.split("\t")
        line_record=int(line_matrix[6])
        if (filterByNum(line_record,cutNum) and filterByPercent(maxjun,line_record,cutPercent)) :
            outPut.writelines(line)
            outPut.writelines("\n")
    outPut.close()
    Filebedfile.close()
    return

def filterByNum (juncNum,cutoff,):
    if juncNum > cutoff:
        return True
    return False
def filterByPercent(maxjun,juncNum,cutPercent):
    cutoffNum = maxjun * cutPercent
    if juncNum < cutoffNum:
        return True
    return False
def getMaxjun(bedfile):
    recordMax = circnum2junctionnum.juncstatic(bedfile, -1)[1][0]
    return recordMax
def testfile(bedfile):
    for line in bedfile:
        linecontent = line.strip()
        print linecontent
    return