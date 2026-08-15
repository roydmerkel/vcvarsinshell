#!/bin/bash
dollar0=$(realpath "${BASH_SOURCE[0]}")
vs=$(realpath "$(dirname "${dollar0}")/../../../")

export VSINSTALLDIR="${vs}/Common7/IDE"
export VCINSTALLDIR="${vs}"
export FrameworkDir="${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework"
export FrameworkVersion="v1.1.4322"
export FrameworkSDKDir="${vs}/SDK/v1.1"
# Root of Visual Studio common files.

if [ "${VSINSTALLDIR}" == "" ]; then
    echo "VSINSTALLDIR variable is not set. "
    echo ""
    echo "SYNTAX: $dollar0"
else
    if [ "${VCINSTALLDIR}" == "" ]; then
        export VCINSTALLDIR="${VSINSTALLDIR}"
    fi

    #
    # Root of Visual Studio ide installed files.
    #
    export DevEnvDir="${VSINSTALLDIR}"

    #
    # Root of Visual C++ installed files.
    #
    export MSVCDir="${VCINSTALLDIR}/VC7"

    #
    echo "Setting environment for using Microsoft Visual Studio .NET 2003 tools."
    echo "(If you have another version of Visual Studio or Visual C++ installed and wish"
    echo "to use its tools from the command line, run vcvars32.bat for that version.)"
    #

    # ${VCINSTALLDIR}/Common7/Tools dir is added only for real setup.

    if [ "${PATH:-}" != "" ]; then
        export PATH="${DevEnvDir}:${MSVCDir}/BIN:${VCINSTALLDIR}/Common7/Tools:${VCINSTALLDIR}/Common7/Tools/bin/prerelease:${VCINSTALLDIR}/Common7/Tools/bin:${FrameworkSDKDir}/bin:${FrameworkDir}/${FrameworkVersion}:${PATH}"
    else
        export PATH="${DevEnvDir}:${MSVCDir}/BIN:${VCINSTALLDIR}/Common7/Tools:${VCINSTALLDIR}/Common7/Tools/bin/prerelease:${VCINSTALLDIR}/Common7/Tools/bin:${FrameworkSDKDir}/bin:${FrameworkDir}/${FrameworkVersion}"
    fi
    if [ "${INCLUDE:-}" != "" ]; then
        export INCLUDE="${MSVCDir}/ATLMFC/INCLUDE:${MSVCDir}/INCLUDE:${MSVCDir}/PlatformSDK/include/prerelease:${MSVCDir}/PlatformSDK/include:${FrameworkSDKDir}/include:${INCLUDE}"
    else
        export INCLUDE="${MSVCDir}/ATLMFC/INCLUDE:${MSVCDir}/INCLUDE:${MSVCDir}/PlatformSDK/include/prerelease:${MSVCDir}/PlatformSDK/include:${FrameworkSDKDir}/include"
    fi
    if [ "${LIB:-}" != "" ]; then
        export LIB="${MSVCDir}/ATLMFC/LIB:${MSVCDir}/LIB:${MSVCDir}/PlatformSDK/lib/prerelease:${MSVCDir}/PlatformSDK/lib:${FrameworkSDKDir}/lib:${LIB}"
    else
        export LIB="${MSVCDir}/ATLMFC/LIB:${MSVCDir}/LIB:${MSVCDir}/PlatformSDK/lib/prerelease:${MSVCDir}/PlatformSDK/lib:${FrameworkSDKDir}/lib"
    fi
fi
