#!/bin/sh

## or #!/usr/bin/env bash

test_name=$1; shift
test_exe=$1; shift
stripper=$1; shift
expected=$1; shift
exe_args=$@

gen_actuals() {
    exe=$1; shift
    name=$1; shift
    $exe $@ > $name.actual 2>&1
    rc=$?
    case $rc in
        0) ##  | 1 | 124 | 125)
            # echo "ACTUAL: `cat $name.actual`"
        ;;
        *)
            # echo "RC: $rc"
            echo $(cat $name.actual)
            return $rc
    esac
}

strip_actuals() {
    stripper=$1
    $stripper "$2.actual" > $2.processed
    rc=$?
    if [ "$rc" -ne "0" ]; then
        echo "PROCESSED: $(cat $2.processed)"
        return $rc
    fi
}

diff_expected_processed() {
    diff $1 $2.processed > $2.diff_output 2>&1
    # $(diff <$(sed -n '3,7p' $1) <$(sed '3,7p' $2.processed)) > $2.diff_output 2>&1
    rc=$?
    if [ "$rc" -ne "0" ]; then
        echo `cat $2.diff_output`
        return $rc
    fi
}

gen_actuals $test_exe $test_name $exe_args
strip_actuals $stripper $test_name
diff_expected_processed $expected $test_name

exit $?

