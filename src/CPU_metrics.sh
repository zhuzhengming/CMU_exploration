#!/usr/bin/env bash

###############################################################################
 #
 # COPYRIGHT (c) 2017 by BurryChen
 #
 # This file belongs to BurryChen. It is considered a trade secret,
 # and is not to be divulged or used by parties who have not received written 
 # authorization from the owner.
 #
###############################################################################

usage () {
  echo "  Usage: $0 [-f] [-i] [-v] [-h]"
}

help () {
  echo
  usage
  echo
  echo "  Options: "
  echo
  echo "    -f, --filename <filename>  log file that saves the metrics (default: ./metrics.csv)"
  echo "    -i, --interval <seconds>   collect metrics every n seconds (default: 0.5)"
  echo "    -v, --verbose              enable verbose mode"
  echo "    -h, --help                 show this text"
  echo
}

FILENAME="./metrics.csv"
INTERVAL=0.5
VERBOSE=false

while [ $# -gt 0 ]; do
  case $1 in
    -f|--filename)
      shift
      FILENAME=$1
      ;;

    -i|--interval)
      shift
      INTERVAL=$1
      ;;

    -v|--verbose)
      VERBOSE=true
      ;;

    -h|--help)
      help
      exit
      ;;

    *)
      usage
      exit 1
      ;;
  esac

  shift
done

echo "Started recording system metrics."
echo "Log file location: $FILENAME"
echo "Report interval: $INTERVAL"

echo "timestamp, cpu, mem" > $FILENAME

while true; do
  timestamp=$(date +"%b %d %H:%M:%S")
  cpu_usage=$(ps axo %cpu | awk '{ sum+=$1 } END { printf "%.1f\n", sum }' | tail -n 1)
  mem_usage=$(free | awk '/Mem:/ { printf "%.1f\n", $3 / $2 * 100 }')
  echo "$timestamp, $cpu_usage, $mem_usage" >> $FILENAME 
  if [ $VERBOSE = true ]; then
    echo "$timestamp, CPU:$cpu_usage, MEM:$mem_usage"
  fi
  sleep $INTERVAL
done
