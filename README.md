munin
=====

miscellaneous snippets

## splitOnRecords.awk

E.g.

  awk -f splitOnRecords.awk jobtype=PMD  < hadoop-jpylyzer-complete.log 2>/dev/null |head -20

## calcDuration.py

This Python script takes the output from the above AWK script at calculates the difference between the 2nd and 4th columns. The result is added in a new column before the 4th.

E.g.
 awk -f splitOnRecords.awk jobtype=PMD  < complete-avis-logs/hadoop-jpylyzer-complete.log  2>/dev/null|head -20|python calcDuration.py
