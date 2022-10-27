#!/bin/sh

## or #!/usr/bin/env bash

PFX="test/e2e/alcotest/failing"

gen_actuals() {
    $1 > $2.actual 2>&1
    # if verbose:
    # echo "ACTUAL: `cat $2.actual`"
}

strip_actuals() {
    $1 $2.actual > $2.processed
    # if verbose:
    # echo "PROCESSED: `cat $2.processed`"
}

diff_expected_processed() {
    diff $1 $2.processed > $2.diff_output 2>&1
    rc=$?
    if [ "$rc" -ne "0" ]; then
        echo `cat $2.diff_output`
        return $rc
    fi
}

test_name=$1
test_exe=$2
stripper=$3
expected=$4

gen_actuals $test_exe $test_name
strip_actuals $stripper $test_name
diff_expected_processed $expected $test_name
exit $?

