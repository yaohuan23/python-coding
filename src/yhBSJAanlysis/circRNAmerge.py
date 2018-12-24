def spitebychr(inputfile,dir_path):
    Fileinputfile=open(str(inputfile),'r')
    for line in Fileinputfile:
        line = line.strip()
        line_matrix = line.split("\t")
        chrNum=str(line_matrix[0])
        record_file=str(chrNum + str(dir_path))
        recordWrite(line,record_file)


def recordWrite(line,record_file):
    Fileopen = str(record_file)
    writefile = open(Fileopen,"a")
    writefile.writelines(line)
    writefile.writelines("\n")
    writefile.close()
