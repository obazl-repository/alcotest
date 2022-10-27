#!/bin/sh

## or #!/usr/bin/env bash

gen_actuals() {
    echo "GEN_ACTUALS"
    exe=$1
    shift
    name=$1
    shift
    # echo "exe: $exe"
    # echo "name: $name"
    # echo "args: $@"
    $($exe $@) > $name.actual 2>&1
    if [ "$rc" -ne "0" ]; then
        echo `ACTUAL: cat $name.actual`
        return $rc
    fi

    # $1 > $2.actual 2>&1
    # if [ "$rc" -ne "0" ]; then
    #     echo `ACTUAL: cat $2.actual`
    #     return $rc
    # fi
}

test_name=$1
shift
test_exe=$1
shift
# stripper=$3
# expected=$4

gen_actuals $test_exe $test_name $@
exit $?

