#!/bin/bash

if [ ${DIB_DEBUG_TRACE:-0} -gt 0 ]; then
    set -x
fi
set -o errexit
set -o nounset
set -o pipefail

# Use current shell path as elements path
export ELEMENTS_PATH="$(dirname "$0")"

diskimage-builder $@
