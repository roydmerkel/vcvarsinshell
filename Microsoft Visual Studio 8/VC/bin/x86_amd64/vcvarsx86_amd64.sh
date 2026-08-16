#!/bin/bash

dollar0=$(realpath "${BASH_SOURCE[0]}")
vc=$(realpath "$(dirname "${dollar0}")/../../../")

export VSINSTALLDIR="${vc}"
export VCINSTALLDIR="${vc}/VC"
export FrameworkDir="${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework"
export FrameworkVersion="v2.0.50727"
export FrameworkSDKDir="${vc}/SDK/v2.0"
if [ "${VSINSTALLDIR:-}" == "" ]; then
    echo "ERROR: VSINSTALLDIR variable is not set. "
    @goto end
elif [ "${VCINSTALLDIR:-}" == "" ]; then 
    echo "ERROR: VCINSTALLDIR variable is not set. "
    @goto end
else

    echo "Setting environment for using Microsoft Visual Studio 2005 x64 cross tools."

    #
    # Root of Visual Studio IDE installed files.
    #
    export DevEnvDir="${vc}/Common7/IDE"

    if [ "${PATH:-}" != "" ]; then
        export PATH="${vc}/Common7/IDE:${vc}/VC/BIN/x86_amd64:${vc}/VC/BIN:${vc}/Common7/Tools:${vc}/Common7/Tools/bin:${vc}/VC/PlatformSDK/bin:${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework/v2.0.50727:${vc}/VC/VCPackages:${vc}/SDK/v2.0/bin:${PATH}"
    else
        export PATH="${vc}/Common7/IDE:${vc}/VC/BIN/x86_amd64:${vc}/VC/BIN:${vc}/Common7/Tools:${vc}/Common7/Tools/bin:${vc}/VC/PlatformSDK/bin:${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework/v2.0.50727:${vc}/VC/VCPackages:${vc}/SDK/v2.0/bin"
    fi
    if [ "${INCLUDE:-}" != "" ]; then
        export INCLUDE="${vc}/VC/ATLMFC/INCLUDE:${vc}/VC/INCLUDE:${vc}/VC/PlatformSDK/include:${vc}/SDK/v2.0/include:${INCLUDE}"
    else
        export INCLUDE="${vc}/VC/ATLMFC/INCLUDE:${vc}/VC/INCLUDE:${vc}/VC/PlatformSDK/include:${vc}/SDK/v2.0/include"
    fi
    if [ "${LIB:-}" != "" ]; then
        export LIB="${vc}/VC/ATLMFC/LIB/amd64:${vc}/VC/LIB/amd64:${vc}/VC/PlatformSDK/lib/amd64:${vc}/SDK/v2.0/LIB/AMD64:${LIB}"
    else
        export LIB="${vc}/VC/ATLMFC/LIB/amd64:${vc}/VC/LIB/amd64:${vc}/VC/PlatformSDK/lib/amd64:${vc}/SDK/v2.0/LIB/AMD64"
    fi

    if [ "${LIBPATH:-}" != "" ]; then
        export LIBPATH="${vc}/VC/ATLMFC/LIB/amd64:${LIBPATH}"
    else
        export LIBPATH="${vc}/VC/ATLMFC/LIB/amd64"
    fi
fi
