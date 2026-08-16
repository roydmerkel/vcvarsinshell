#!/bin/bash

dollar0=$(realpath "${BASH_SOURCE[0]}")
vc=$(realpath "$(dirname "${dollar0}")/../../../")

if [ "${PATH:-}" != "" ]; then
    export PATH="${vc}/SDK/v2.0/Bin:${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework/v2.0.50727:${vc}/VC/bin:${vc}/Common7/IDE:${vc}/VC/vcpackages:${PATH}"
else
    export PATH="${vc}/SDK/v2.0/Bin:${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework/v2.0.50727:${vc}/VC/bin:${vc}/Common7/IDE:${vc}/VC/vcpackages"
fi
if [ "${LIB:-}" != "" ]; then
    export LIB="${vc}/VC/lib:${vc}/SDK/v2.0/Lib:${LIB}"
else
    export LIB="${vc}/VC/lib:${vc}/SDK/v2.0/Lib"
fi
if [ "${INCLUDE:-}" != "" ]; then
    export INCLUDE="${vc}/VC/include:${vc}/SDK/v2.0/include:${INCLUDE}"
else
    export INCLUDE="${vc}/VC/include:${vc}/SDK/v2.0/include"
fi
export NetSamplePath="${vc}/SDK/v2.0"
export VCBUILD_DEFAULT_CFG="Debug|Win32"
export VCBUILD_DEFAULT_OPTIONS="/useenv"
echo "Setting environment to use Microsoft .NET Framework v2.0 SDK tools."
echo "For a list of SDK tools, see the 'StartTools.htm' file in the bin folder."
