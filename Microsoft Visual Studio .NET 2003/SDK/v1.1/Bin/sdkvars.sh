#!/bin/bash
dollar0=$(realpath "${BASH_SOURCE[0]}")
vs=$(realpath "$(dirname "${dollar0}")/../../../")

if [ "${PATH:-}" != "" ]; then
    export PATH="${vs}/SDK/v1.1/Bin/:${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework/v1.1.4322/:${vs}/Vc7/bin/:${vs}/Common7/IDE/:${PATH}"
else
    export PATH="${vs}/SDK/v1.1/Bin/:${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework/v1.1.4322/:${vs}/Vc7/bin/:${vs}/Common7/IDE/"
fi
if [ "${LIB:-}" != "" ]; then
    export LIB="${vs}/Vc7/lib/:${vs}/SDK/v1.1/Lib/:${LIB}"
else
    export LIB="${vs}/Vc7/lib/:${vs}/SDK/v1.1/Lib/"
fi
if [ "${INCLUDE:-}" != "" ]; then
    export INCLUDE="${vs}/Vc7/include/:${vs}/SDK/v1.1/include/:${INCLUDE}"
else
    export INCLUDE="${vs}/Vc7/include/:${vs}/SDK/v1.1/include/"
fi
export NetSamplePath="${vs}/SDK/v1.1/"
