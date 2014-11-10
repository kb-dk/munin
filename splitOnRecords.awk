BEGIN {
	active=0;
	print "BatchId, jobtype, starttime, jobid, endtime, totalmaptime, totalreducetime, maptasks";
}

# Output:
# BatchId, job type, start time, end time, duration, jobId, #map input records, map time, reduce time

#2014-08-12 07:50:07.901 INFO  d.s.m.autonomous.AutonomousComponent - Found batch B400026955287-RT2
/Found/ {
	if (!active) {
		print "RECORD START" | "cat 1>&2"
		split($0, s, "batch ");
		printf "%s", s[2];
		printf ", %s", jobtype
		active=1
	} else {
		print "ERROR - out of sequence!" $0 | "cat 1>&2"
		print "FAILED"
		print "RECORD START" | "cat 1>&2"
		split($0, s, "batch ");
		printf "%s", s[2];
		printf ", %s", jobtype
		active=1
	}
}

# 2014-08-11 10:30:14.415 INFO  org.apache.hadoop.mapreduce.Job - Running job: job_1407155868271_0080
/Running job:/ {
	if (active==1) {
		#printf "\tSTART: %s\n", $0
		split($0,s," INFO ");
		printf ", %s", s[1];
		split($0,s,"Running job: ")
		printf ", %s", s[2];
	}
}

# This is the last log message in a record
#		Map input records=11680
/Map input records/ {
	if (active==1) {
		#printf "\t%s, \n", $0
		split($0, s, "=");
		printf ", %s\n", s[2];
		print "RECORD END" | "cat 1>&2"
		active = 0
	}
}

#		Total time spent by all maps in occupied slots (ms)=5512646
/Total time spent by all maps in occupied slots/ {
	if (active==1) {
		#printf "\t%s, \n", $0
		split($0, s, "=");
		printf ", %s", s[2];
	}
}

#		Total time spent by all reduces in occupied slots (ms)=81308394
/Total time spent by all reduces in occupied slots/ {
	if (active==1) {
		#printf "\t%s, \n", $0
		split($0, s, "=");
		printf ", %s", s[2];
	}
}


/failed with state FAILED due/ {
	if (active==1) {
		#print "\tFAILED: " $0
		printf ", FAILED\n";
		active = 0
		print "RECORD END" | "cat 1>&2"
	}
}

#2014-08-12 04:38:00.649 INFO  org.apache.hadoop.mapreduce.Job - Job job_1407155868271_0084 completed successfully
/completed successfully/ {
	if (active==1) {
		#print "\tSTOP: " $0
		split($0, s, " INFO ");
		printf ", %s", s[1];
	}
}
