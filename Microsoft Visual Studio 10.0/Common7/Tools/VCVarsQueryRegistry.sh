#!/bin/bash

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

# -----------------------------------------------------------------------

GetFrameworkVer64Helper32() {
	local regqueryRes=$("${reg}" query "${1}\\SOFTWARE\\Microsoft\\VisualStudio\\SxS\\VC7" /v "FrameworkVer64" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "FrameworkVer64" ]; then
				export FrameworkVersion64="${k}"
			fi
		done <<< "$regqueryRes"
	fi
	if [ "${FrameworkVersion64:-}" == "" ]; then 
		return 1
	fi
	return 0
}

GetFrameworkVer64Helper64() {
	local regqueryRes=$("${reg}" query "${1}\\SOFTWARE\\Wow6432Node\\Microsoft\\VisualStudio\\SxS\\VC7" /v "FrameworkVer64" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "FrameworkVer64" ]; then
				export FrameworkVersion64="${k}"
			fi
		done <<< "$regqueryRes"
	fi
	if [ "${FrameworkVersion64:-}" == "" ]; then 
		return 1
	fi
	return 0
}

GetFrameworkVer64() {
	export FrameworkVersion64=
	if ! GetFrameworkVer64Helper32 HKLM; then
		if ! GetFrameworkVer64Helper32 HKCU; then
			if ! GetFrameworkVer64Helper64  HKLM; then
				GetFrameworkVer64Helper64  HKCU
			fi
		fi
	fi
	return 0
}

# -----------------------------------------------------------------------

GetFrameworkDir64Helper32() {
	local regqueryRes=$("${reg}" query "${1}\\SOFTWARE\\Microsoft\\VisualStudio\\SxS\\VC7" /v "FrameworkDir64" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "FrameworkDir64" ]; then
				export FrameworkDIR64="$(winpath -u "${k}")"
			fi
		done <<< "$regqueryRes"
	fi
	if [ "${FrameworkDIR64:-}" == "" ]; then 
		return 1
	fi
	return 0
}

GetFrameworkDir64Helper64() {
	local regqueryRes=$("${reg}" query "${1}\\SOFTWARE\\Wow6432Node\\Microsoft\\VisualStudio\\SxS\\VC7" /v "FrameworkDir64" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "FrameworkDir64" ]; then
				export FrameworkDIR64="$(winpath -u "${k}")"
			fi
		done <<< "$regqueryRes"
	fi
	if [ "${FrameworkDIR64:-}" == "" ]; then 
		return 1
	fi
	return 0
}

GetFrameworkDir64() {
	export FrameworkDIR64=
	if ! GetFrameworkDir64Helper32 HKLM; then
		if ! GetFrameworkDir64Helper32 HKCU; then
			if ! GetFrameworkDir64Helper64  HKLM; then
				GetFrameworkDir64Helper64  HKCU
			fi
		fi
	fi
	return 0
}

# -----------------------------------------------------------------------
GetFrameworkVer32Helper32() {
	local regqueryRes=$("${reg}" query "${1}\\SOFTWARE\\Microsoft\\VisualStudio\\SxS\\VC7" /v "FrameworkVer32" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "FrameworkVer32" ]; then
				export FrameworkVersion32="${k}"
			fi
		done <<< "$regqueryRes"
	fi
	if [ "${FrameworkVersion32-}" == "" ]; then
		return 1
	fi
	return 0
}

GetFrameworkVer32Helper64() {
	local regqueryRes=$("${reg}" query "${1}\\SOFTWARE\\Wow6432Node\\Microsoft\\VisualStudio\\SxS\\VC7" /v "FrameworkVer32" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "FrameworkVer32" ]; then
				export FrameworkVersion32="${k}"
			fi
		done <<< "$regqueryRes"
	fi
	if [ "${FrameworkVersion32-}" == "" ]; then 
		return 1
	fi
	return 0
}

GetFrameworkVer32() {
	export FrameworkVersion32=
	if ! GetFrameworkVer32Helper32 HKLM; then
		if ! GetFrameworkVer32Helper32 HKCU; then
			if ! GetFrameworkVer32Helper64  HKLM; then
				GetFrameworkVer32Helper64  HKCU
			fi
		fi
	fi
	return 0
}

# -----------------------------------------------------------------------
GetFrameworkDir32Helper32() {
	local regqueryRes=$("${reg}" query "${1}\\SOFTWARE\\Microsoft\\VisualStudio\\SxS\\VC7" /v "FrameworkDir32" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "FrameworkDir32" ]; then
				export FrameworkDIR32="$(winpath -u "${k}")"
			fi
		done <<< "$regqueryRes"
	fi
	if [ "${FrameworkDIR32-}" == "" ]; then 
		return 1
	fi
	return 0
}

GetFrameworkDir32Helper64() {
	local regqueryRes=$("${reg}" query "${1}\\SOFTWARE\\Wow6432Node\\Microsoft\\VisualStudio\\SxS\\VC7" /v "FrameworkDir32" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "FrameworkDir32" ]; then
				export FrameworkDIR32="$(winpath -u "${k}")"
			fi
		done <<< "$regqueryRes"
	fi
	if [ "${FrameworkDIR32-}" == "" ]; then 
		return 1
	fi
	return 0
}

