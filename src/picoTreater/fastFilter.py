import re
def Filefilter(fastFile,outFile):
    if re.match("/^[A,T,G,C]GGG/",strLine):
        return True
    else:
        return False