#!/usr/bin/env bash

cat | awk -F ';' '{if (NR != 1) print $5}' | awk -F ' ' '{ for (i = 1; i <= NF; ++i) print $i"\t"1 }'
