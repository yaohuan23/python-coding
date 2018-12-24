def filter(input_hash,sample_list,cutoff):
    print("You are treating these samples {}".format(sample_list))
    outPutHash = {"sample_list":sample_list}
    for i in range(0,len(input_hash),1):
        filter_machine=1
        expression_matrix=[]
        for j in range(0,len(sample_list),1):
            expression_value = float(input_hash['{}'.format(i + 1)]['{}'.format(sample_list[j])])
            expression_matrix.append(expression_value)
            if (expression_value < cutoff):
                filter_machine=0
                break
        if( filter_machine ==1 ):
            input_hash['{}'.format(i + 1)]["filter"] = True
            outPutHash['{}'.format(i +1 )] =expression_matrix
            #print(input_hash)
        else:
            input_hash['{}'.format(i + 1)]["filter"] = False
    return outPutHash

