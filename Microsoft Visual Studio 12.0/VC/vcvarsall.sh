#!/bin/bash

REALPATH="$(realpath "${BASH_SOURCE[0]}")"
dollar0="$(basename "$REALPATH")"

usage() {
    echo "Error in script usage. The correct usage is:"
    echo "    ${dollar0} [option]"
    echo "where [option] is: x86 | amd64 | arm | x86_amd64 | x86_arm | amd64_x86 | amd64_arm"
    echo ""
    echo "For example:"
    echo "    ${dollar0} x86_amd64"
}

missing() {
    echo "The specified configuration type is missing.  The tools for the"
    echo "configuration might not be installed."
}

SetVisualStudioVersion() {
    export VisualStudioVersion="12.0"
}

x86() {
    if [ ! -e "$(dirname "${REALPATH}")/bin/vcvars32.sh" ]; then 
        missing
    else
        . "$(dirname "${REALPATH}")/bin/vcvars32.sh"
        SetVisualStudioVersion
    fi
}

amd64() {
    if [ ! -e "$(dirname "${REALPATH}")/bin/amd64/vcvars64.sh" ]; then 
        missing
    else
        . "$(dirname "${REALPATH}")/bin/amd64/vcvars64.sh"
        SetVisualStudioVersion
    fi
}

arm() {
    if [ ! -e "$(dirname "${REALPATH}")/bin/arm/vcvarsarm.sh" ]; then 
        missing
    else
        . "$(dirname "${REALPATH}")/bin/arm/vcvarsarm.sh"
        SetVisualStudioVersion
    fi
}

x86_amd64() {
    if [ ! -e "$(dirname "${REALPATH}")/bin/x86_amd64/vcvarsx86_amd64.sh" ]; then 
        missing
    else
        . "$(dirname "${REALPATH}")/bin/x86_amd64/vcvarsx86_amd64.sh"
        SetVisualStudioVersion
    fi
}

x86_arm() {
    if [ ! -e "$(dirname "${REALPATH}")/bin/x86_arm/vcvarsx86_arm.sh" ]; then 
        missing
    else
        . "$(dirname "${REALPATH}")/bin/x86_arm/vcvarsx86_arm.sh"
        SetVisualStudioVersion
    fi
}

amd64_x86() {
    if [ ! -e "$(dirname "${REALPATH}")/bin/amd64_x86/vcvarsamd64_x86.sh" ]; then 
        missing
    else
        . "$(dirname "${REALPATH}")/bin/amd64_x86/vcvarsamd64_x86.sh"
        SetVisualStudioVersion
    fi
}

amd64_arm() {
    if [ ! -e "$(dirname "${REALPATH}")/bin/amd64_arm/vcvarsamd64_arm.sh" ]; then 
        missing
    else
        . "$(dirname "${REALPATH}")/bin/amd64_arm/vcvarsamd64_arm.sh"
        SetVisualStudioVersion
    fi
}

if [ "${1:-}" == "" ]; then 
    x86
elif [ "${2:-}" != "" ]; then 
    usage
else
    original_state="$(shopt -p nocasematch; true)"
    shopt -s nocasematch

    if [ "${1:-}" == "x86" ]; then
        x86
    elif [ "${1:-}" == "amd64" ]; then
        amd64
    elif [ "${1:-}" == "x64" ]; then
        amd64
    elif [ "${1:-}" == "arm" ]; then
        arm
    elif [ "${1:-}" == "x86_arm" ]; then
        x86_arm
    elif [ "${1:-}" == "x86_amd64" ]; then
        x86_amd64
    elif [ "${1:-}" == "amd64_x86" ]; then
        amd64_x86
    elif [ "${1:-}" == "amd64_arm" ]; then
        amd64_arm
    else
        usage
    fi

    eval "$original_state"
fi
