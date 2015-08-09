#!/bin/bash
# Aggregate port access stats from APF log files

cat apf_drops* | \
egrep 'PROTO=(UDP|TCP|2)' | \
perl -pe 's/^.*PROTO=(UDP|TCP|2)(?: SPT=(?:[0-9]+) DPT=([0-9]+))?.*$/($1==2?"ICMP":$1).($2?",".$2:"")/eg' | \
sort | \
uniq -c | \
sed -r 's/^ +([0-9]+) /\1,/' | \
sort -r -n
