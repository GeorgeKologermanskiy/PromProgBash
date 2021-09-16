#!/usr/bin/env bash

function memory {
	VAL=$(ls -ld $1 | awk -F ' ' '{print $5}')
	#V1=$(stat -c %b $1)
	#V2=$(stat -c %B $1)
	#VAL=$(($V1*$V2))
	echo $VAL
}

function dfsDir {
	SUM=$(memory $1)

        # add files
        for FILE in $(ls -lA $1 | awk '/^-/' | awk -F ' ' '{print $9}')
        do
		VAL=$(memory $1/$FILE)
                #echo $1/$FILE $VAL
		SUM=$(($SUM+$VAL))
        done;

        # dfs dirs
        for DIR in $(ls -lA $1 | awk '/^d/' | awk -F ' ' '{print $9}')
        do
		VAL=$( dfsDir $1/$DIR )
		SUM=$(($SUM+$VAL))
        done;

        # return sum
        echo $SUM
}

function main {
	SUM=0
	if [[ -d $1 ]]; then
		SUM=$(dfsDir $1)
	else
		SUM=$(memory $1)
	fi

	echo $SUM $1
}

main $1

