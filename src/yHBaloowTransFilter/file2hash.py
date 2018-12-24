def csv2hash(csvfile, verbose=False):
    # type: (object, object) -> object
    line_num = 0
    expression_record={}
    expression_result={}
    hash_param = []
    sample_list=[]
    for line in csvfile:
        line = line.strip()
        line = line.replace('"','')
        line_array = list(line.split(","))
        #print(line_array)
        param_numb = len(line_array)
        sample_num= (param_numb-10)//2
        if line_num == 0:
            for i in range(0, param_numb, 1):
                hash_param.append(line_array[i])
            for i in range(0,sample_num,1):
                #sample_id=param_numb-8
                sample_list.append(line_array[12+2*i])
            #print(sample_list)
        else:
            for i in range(1, param_numb, 1):
                from string import lstrip
                expression_result[hash_param[i]] = line_array[i]
            expression_record[expression_result['t_id']] = expression_result
        line_num += 1
    #sample_str=','.join(sample_list)
    return {'expression_record':expression_record,'sample_list':sample_list}