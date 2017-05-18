#!/bin/bash
ps -ef | awk 'BEGIN { OFS=","} NR > 1 {print $1,$2,$3}' > PsData.txt
