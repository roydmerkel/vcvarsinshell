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

ProgramFilesx86="$(winpath -u "$(cmd.exe /d /c "echo %ProgramFiles(x86)%" 2>/dev/null | tr -d '\r')")"
ProgramFiles="$(winpath -u "$(cmd.exe /d /c "echo %ProgramFiles%" 2>/dev/null | tr -d '\r')")"

# -----------------------------------------------------------------------
GetVSCommonToolsDirHelper32() {
	local regqueryRes=$("${reg}" query "${1}\\SOFTWARE\\Microsoft\\VisualStudio\\SxS\\VS7" /v "10.0" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "10.0" ]; then
				export VS100COMNTOOLS="$(winpath -u "${k}")"
			fi
		done <<< "$regqueryRes"
	fi
	if [ "${VS100COMNTOOLS:-}" == "" ]; then 
		return 1 
	fi
	export VS100COMNTOOLS="${VS100COMNTOOLS}Common7/Tools/"
	return 0
}

GetVSCommonToolsDirHelper64() {
	local regqueryRes=$("${reg}" query "${1}\\SOFTWARE\\Wow6432Node\\Microsoft\\VisualStudio\\SxS\\VS7" /v "10.0" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "10.0" ]; then
				export VS100COMNTOOLS="$(winpath -u "${k}")"
			fi
		done <<< "$regqueryRes"
	fi
	if [ "${VS100COMNTOOLS:-}" == "" ]; then 
		return 1
	fi
	export VS100COMNTOOLS="${VS100COMNTOOLS}Common7/Tools/"
	return 0
}

GetVSCommonToolsDir() {
	export VS100COMNTOOLS=
	if ! GetVSCommonToolsDirHelper32 HKLM; then
		if ! GetVSCommonToolsDirHelper32 HKCU; then
			if ! GetVSCommonToolsDirHelper64  HKLM; then
				GetVSCommonToolsDirHelper64  HKCU
			fi
		fi
	fi
	return 0
}

# -----------------------------------------------------------------------

echo "Setting environment for using Microsoft Visual Studio 2010 x64 tools."

GetVSCommonToolsDir
if [ "${VS100COMNTOOLS:-}" == "" ]; then 
	echo "ERROR: Cannot determine the location of the VS Common Tools folder."
