#!/bin/bash

eval "$(dic --init)" 2>/dev/null

out=$(mktemp)
trap 'rm -f "$out"' EXIT

for i in $(seq 0 99); do
    echo '----------------------------------------'
    echo "ralph loop i=$i"
    echo '----------------------------------------'

    if docker compose exec -T -w /tmp/pagila-hw pg ./run_tests.sh > "$out" 2>&1; then
        echo "tests pass after $i rounds"
        exit 0
    fi

    if [ ! -s "$out" ]; then
        echo "ERROR: tests failed without producing output."
        exit 1
    fi

    committe "$@" <<EOF || { echo "ERROR: committe failed, stopping"; exit 1; }
$(files-to-prompt sql)

$(docker compose exec -T pg psql -c '\d+ *')

TEST RESULTS:
$(cat "$out")

fix the failing sql queries
EOF
done
