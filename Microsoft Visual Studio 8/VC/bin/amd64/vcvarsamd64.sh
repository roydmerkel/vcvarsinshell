#!/bin/bash

dollar0=$(realpath "${BASH_SOURCE[0]}")
vc=$(realpath "$(dirname "${dollar0}")/../../../")

export VSINSTALLDIR="${vc}"
export VCINSTALLDIR="${vc}/VC"
export FrameworkDir="${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework64"
export FrameworkVersion="v2.0.50727"
export FrameworkSDKDir="${vc}/SDK/v2.0 64bit"
if [ "${VSINSTALLDIR:-}" == "" ]; then 
    echo "ERROR: VSINSTALLDIR variable is not set. "
elif [ "${VCINSTALLDIR:-}" == "" ]; then 
    echo "ERROR: VCINSTALLDIR variable is not set. "
else

    echo "Setting environment for using Microsoft Visual Studio 2005 x64 tools."

    if [ "${PATH:-}" != "" ]; then
        export PATH="${VCINSTALLDIR}/BIN/amd64:${VCINSTALLDIR}/PlatformSDK/bin/win64/amd64:${VCINSTALLDIR}/PlatformSDK/bin:${FrameworkDir}/${FrameworkVersion}:${VCINSTALLDIR}/VCPackages:${VSINSTALLDIR}/Common7/IDE:${VSINSTALLDIR}/Common7/Tools:${VSINSTALLDIR}/Common7/Tools/bin:${VSINSTALLDIR}/SDK/v2.0/bin:${PATH}"
    else
        export PATH="${VCINSTALLDIR}/BIN/amd64:${VCINSTALLDIR}/PlatformSDK/bin/win64/amd64:${VCINSTALLDIR}/PlatformSDK/bin:${FrameworkDir}/${FrameworkVersion}:${VCINSTALLDIR}/VCPackages:${VSINSTALLDIR}/Common7/IDE:${VSINSTALLDIR}/Common7/Tools:${VSINSTALLDIR}/Common7/Tools/bin:${VSINSTALLDIR}/SDK/v2.0/bin"
    fi
    if [ "${INCLUDE:-}" != "" ]; then
        export INCLUDE="${VCINSTALLDIR}/ATLMFC/INCLUDE:${VCINSTALLDIR}/INCLUDE:${VCINSTALLDIR}/PlatformSDK/include:${VSINSTALLDIR}/SDK/v2.0/include:${INCLUDE}"
    else
        export INCLUDE="${VCINSTALLDIR}/ATLMFC/INCLUDE:${VCINSTALLDIR}/INCLUDE:${VCINSTALLDIR}/PlatformSDK/include:${VSINSTALLDIR}/SDK/v2.0/include"
    fi
    if [ "${LIB:-}" != "" ]; then
        export LIB="${VCINSTALLDIR}/ATLMFC/LIB/amd64:${VCINSTALLDIR}/LIB/amd64:${VCINSTALLDIR}/PlatformSDK/lib/amd64:${VSINSTALLDIR}/SDK/v2.0/LIB/AMD64:${LIB}"
    else
        export LIB="${VCINSTALLDIR}/ATLMFC/LIB/amd64:${VCINSTALLDIR}/LIB/amd64:${VCINSTALLDIR}/PlatformSDK/lib/amd64:${VSINSTALLDIR}/SDK/v2.0/LIB/AMD64"
    fi
    if [ "${LIBPATH:-}" != "" ]; then
        export LIBPATH="${VCINSTALLDIR}/ATLMFC/LIB/amd64:${LIBPATH}"
    else
        export LIBPATH="${VCINSTALLDIR}/ATLMFC/LIB/amd64"
    fi
fi