else

	. "${VS100COMNTOOLS}VCVarsQueryRegistry.sh" No32bit 64bit

	if [ "${VSINSTALLDIR:-}" == "" ]; then 
		echo "ERROR: Cannot determine the location of the VS installation."
	elif [ "${VCINSTALLDIR:-}" == "" ]; then 
		echo "ERROR: Cannot determine the location of the VC installation."
	elif [ "${FrameworkDIR64:-}" == "" ]; then 
		echo "ERROR: Cannot determine the location of the .NET Framework 64bit installation."
	elif [ "${FrameworkVersion64:-}" == "" ]; then 
		echo "ERROR: Cannot determine the version of the .NET Framework 64bit installation."
	elif [ "${Framework35Version:-}" == "" ]; then 
		echo "ERROR: Cannot determine the .NET Framework 3.5 version."
	else
		export FrameworkDir="${FrameworkDIR64}"
		export FrameworkVersion="${FrameworkVersion64}"

		if [ "${WindowsSdkDir:-}" != "" ]; then
			if [ "${PATH:-}" != "" ]; then 
				export PATH="${WindowsSdkDir}bin/NETFX 4.0 Tools/x64:${WindowsSdkDir}bin/x64:${WindowsSdkDir}bin:${PATH}"
			else
				export PATH="${WindowsSdkDir}bin/NETFX 4.0 Tools/x64:${WindowsSdkDir}bin/x64:${WindowsSdkDir}bin"
			fi
			if [ "${INCLUDE:-}" != "" ]; then 
				export INCLUDE="${WindowsSdkDir}include:${INCLUDE}"
			else
				export INCLUDE="${WindowsSdkDir}include"
			fi
			if [ "${LIB:-}" != "" ]; then 
				export LIB="${WindowsSdkDir}lib/x64:${LIB}"
			else
				export LIB="${WindowsSdkDir}lib/x64"
			fi
		fi

		# PATH
		# ----
		if [ -e "${VSINSTALLDIR}Team Tools/Performance Tools/x64" ]; then
			if [ "${PATH:-}" != "" ]; then 
				export PATH="${VSINSTALLDIR}Team Tools/Performance Tools/x64:${VSINSTALLDIR}Team Tools/Performance Tools:${PATH}"
			else
				export PATH="${VSINSTALLDIR}Team Tools/Performance Tools/x64:${VSINSTALLDIR}Team Tools/Performance Tools"
			fi
		fi
		if [ -e "${ProgramFiles}/HTML Help Workshop" ]; then 
			if [ "${PATH:-}" != "" ]; then 
				export PATH="${ProgramFiles}/HTML Help Workshop:${PATH}"
			else
				export PATH="${ProgramFiles}/HTML Help Workshop"
			fi
		fi
		if [ -e "${ProgramFilesx86}/HTML Help Workshop" ]; then 
			if [ "${PATH:-}" != "" ]; then 
				export PATH="${ProgramFilesx86}/HTML Help Workshop:${PATH}"
			else
				export PATH="${ProgramFilesx86}/HTML Help Workshop"
			fi
		fi
		if [ "${PATH:-}" != "" ]; then 
			export PATH="${VSINSTALLDIR}Common7/Tools:${PATH}"
		else
			export PATH="${VSINSTALLDIR}Common7/Tools"
		fi
		if [ "${PATH:-}" != "" ]; then 
			export PATH="${VSINSTALLDIR}Common7/IDE:${PATH}"
		else
			export PATH="${VSINSTALLDIR}Common7/IDE"
		fi
		if [ "${PATH:-}" != "" ]; then 
			export PATH="${VCINSTALLDIR}VCPackages:${PATH}"
		else
			export PATH="${VCINSTALLDIR}VCPackages"
		fi
		
		if [ "${PATH:-}" != "" ]; then 
			export PATH="${FrameworkDir}/${Framework35Version}:${PATH}"
		else
			export PATH="${FrameworkDir}/${Framework35Version}"
		fi
		
		if [ "${PATH:-}" != "" ]; then 
			export PATH="${FrameworkDir}/${FrameworkVersion}:${PATH}"
		else
			export PATH="${FrameworkDir}/${FrameworkVersion}"
		fi
		if [ "${PATH:-}" != "" ]; then 
			export PATH="${VCINSTALLDIR}BIN/amd64:${PATH}"
		else
			export PATH="${VCINSTALLDIR}BIN/amd64"
		fi
		

		# INCLUDE
		# -------
		if [ -e "${VCINSTALLDIR}ATLMFC/INCLUDE" ]; then 
			if [ "${INCLUDE:-}" != "" ]; then 
				export INCLUDE="${VCINSTALLDIR}ATLMFC/INCLUDE:${INCLUDE}"
			else
				export INCLUDE="${VCINSTALLDIR}ATLMFC/INCLUDE"
			fi
		fi
		if [ "${INCLUDE:-}" != "" ]; then 
			export INCLUDE="${VCINSTALLDIR}INCLUDE:${INCLUDE}"
		else
			export INCLUDE="${VCINSTALLDIR}INCLUDE"
		fi

		# LIB
		# ---
		if [ -e "${VCINSTALLDIR}ATLMFC/LIB/amd64" ]; then 
			if [ "${LIB:-}" != "" ]; then 
				export LIB="R{VCINSTALLDIR}ATLMFC/LIB/amd64:${LIB}"
			else
				export LIB="R{VCINSTALLDIR}ATLMFC/LIB/amd64"
			fi
		fi
		if [ "${LIB:-}" != "" ]; then 
			export LIB="${VCINSTALLDIR}LIB/amd64:${LIB}"
		else
			export LIB="${VCINSTALLDIR}LIB/amd64"
		fi

		# LIBPATH
		# -------
		if [ -e "${VCINSTALLDIR}ATLMFC/LIB/amd64" ]; then 
			if [ "${LIBPATH:-}" != "" ]; then 
				export LIBPATH="${VCINSTALLDIR}ATLMFC/LIB/amd64:${LIBPATH}"
			else
				export LIBPATH="${VCINSTALLDIR}ATLMFC/LIB/amd64"
			fi
		fi
		if [ "${LIBPATH:-}" != "" ]; then 
			export LIBPATH="${VCINSTALLDIR}LIB/amd64:${LIBPATH}"
		else
			export LIBPATH="${VCINSTALLDIR}LIB/amd64"
		fi
		if [ "${LIBPATH:-}" != "" ]; then 
			export LIBPATH="${FrameworkDir}/${Framework35Version}:${LIBPATH}"
		else
			export LIBPATH="${FrameworkDir}/${Framework35Version}"
		fi
		if [ "${LIBPATH:-}" != "" ]; then 
			export LIBPATH="${FrameworkDir}/${FrameworkVersion}:${LIBPATH}"
		else
			export LIBPATH="${FrameworkDir}/${FrameworkVersion}"
		fi

		export Platform=X64
		export CommandPromptType=Native
	fi
fi

# -----------------------------------------------------------------------