GetFrameworkDir32() {
	export FrameworkDIR32=
	if ! GetFrameworkDir32Helper32 HKLM; then
		if ! GetFrameworkDir32Helper32 HKCU; then
			if ! GetFrameworkDir32Helper64  HKLM; then
				GetFrameworkDir32Helper64  HKCU
			fi
		fi
	fi
	return 0
}

# -----------------------------------------------------------------------
GetFSharpInstallDir() {
	export FSHARPINSTALLDIR=
	if ! GetFSharpInstallDirHelper32 HKLM; then 
		if ! GetFSharpInstallDirHelper32 HKCU; then
			if ! GetFSharpInstallDirHelper64  HKLM; then
				GetFSharpInstallDirHelper64  HKCU
			fi
		fi
	fi
	return 0
}

GetFSharpInstallDirHelper32() {
	local regqueryRes=$("${reg}" query "${1}\\SOFTWARE\\Microsoft\\VisualStudio\\10.0\\Setup\\F#" /v "ProductDir" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "ProductDir" ]; then
				export FSHARPINSTALLDIR="$(winpath -u "${k}")"
			fi
		done <<< "$regqueryRes"
	fi
	if [ "${FSHARPINSTALLDIR:-}" == "" ]; then 
		return 1
	fi
	return 0
}

GetFSharpInstallDirHelper64() {
	local regqueryRes=$("${reg}" query "${1}\\SOFTWARE\\Wow6432Node\\Microsoft\\VisualStudio\\10.0\\Setup\\F#" /v "ProductDir" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "ProductDir" ]; then
				export FSHARPINSTALLDIR="$(winpath -u "${k}")"
			fi
		done <<< "$regqueryRes"
	fi
	if [ "${FSHARPINSTALLDIR:-}" == "" ]; then 
		return 1
	fi
	return 0
}

# -----------------------------------------------------------------------

GetVCInstallDirHelper32() {
	local regqueryRes=$("${reg}" query "${1}\\SOFTWARE\\Microsoft\\VisualStudio\\SxS\\VC7" /v "10.0" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "10.0" ]; then
				export VCINSTALLDIR="$(winpath -u "${k}")"
			fi
		done <<< "$regqueryRes"
	fi
	if [ "${VCINSTALLDIR:-}" == "" ]; then 
		return 1
	fi
	return 0
}

GetVCInstallDirHelper64() {
	local regqueryRes=$("${reg}" query "${1}\\SOFTWARE\\Wow6432Node\\Microsoft\\VisualStudio\\SxS\\VC7" /v "10.0" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "10.0" ]; then
				export VCINSTALLDIR="$(winpath -u "${k}")"
			fi
		done <<< "$regqueryRes"
	fi
	if [ "${VCINSTALLDIR:-}" == "" ]; then 
		return 1
	fi
	return 0
}

GetVCInstallDir() {
	export VCINSTALLDIR=
	if ! GetVCInstallDirHelper32 HKLM; then
		if ! GetVCInstallDirHelper32 HKCU; then
			if ! GetVCInstallDirHelper64  HKLM; then
				GetVCInstallDirHelper64  HKCU
			fi
		fi
	fi
	return 0
}

# -----------------------------------------------------------------------
GetWindowsSdkDirHelper() {
	local regqueryRes=$("${reg}" query "${1}\\SOFTWARE\\Microsoft\\Microsoft SDKs\\Windows\\v7.0A" /v "InstallationFolder" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "InstallationFolder" ]; then
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
	export WindowsSdkDir=
	if ! GetWindowsSdkDirHelper HKLM; then
		if ! GetWindowsSdkDirHelper HKCU; then
			export WindowsSdkDir="${VCINSTALLDIR}/PlatformSDK/"
		fi
	fi
	return 0
}

# -----------------------------------------------------------------------
GetVSInstallDirHelper32() {
	local regqueryRes=$("${reg}" query "${1}\\SOFTWARE\\Microsoft\\VisualStudio\\SxS\\VS7" /v "10.0" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "10.0" ]; then
				export VSINSTALLDIR="$(winpath -u "${k}")"
			fi
		done <<< "$regqueryRes"
	fi
	if [ "${VSINSTALLDIR:-}" == "" ]; then 
		return 1
	fi
	return 0
}

GetVSInstallDirHelper64() {
	local regqueryRes=$("${reg}" query "${1}\\SOFTWARE\\Wow6432Node\\Microsoft\\VisualStudio\\SxS\\VS7" /v "10.0" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "10.0" ]; then
				export VSINSTALLDIR="$(winpath -u "${k}")"
			fi
		done <<< "$regqueryRes"
	fi
	if [ "${VSINSTALLDIR}" == "" ]; then
		return 1
	fi
	return 0
}

GetVSInstallDir() {
	export VSINSTALLDIR=
	if ! GetVSInstallDirHelper32 HKLM; then
		if ! GetVSInstallDirHelper32 HKCU; then
			if ! GetVSInstallDirHelper64  HKLM; then
				GetVSInstallDirHelper64  HKCU
			fi
		fi
	fi
	return 0
}

GetWindowsSdkDir
GetVSInstallDir
GetVCInstallDir
GetFSharpInstallDir
if [ "${1:-}" == "32bit" ]; then
	GetFrameworkDir32
	GetFrameworkVer32
fi
if [ "${2:-}" == "64bit" ]; then
	GetFrameworkDir64
	GetFrameworkVer64
fi
export Framework35Version="v3.5"
