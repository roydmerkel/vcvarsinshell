#!/bin/bash

if [ "${VS71COMNTOOLS:-}" == "" ]; then
    dollar0=$(realpath "${BASH_SOURCE[0]}")
    vc=$(realpath "$(dirname "${dollar0}")/../../")
    export VS71COMNTOOLS="${vc}/Common7/Tools/"
fi

. "${VS71COMNTOOLS}vsvars32.sh"
