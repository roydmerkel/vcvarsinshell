#!/bin/bash

if [ "${VSCOMNTOOLS:-}" == "" ]; then
    dollar0=$(realpath "${BASH_SOURCE[0]}")
    vc=$(realpath "$(dirname "${dollar0}")/../../")
    export VSCOMNTOOLS="${vc}/Common7/Tools/"
fi

. "${VSCOMNTOOLS}vsvars32.sh"
