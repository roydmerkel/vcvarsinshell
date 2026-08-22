#!/bin/bash
dollar0=$(realpath "${BASH_SOURCE[0]}")

vc=$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../../../")

which wslpath 2>/dev/null
if [ $? -eq "0" ]; then
	winpath() { 
		"$(which wslpath)" "$@"
	}
	winpathdefined=1
else
	which winepath 2>/dev/null
	if [ $? -eq "0" ]; then
		winpath() { 
			"$(which winepath)" "$@"
		}
		winpathdefined=1
	else
		which cygpath 2>/dev/null
		if [ $? -eq "0" ]; then
			winpath() { 
				"$(which cygpath)" "$@"
			}
			winpathdefined=1
		else
			winpath() {
				if [ "${1:-}" != "" -a "${2:-}" != "" ]; then
					echo "${2:-}"
				elif [ "${1:-}" != "" ]; then
					echo "${1:-}"
				fi
			}
			winpathdefined=0
		fi
	fi
fi

which reg 2>/dev/null 1>/dev/null
if [ $? -eq "0" ]; then
	req=$(which reg)
else
	if [ "${winpathdefined:-0}" -ne "0" ]; then
		reg=$(winpath -u "C:\\Windows\\System32\\reg.exe")
	elif [ -e "/mnt/c/Windows/System32/reg.exe" ]; then
		reg="/mnt/c/Windows/System32/reg.exe"
	elif [ -e "/c/Windows/System32/reg.exe" ]; then 
		reg="/c/Windows/System32/reg.exe"
	elif [ -e "c:/Windows/System32/reg.exe" ]; then
		reg="c:/Windows/System32/reg.exe"
	fi
fi

GetWindowsSdkDirHelper() {
	local regqueryRes=$("${reg}" query "${1}\SOFTWARE\Microsoft\Microsoft SDKs\Windows" /v "CurrentInstallFolder" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "CurrentInstallFolder" ]; then
			export WindowsSdkDir="$(winpath -u "${k}")"
			fi
		done <<< "$regqueryRes"
	fi

	if [ "${WindowsSdkDir:-}" == "" ]; then 
		return 1
	fi
	return 0
}

GetWindowsSdkDir() {
	if ! GetWindowsSdkDirHelper HKLM; then
		if ! GetWindowsSdkDirHelper HKCU; then
			echo "WindowsSdkDir not found"
		fi
	fi
	return 0
}

export VSINSTALLDIR="${vc}"
export VCINSTALLDIR="${vc}/VC"
export FrameworkDir="${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework"
export FrameworkVersion="v2.0.50727"
export Framework35Version="v3.5"
if [ "${VSINSTALLDIR}" == "" ]; then 
	echo "ERROR: VSINSTALLDIR variable is not set. "
elif [ "${VCINSTALLDIR}" == "" ]; then
	echo "ERROR: VCINSTALLDIR variable is not set. "
else
	echo "Setting environment for using Microsoft Visual Studio 2008 Beta2 x64 cross tools."

	GetWindowsSdkDir

	if [ "${WindowsSdkDir:-}" != "" ]; then
		export PATH="${WindowsSdkDir}bin:${PATH}"
		export INCLUDE="${WindowsSdkDir}include:${INCLUDE}"
		export LIB="${WindowsSdkDir}lib/x64:${LIB}"
	fi


	#
	# Root of Visual Studio IDE installed files.
	#
	export DevEnvDir="${vc}/Common7/IDE"

	export PATH="${vc}/Common7/IDE:${vc}/VC/BIN/x86_amd64:${vc}/VC/BIN:${vc}/Common7/Tools:${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework/v3.5:${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework/v2.0.50727:${vc}/VC/VCPackages:${PATH}"
	export INCLUDE="${vc}/VC/ATLMFC/INCLUDE:${vc}/VC/INCLUDE:${INCLUDE}"
	export LIB="${vc}/VC/ATLMFC/LIB/amd64:${vc}/VC/LIB/amd64:${LIB}"

	export LIBPATH="${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework64/v3.5:${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework64/v2.0.50727:${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework/v3.5:${windir:-/mnt/c/WINDOWS}/Microsoft.NET/Framework/v2.0.50727:${vc}/VC/ATLMFC/LIB/amd64:${vc}/VC/LIB/amd64:${LIBPATH}"

fi
