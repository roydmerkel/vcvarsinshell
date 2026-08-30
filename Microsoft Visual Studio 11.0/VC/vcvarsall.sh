#!/bin/bash

dollar0="$(realpath "${BASH_SOURCE[0]}")"

SetVisualStudioVersion() {
    export VisualStudioVersion=11.0
}

missing() {
    echo "The specified configuration type is missing.  The tools for the"
    echo "configuration might not be installed."
}

usage() {
    echo "Error in script usage. The correct usage is:"
    echo "    ${basepath "${dollar0}"} [option]"
    echo "where [option] is: x86 | amd64 | arm | x86_amd64 | x86_arm"
    echo ""
    echo "For example:"
    echo "    ${basepath "${dollar0}"} x86_amd64"
}

x86() {
    if [ ! -e "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/bin/vcvars32.sh" ]; then 
        missing
    else
        . "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/bin/vcvars32.sh"
        SetVisualStudioVersion
    fi
}

amd64() {
    if [ ! -e "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/bin/amd64/vcvars64.sh" ]; then 
        missing
    else
        . "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/bin/amd64/vcvars64.sh"
        SetVisualStudioVersion
    fi
}

arm() {
    if [ ! -e "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/bin/arm/vcvarsarm.sh" ]; then 
        missing
    else
        . "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/bin/arm/vcvarsarm.sh"
        SetVisualStudioVersion
    fi
}

x86_amd64() {
    if [ ! -e "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/bin/x86_amd64/vcvarsx86_amd64.sh" ]; then 
        missing
    else
        . "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/bin/x86_amd64/vcvarsx86_amd64.sh"
        SetVisualStudioVersion
    fi
}

x86_arm() {
    if [ ! -e "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/bin/x86_arm/vcvarsx86_arm.sh" ]; then 
        missing
    else
        . "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/bin/x86_arm/vcvarsx86_arm.sh"
        SetVisualStudioVersion
    fi
}

original_state="$(shopt -p nocasematch; true)"
shopt -s nocasematch

if [ "${1:-}" == "" ]; then 
    x86
elif [ "${2:-}" != "" ]; then 
    usage
elif [ "${1:-}" == "x86"  ]; then 
    x86
elif [ "${1:-}" == "amd64"  ]; then 
    amd64
elif [ "${1:-}" == "x64"  ]; then 
    amd64
elif [ "${1:-}" == "arm"  ]; then 
    arm
elif [ "${1:-}" == "x86_arm"  ]; then 
    x86_arm
elif [ "${1:-}" == "x86_amd64"  ]; then 
    x86_amd64
else
    usage
fi

eval "$original_state"
