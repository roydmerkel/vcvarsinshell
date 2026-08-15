#!/bin/bash
dollar0=$(realpath "${BASH_SOURCE[0]}")
vc=$(realpath "$(dirname "${dollar0}")/../../")

export VSINSTALLDIR="${vc}/Common7/IDE"
export VCINSTALLDIR="${vc}"
export FrameworkDir="${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework"
export FrameworkVersion="v1.0.3705"
export FrameworkSDKDir="${vc}/FrameworkSDK"
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
    echo "Setting environment for using Microsoft Visual Studio .NET tools."
    echo "(If you also have Visual C++ 6.0 installed and wish to use its tools"
    echo "from the command line, run vcvars32.bat for Visual C++ 6.0.)"
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
