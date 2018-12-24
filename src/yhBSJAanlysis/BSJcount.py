def sitesCout(IntputFile,OutFile):
    Filebedfile = open(str(IntputFile), 'r')
    record_matrix = []
    firstLine=True
    for line in Filebedfile:
        line = line.strip()
        line_matrix = line.split("\t")
        if firstLine:
            record_matrix=line_matrix
            firstLine=False
            continue
        else:
            if line_matrix[1] == record_matrix[1] and line_matrix[0] == record_matrix[0]:
                #print "haha"
                record_matrix[8] = str(int(record_matrix[8]) + int(line_matrix[8]))
                record_matrix[10] = str(int(record_matrix[10]) + int(line_matrix[10]))
                continue
            print "\t".join(record_matrix)
            record_matrix=line_matrix
    print "\t".join(record_matrix)
    Filebedfile.close()
    return