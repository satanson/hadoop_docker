#!/usr/bin/bash -e

echo "OK"

set -e -o pipefail
saved=$(set +o)
set +e +o pipefail
test 1 eq 2
eval "$saved"

echo "OK"
test 1 eq 2
echo "OK"
