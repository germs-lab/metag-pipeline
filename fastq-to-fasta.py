import screed, sys

for record in screed.open(sys.argv[1]):
    print ">" + record.name
    print record.sequence
