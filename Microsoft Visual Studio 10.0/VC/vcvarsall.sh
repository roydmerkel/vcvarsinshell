#!/bin/bash

dollar0="$(realpath "${BASH_SOURCE[0]}")"

missing() {
    echo "The specified configuration type is missing.  The tools for the"
    echo "configuration might not be installed."
}

x86() {
    if [ ! -e "$(dirname "${dollar0}")/bin/vcvars32.sh" ]; then 
        missing
    else
        . "$(dirname "${dollar0}")/bin/vcvars32.sh"
    fi
}

amd64() {
    if [ ! -e "$(dirname "${dollar0}")/bin/amd64/vcvars64.sh" ]; then
        missing
    else
        . "$(dirname "${dollar0}")/bin/amd64/vcvars64.sh"
    fi
}

ia64() {
    if [ ! -e "$(dirname "${dollar0}")/bin/ia64/vcvars64.sh" ]; then
        missing
    else
        . "$(dirname "${dollar0}")/bin/ia64/vcvars64.sh"
    fi
}

x86_amd64() {
    if [ ! -e "$(dirname "${dollar0}")/bin/x86_amd64/vcvarsx86_amd64.sh" ]; then 
        missing
    else
        . "$(dirname "${dollar0}")/bin/x86_amd64/vcvarsx86_amd64.sh"
    fi
}

x86_ia64() {
    if [ ! -e "$(dirname "${dollar0}")/bin/x86_ia64/vcvarsx86_ia64.sh" ]; then 
        missing
    else
        . "$(dirname "${dollar0}")/bin/x86_ia64/vcvarsx86_ia64.sh"
    fi
}

usage() {
    echo "Error in script usage. The correct usage is:"
    echo "    ${dollar0} [option]"
    echo "where [option] is: x86 | ia64 | amd64 | x86_amd64 | x86_ia64"
    echo ""
    echo "For example:"
    echo "    ${dollar0} x86_ia64"
}

original_state="$(shopt -p nocasematch; true)"
shopt -s nocasematch

if [ "${1:-}" == "" ]; then 
    x86
elif [ "${2:-}" != "" ]; then 
    usage
elif [ "${1:-}" == "x86" ]; then 
    x86
elif [ "${1:-}" == "amd64" ]; then 
    amd64
elif [ "${1:-}" == "x64" ]; then 
    amd64
elif [ "${1:-}" == "ia64" ]; then 
    ia64
elif [ "${1:-}" == "x86_amd64" ]; then 
    x86_amd64
elif [ "${1:-}" == "x86_ia64" ]; then 
    x86_ia64
else 
    usage
fi

eval "$original_state"