#!/bin/bash

dollar0=$(realpath "${BASH_SOURCE[0]}")
vc=$(realpath "$(dirname "${dollar0}")/../../")

#
# Root of Visual Developer Studio installed files.
#
export MSDevDir="${vc}/SharedIDE"

#
# Root of Visual C++ installed files.
#
export MSVCDir="${vc}/VC"

#
# Root of Visual C++ files on cd-rom.
# Remove "set vcsource=" if you don't want include cdrom in Visual C++ environment.
#
export vcsource="/mnt/d/DEVSTUDIO"
#export vcsource=""

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
if [ "${vcsource:-}" != "" ]; then
    #
    # Include cdrom files in environment.
    #
    if [ "${OS:-}" == "Windows_NT" ]; then 
        export PATH="${PATH}:${vcsource}/VC/BIN:${vcsource}/VC/BIN/${VcOsDir}"
    elif [ "${OS:-}" == "" ]; then
        export PATH="${PATH}:${vcsource}/VC/BIN:${vcsource}/VC/BIN/${VcOsDir}"
    fi
    if [ "${INCLUDE:-}" != "" ]; then
        export INCLUDE="${INCLUDE}:${vcsource}/VC/INCLUDE:${vcsource}/VC/MFC/INCLUDE:${vcsource}/VC/ATL/INCLUDE"
    else
        export INCLUDE="${vcsource}/VC/INCLUDE:${vcsource}/VC/MFC/INCLUDE:${vcsource}/VC/ATL/INCLUDE"
    fi
    if [ "${LIB:-}" != "" ]; then
        export LIB="${LIB}:${vcsource}/VC/LIB:${vcsource}/VC/MFC/LIB"
    else
        export LIB="${vcsource}/VC/LIB:${vcsource}/VC/MFC/LIB"
    fi
    export vcsource=

fi

if [ "${OS:-}" == "Windows_NT" ]; then 
    export PATH="${MSDevDir}/BIN:${MSVCDir}/BIN:${MSVCDir}/BIN/${VcOsDir}:${PATH}"
elif [ "${OS:-}" == "" ]; then 
    export PATH="${MSDevDir}/BIN:${MSVCDir}/BIN:${MSVCDir}/BIN/${VcOsDir}:${PATH}"
fi
if [ "${INCLUDE:-}" != "" ]; then
    export INCLUDE="${MSVCDir}/INCLUDE:${MSVCDir}/MFC/INCLUDE:${MSVCDir}/ATL/INCLUDE:${INCLUDE}"
else
    export INCLUDE="${MSVCDir}/INCLUDE:${MSVCDir}/MFC/INCLUDE:${MSVCDir}/ATL/INCLUDE"
fi
if [ "${LIB:-}" != "" ]; then
    export LIB="${MSVCDir}/LIB:${MSVCDir}/MFC/LIB:${LIB}"
else
    export LIB="${MSVCDir}/LIB:${MSVCDir}/MFC/LIB"
fi

set VcOsDir=
