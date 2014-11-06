munin
=====

miscellaneous snippets

## splitOnRecords.awk

E.g.

  awk -f splitOnRecords.awk jobtype=PMD  < hadoop-jpylyzer-complete.log 2>/dev/null |head -20

