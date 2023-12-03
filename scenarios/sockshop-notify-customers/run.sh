#!/bin/bash

URL_BASE="http://localhost:8082/catalogue"
CYCLES=100
MIN_REQ=10
MAX_REQ=200
ITEM_SLEEP_S_MIN=0
ITEM_SLEEP_S_MAX=5
CYCLE_SLEEP_S_MIN=0
CYCLE_SLEEP_S_MAX=15
ITEM_IDS=("03fef6ac-1896-4ce8-bd69-b798f85c6e0b"
  "510a0d7e-8e83-4193-b483-e27e09ddc34d"
  "zzz4f044-b040-410d-8ead-4de0446aec7e"
  "d3588630-ad8e-49df-bbd7-3167f7efb246"
  "819e1fbf-8b7e-4f6d-811f-693534916a8b"
  "808a2de1-1aaa-4c25-a9b9-6612e8f29a38")

function rand_in_range {
  MIN="$1"
  MAX="$2"
  local result=$(($RANDOM%($MAX-$MIN+1)+$MIN))
  echo $result
}

for c in $(seq 1 $CYCLES); do
  echo "Cycle $c / $CYCLES"
  for i in ${!ITEM_IDS[@]}; do
    item_id=${ITEM_IDS[$i]}
    req_cnt=$(rand_in_range $MIN_REQ $MAX_REQ)
    echo "$req_cnt"
    url="$URL_BASE/$item_id"
    echo "Sending GET $url $req_cnt times"
    for r in $(seq 1 $req_cnt); do
      curl -s $url > /dev/null
    done
    item_sleep_s=$(rand_in_range $ITEM_SLEEP_S_MIN $ITEM_SLEEP_S_MAX)
    echo "Sleep before next item: $item_sleep_s s"
    sleep $item_sleep_s
  done
  cycle_sleep_s=$(rand_in_range $CYCLE_SLEEP_S_MIN $CYCLE_SLEEP_S_MAX)
  sleep $cycle_sleep_s
  echo -e "Sleep before next cycle: $cycle_sleep_s s\n"
done
