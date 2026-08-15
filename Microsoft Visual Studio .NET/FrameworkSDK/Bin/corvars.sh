#!/bin/bash
dollar0=$(realpath "${BASH_SOURCE[0]}")
vc=$(realpath "$(dirname "${dollar0}")/../../")

if [ "${PATH:-}" != "" ]; then
    export PATH="${vc}/FrameworkSDK/Bin/:${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework/v1.0.3705/:${vc}/Vc7/bin/:${vc}/Common7/IDE/:${windir:-/mnt/c/WINDOWS}/SysWOW64/:${PATH}"
else
    export PATH="${vc}/FrameworkSDK/Bin/:${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework/v1.0.3705/:${vc}/Vc7/bin/:${vc}/Common7/IDE/:${windir:-/mnt/c/WINDOWS}/SysWOW64/"
fi
if [ "${LIB:-}" != "" ]; then
    export LIB="${vc}/Vc7/lib/:${vc}/FrameworkSDK/Lib/:${LIB}"
else
    export LIB="${vc}/Vc7/lib/:${vc}/FrameworkSDK/Lib/"
fi
if [ "${INCLUDE:-}" != "" ]; then
    export INCLUDE="${vc}/Vc7/include/:${vc}/FrameworkSDK/include/:${INCLUDE}"
else
    export INCLUDE="${vc}/Vc7/include/:${vc}/FrameworkSDK/include/"
fi
