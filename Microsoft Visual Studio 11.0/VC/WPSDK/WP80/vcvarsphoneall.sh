#!/bin/bash

REALPATH="$(realpath "${BASH_SOURCE[0]}")"
dollar0="$(basename "${REALPATH}")"

missing() {
    echo "The specified configuration type is missing.  The"
    echo "tools for the configuration might not be installed."
}

SetVisualStudioVersion() {
    export VisualStudioVersion="11.0"
    export VCPhoneToolsRoot=""
}

x86() {
    if [ ! -e "$(dirname "${REALPATH}")/bin/vcvarsphonex86.sh" ]; then 
        missing
    else
        . "$(dirname "${REALPATH}")/bin/vcvarsphonex86.sh"
        SetVisualStudioVersion
    fi
}

x86_arm() {
    if [ ! -e "$(dirname "${REALPATH}")/bin/x86_arm/vcvarsphonex86_arm.sh" ]; then 
        missing
    else
        . "$(dirname "${REALPATH}")/bin/x86_arm/vcvarsphonex86_arm.sh"
        SetVisualStudioVersion
    fi
}

usage() {
    echo "Error in script usage. The correct usage is:"
    echo "    ${dollar0} [option]"
    echo "where [option] is: x86 | x86_arm"
    echo ""
    echo "For example:"
    echo "    ${dollar0} x86"
}

if [ "${1:-}" == "" ]; then 
    x86
elif [ "${2:-}" != "" ]; then 
    usage
else

    export VCPhoneToolsRoot="$(dirname "${REALPATH}")/"

    original_state="$(shopt -p nocasematch; true)"
    shopt -s nocasematch

    if [ "${1:-}" == "x86" ]; then 
        x86
    elif [ "${1:-}" == "x86_arm" ]; then 
        x86_arm
    else
        usage
    fi

    eval "$original_state"
fi
