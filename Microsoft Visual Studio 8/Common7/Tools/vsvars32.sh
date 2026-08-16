#!/bin/bash

dollar0=$(realpath "${BASH_SOURCE[0]}")
vc=$(realpath "$(dirname "${dollar0}")/../../")

export VSINSTALLDIR="${vc}"
export VCINSTALLDIR="${vc}/VC"
export FrameworkDir="${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework"
export FrameworkVersion=v2.0.50727
export FrameworkSDKDir="${vc}/SDK/v2.0"
if [ "${VSINSTALLDIR}" == "" ]; then
    echo "ERROR: VSINSTALLDIR variable is not set. "
elif [ "${VCINSTALLDIR}" == "" ]; then
    echo "ERROR: VCINSTALLDIR variable is not set. "
else
    echo "Setting environment for using Microsoft Visual Studio 2005 x86 tools."

    #
    # Root of Visual Studio IDE installed files.
    #
    export DevEnvDir="${vc}/Common7/IDE"

    if [ "${PATH:-}" != "" ]; then
        export PATH="${vc}/Common7/IDE:${vc}/VC/BIN:${vc}/Common7/Tools:${vc}/Common7/Tools/bin:${vc}/VC/PlatformSDK/bin:${vc}/SDK/v2.0/bin:${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework/v2.0.50727:${vc}/VC/VCPackages:${PATH}"
    else
        export PATH="${vc}/Common7/IDE:${vc}/VC/BIN:${vc}/Common7/Tools:${vc}/Common7/Tools/bin:${vc}/VC/PlatformSDK/bin:${vc}/SDK/v2.0/bin:${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework/v2.0.50727:${vc}/VC/VCPackages"
    fi
    if [ "${INCLUDE:-}" != "" ]; then
        export INCLUDE="${vc}/VC/ATLMFC/INCLUDE:${vc}/VC/INCLUDE:${vc}/VC/PlatformSDK/include:${vc}/SDK/v2.0/include:${INCLUDE}"
    else
        export INCLUDE="${vc}/VC/ATLMFC/INCLUDE:${vc}/VC/INCLUDE:${vc}/VC/PlatformSDK/include:${vc}/SDK/v2.0/include"
    fi
    if [ "${LIB:-}" != "" ]; then
        export LIB="${vc}/VC/ATLMFC/LIB:${vc}/VC/LIB:${vc}/VC/PlatformSDK/lib:${vc}/SDK/v2.0/lib:${LIB}"
    else
        export LIB="${vc}/VC/ATLMFC/LIB:${vc}/VC/LIB:${vc}/VC/PlatformSDK/lib:${vc}/SDK/v2.0/lib"
    fi
    export LIBPATH="${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework/v2.0.50727:${vc}/VC/ATLMFC/LIB"
fi
