#!/bin/bash

dollar0=$(realpath "${BASH_SOURCE[0]}")
vc=$(realpath "$(dirname "${dollar0}")/../../")

#
# Root of Visual Developer Studio Common files.
export VSCommonDir="${vc}/Common"

#
# Root of Visual Developer Studio installed files.
#
export MSDevDir="${vc}/Common/msdev98"

#
# Root of Visual C++ installed files.
#
export MSVCDir="${vc}/VC98"

#
# VcOsDir is used to help create either a Windows 95 or Windows NT specific path.
#
export VcOsDir="WIN95"
if [ "${OS:-}" == "Windows_NT" ]; then 
    export VcOsDir="WINNT"
fi

#
echo Setting environment for using Microsoft Visual C++ tools.
#

if [ "${OS:-}" == "Windows_NT" ]; then 
    export PATH="${MSDevDir}/BIN:${MSVCDir}/BIN:${VSCommonDir}/TOOLS/${VcOsDir}:${VSCommonDir}/TOOLS:${PATH}"
elif [ "${OS:-}" == "" ]; then 
    export PATH="${MSDevDir}/BIN:${MSVCDir}/BIN:${VSCommonDir}/TOOLS/${VcOsDir}:${VSCommonDir}/TOOLS:${windir:-/mnt/c/WINDOWS}/SYSTEM:${PATH}"
fi
if [ "${INCLUDE:-}" == "" ]; then
    export INCLUDE="${MSVCDir}/ATL/INCLUDE:${MSVCDir}/INCLUDE:${MSVCDir}/MFC/INCLUDE"
else
    export INCLUDE="${MSVCDir}/ATL/INCLUDE:${MSVCDir}/INCLUDE:${MSVCDir}/MFC/INCLUDE:${INCLUDE}"
fi
if [ "${LIB:-}" == "" ]; then
    export LIB="${MSVCDir}/LIB:${MSVCDir}/MFC/LIB"
else
    export LIB="${MSVCDir}/LIB:${MSVCDir}/MFC/LIB:${LIB}"
fi

export VcOsDir=
export VSCommonDir=

