#!/usr/bin/env bash

STAT_NAME=""
FILE_NAME=""

# parse args
while [[ $# -gt 0 ]]
do
	key=$1
	case $key in
		-s|--stat)
			STAT_NAME=$2
			shift 2
			;;
		*)
			FILE_NAME=$1
			shift 1
			;;
	esac
done

if [[ -z $STAT_NAME ]]; then
	echo "Stat name not found"
	exit 0
fi

if [[ -z $FILE_NAME ]]; then
	echo "File name not found"
	exit 0
fi

# find stat position
STAT_POS=$(cat $FILE_NAME | head -n1 | awk -f csv-parser.awk -v stat_name=$STAT_NAME --source '{csv_find_colnum($0, stat_name)}')

# get full sample
SAMPLE=$(awk -f csv-parser.awk -v colnum=$STAT_POS --source '{csv_parse($0, colnum)}' $FILE_NAME)

# get unique elements
UNIQUE=$(echo $SAMPLE | tr ' ' '\n' | sort | uniq)

# find maximum count
COUNT_MX=0
for v in $UNIQUE
do
	CNT=$(echo $SAMPLE | tr ' ' '\n'| awk -F '\n' -v val=$v '{if (val == $1) print 1}' | wc -l)
	#echo $CNT
	if [[ $CNT -ge $COUNT_MX ]]; then
		COUNT_MX=$CNT
	fi
done;
#echo $COUNT_MX

# draw lines
for v in $UNIQUE
do
	CNT=$(echo $SAMPLE | tr ' ' '\n'| awk -F '\n' -v val=$v '{if (val == $1) print 1}' | wc -l)
	CNT_LINES=$(expr 80 \* $CNT / $COUNT_MX)
	printf ${v}'\t'
	printf "%${CNT_LINES}s" | tr ' ' '='
	printf '\n'
	#printf "${v}\t%-30s\n" "="
done;

#echo $SAMPLE | head

#echo $STAT_POS
