import fileinput
from dateutil.parser import parse

header = True
for line in fileinput.input():
	if header:
		print line
		header = False
	else:
		ss=line.rstrip().split(",")
		#print ss
		tStart = parse(ss[2])
		if "FAILED" in ss[4]:
			print "{0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}".format(
				ss[0],ss[1],ss[2],ss[3],"-",ss[4],"-", "-", "-")
		else:
			tEnd = parse(ss[4])
			duration = tEnd - tStart
			print "{0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}".format(
				ss[0],ss[1],ss[2],ss[3],duration,ss[4],ss[5],ss[6],ss[7])
