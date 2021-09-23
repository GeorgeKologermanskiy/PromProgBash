#!/usr/bin/env bash

cat | awk -F '\t' -f reducer.awk --source 'BEGIN{cnt=0; last_str="";}{reduce($1, $2) }' | sort -h -r -k2
