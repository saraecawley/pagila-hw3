#!/bin/bash

eval "$(dic --init)" 2>/dev/null

for i in $(seq 0 99); do
    echo '----------------------------------------'
    echo "ralph loop i=$i"
    echo '----------------------------------------'
    if ./run_tests.sh > /tmp/out 2>&1; then
        echo "tests pass after $i rounds"
        exit 0
    fi
    committe "$@" <<EOF
$(files-to-prompt sql)

$(docker compose exec -T pg psql -c '\d+ *')

$(cat /tmp/out)

fix the failing sql queries
EOF
done
