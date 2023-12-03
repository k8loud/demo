#!/bin/bash

URL_BASE="http://localhost:8082/catalogue"
CYCLES=10
ITEM_IDS=("03fef6ac-1896-4ce8-bd69-b798f85c6e0b"
  "510a0d7e-8e83-4193-b483-e27e09ddc34d"
  "zzz4f044-b040-410d-8ead-4de0446aec7e"
  "d3588630-ad8e-49df-bbd7-3167f7efb246"
  "819e1fbf-8b7e-4f6d-811f-693534916a8b")
REQ_PER_CYCLE=(60 80 100 50 10)

for c in $(seq 1 $CYCLES); do
  echo "Cycle $c / $CYCLES"
  for i in ${!ITEM_IDS[@]}; do
    item_id=${ITEM_IDS[$i]}
    req_cnt=${REQ_PER_CYCLE[$i]}
    url="$URL_BASE/$item_id"
    echo "Sending GET $url $req_cnt times"
    for r in $(seq 1 $req_cnt); do
      curl -s $url > /dev/null
    done
  done
  echo ""
done
