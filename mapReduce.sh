#!/bin/bash
# To create 'files' file with selected file names/dates:
# hadoop fs -ls /user/smart/production/referrals/daily/ | grep YYYYMM > files_YYYYMM.txt

VAR="HADOOP_CLASSPATH=/path/to/hadoop_archive.jar:\$HADOOP_CLASSPATH"
FILES=( files_201110.txt files_201111.txt files_201112.txt files_YYYYMM.txt )

for x in ${FILES[@]}
do
	cat $x | while read line
    do 
       awk '{print $8}' | sed -e 's/\// /g' | sed -e 's/\./ /g' | awk '{print $6}' > dates.txt
    done

    for line in $(cat dates.txt)
    do 
       hadoop archive -Dmapred.job.queue.name=audience -archiveName $line.har -p /path/to/files/ $line.bz2 /path/to/archive/files/
    done
done
rm dates.txt
