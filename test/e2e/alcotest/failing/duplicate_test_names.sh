#!/bin/sh

## or #!/usr/bin/env bash

PFX="test/e2e/alcotest/failing"

gen_actuals() {
    $1 > duplicate_test_names.actual 2>&1
}

strip_actuals() {
    $1 duplicate_test_names.actual > duplicate_test_names.processed
}

diff_expected_processed() {
    diff $1 duplicate_test_names.processed > duplicate_test_names.diff_output 2>&1
    rc=$?
    if [ "$rc" -ne "0" ]; then
        echo `cat duplicate_test_names.diff_output`
        return $rc
    fi
}

test_exe=$1
stripper=$2
expected=$3

gen_actuals $test_exe
strip_actuals $stripper
diff_expected_processed $expected
exit $?

