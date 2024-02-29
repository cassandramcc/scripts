#!/bin/bash

PACKAGE=""
TEST=""
CONTINUE_ON_FAILURE=false
PASSES=0
FAILURES=0
NUM_ITERATIONS=10

print_help() {
  echo "Usage: $0 [-p package] [-t test] [-c] [-n num_iterations] [-h]"
  echo
  echo "Options:"
  echo "  -p package        Specify the package to test"
  echo "  -t test           Specify the test to run"
  echo "  -c                Continue on failure"
  echo "  -n num_iterations Specify the number of iterations (default: 10)"
  echo "  -h                Display this help message"
}

while getopts ":p:t:c:n:h" opt; do
  case ${opt} in
    p )
      PACKAGE=$OPTARG
      ;;
    t )
      TEST=$OPTARG
      ;;
    c )
      CONTINUE_ON_FAILURE=true
      ;;
    n )
      NUM_ITERATIONS=$OPTARG
      ;;
    h )
      print_help
      exit 0
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      exit 1
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

for ((i=1; i<=NUM_ITERATIONS; i++))
do
  if [ -n "$TEST" ]; then
    go test -count=1 -run $TEST -p 1 -v
  else
    go test -count=1 $PACKAGE -p 1 -v
  fi

  if [ $? -eq 0 ]; then
    let PASSES++
  else
    let FAILURES++
    if [ "$CONTINUE_ON_FAILURE" = false ]; then
      echo "Passes: $PASSES"
      echo "Failures: $FAILURES"
      exit 1
    fi
  fi
done

echo "Passes: $PASSES"
echo "Failures: $FAILURES"