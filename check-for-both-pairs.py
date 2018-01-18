import sys

'''checks blastoutput for both sets of a paired read'''

d = {}

for line in open(sys.argv[1]): #read 1
    dat = line.rstrip().split('\t')
    query = dat[0]
    hit = dat[1]
    d[query] = hit

for line in open(sys.argv[2]): #read 2
    dat = line.rstrip().split('\t')
    query = dat[0]
    hit = dat[1]
    if d.has_key(query):
        if d[query] == hit:
            print line,
        else:
            continue
    else:
        continue
