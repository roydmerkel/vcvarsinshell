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

REALPATH="$(realpath "${BASH_SOURCE[0]}")"


# -----------------------------------------------------------------------
GetVSCommonToolsDirHelper32() {
	local regqueryRes=$("${reg}" query "${1}\\SOFTWARE\\Microsoft\\VisualStudio\\SxS\\VS7" /v "11.0" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "11.0" ]; then
				export VS110COMNTOOLS="$(winpath -u "${k}")"
			fi
		done <<< "$regqueryRes"
	fi
	if [ "${VS110COMNTOOLS:-}" == "" ]; then 
		return 1
	fi
	export VS110COMNTOOLS="${VS110COMNTOOLS}Common7/Tools/"
	return 0
}

GetVSCommonToolsDirHelper64() {
	local regqueryRes=$("${reg}" query "${1}\\SOFTWARE\\Wow6432Node\\Microsoft\\VisualStudio\\SxS\\VS7" /v "11.0" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "11.0" ]; then
				export VS110COMNTOOLS="$(winpath -u "${k}")"
			fi
		done <<< "$regqueryRes"
	fi
	if [ "${VS110COMNTOOLS:-}" == "" ]; then 
		return 1
	fi
	export VS110COMNTOOLS="${VS110COMNTOOLS}Common7/Tools/"
	return 0
}

GetVSCommonToolsDir() {
	export VS110COMNTOOLS=
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

GetVSCommonToolsDir
if [ "${VS110COMNTOOLS:-}" == "" ]; then 
	echo "ERROR: Cannot determine the location of the VS Common Tools folder."
else
	. "$(dirname "${REALPATH}")/VCVarsPhoneQueryRegistry.sh" 32bit No64bit

	if [ "${VSINSTALLDIR:-}" == "" ]; then
		echo "ERROR: Cannot determine the location of the VS installation."
	elif [ "${VCINSTALLDIR:-}" == "" ]; then 
		echo "ERROR: Cannot determine the location of the VC installation."
	elif [ "${FrameworkDIR32:-}" == "" ]; then 
		echo "ERROR: Cannot determine the location of the .NET Framework 32bit installation."
	elif [ "${FrameworkVersion32:-}" == "" ]; then 
		echo "ERROR: Cannot determine the version of the .NET Framework 32bit installation."
	elif [ "${Framework35Version:-}" == "" ]; then 
		echo "ERROR: Cannot determine the .NET Framework 3.5 version."
	else
		export FrameworkDir="${FrameworkDIR32}"
		export FrameworkVersion="${FrameworkVersion32}"

		if [ "${WindowsPhoneKitDir:-}" != "" ]; then
			if [ "${PATH:-}" != "" ]; then
				export PATH="${WindowsPhoneKitDir}bin:${WindowsPhoneKitDir}bin/x86:${PATH}"
			else
				export PATH="${WindowsPhoneKitDir}bin:${WindowsPhoneKitDir}bin/x86"
			fi
			if [ "${INCLUDE:-}" != "" ]; then
				export INCLUDE="${WindowsPhoneKitDir}include:${WindowsPhoneKitDir}include/abi:${WindowsPhoneKitDir}include/mincore:${WindowsPhoneKitDir}include/minwin:${WindowsPhoneKitDir}include/wrl:${INCLUDE}"
			else
				export INCLUDE="${WindowsPhoneKitDir}include:${WindowsPhoneKitDir}include/abi:${WindowsPhoneKitDir}include/mincore:${WindowsPhoneKitDir}include/minwin:${WindowsPhoneKitDir}include/wrl"
			fi
			if [ "${LIB:-}" != "" ]; then
				export LIB="${WindowsPhoneKitDir}lib/x86:${LIB}"
			else
				export LIB="${WindowsPhoneKitDir}lib/x86"
			fi
			if [ "${LIBPATH:-}" != "" ]; then
				export LIBPATH="${WindowsPhoneKitDir}Windows MetaData:${LIBPATH}"
			else
				export LIBPATH="${WindowsPhoneKitDir}Windows MetaData"
			fi
		fi

		if [ "${WindowsPhoneSdkDir:-}" != "" ]; then
			if [ "${PATH:-}" != "" ]; then
				export PATH="${WindowsPhoneSdkDir}v8.0/Tools/XAP Deployment:${PATH}"
			else
				export PATH="${WindowsPhoneSdkDir}v8.0/Tools/XAP Deployment"
			fi
		fi

		if [ "${ExtensionSDKDir:-}" != "" ]; then
			if [ "${LIBPATH:-}" != "" ]; then
				export LIBPATH="${ExtensionSDKDir}/Microsoft.VCLibs/11.0/References/CommonConfiguration/neutral:${LIBPATH}"
			else
				export LIBPATH="${ExtensionSDKDir}/Microsoft.VCLibs/11.0/References/CommonConfiguration/neutral"
			fi
		fi

		#
		# Root of Visual Studio IDE installed files.
		#
		export DevEnvDir="${VSINSTALLDIR}Common7/IDE/"

		# PATH
		# ----
		if [ -e "${VSINSTALLDIR}Team Tools/Performance Tools" ]; then
			if [ "${PATH:-}" != "" ]; then
				export PATH="${VSINSTALLDIR}Team Tools/Performance Tools:${PATH}"
			else
				export PATH="${VSINSTALLDIR}Team Tools/Performance Tools"
			fi
		fi
		if [ -e "${VCINSTALLDIR}VCPackages" ]; then 
			if [ "${PATH:-}" != "" ]; then
				export PATH="${VCINSTALLDIR}VCPackages:${PATH}"
			else
				export PATH="${VCINSTALLDIR}VCPackages"
			fi
		fi
		if [ "${PATH:-}" != "" ]; then
			export PATH="${FrameworkDir}${Framework35Version}:${PATH}"
		else
			export PATH="${FrameworkDir}${Framework35Version}"
		fi
		if [ "${PATH:-}" != "" ]; then
			export PATH="${FrameworkDir}${FrameworkVersion}:${PATH}"
		else
			export PATH="${FrameworkDir}${FrameworkVersion}"
		fi
		if [ "${PATH:-}" != "" ]; then
			export PATH="${VSINSTALLDIR}Common7/Tools:${PATH}"
		else
			export PATH="${VSINSTALLDIR}Common7/Tools"
		fi
		if [ "${PATH:-}" != "" ]; then
			export PATH="${VCPhoneToolsRoot}BIN:${PATH}"
		else
			export PATH="${VCPhoneToolsRoot}BIN"
		fi
		if [ "${PATH:-}" != "" ]; then
			export PATH="${DevEnvDir}:${PATH}"
		else
			export PATH="${DevEnvDir}"
		fi

		# INCLUDE
		# -------
		if [ "${INCLUDE:-}" != "" ]; then
			export INCLUDE="${VCPhoneToolsRoot}INCLUDE:${INCLUDE}"
		else
			export INCLUDE="${VCPhoneToolsRoot}INCLUDE"
		fi

		# LIB
		# ---
		if [ "${LIB:-}" != "" ]; then
			export LIB="${VCPhoneToolsRoot}LIB:${LIB}"
		else
			export LIB="${VCPhoneToolsRoot}LIB"
		fi

		# LIBPATH
		# -------
		if [ "${LIBPATH:-}" != "" ]; then
			export LIBPATH="${VCPhoneToolsRoot}LIB:${LIBPATH}"
		else
			export LIBPATH="${VCPhoneToolsRoot}LIB"
		fi
		if [ "${LIBPATH:-}" != "" ]; then
			export LIBPATH="${FrameworkDir}${Framework35Version}:${LIBPATH}"
		else
			export LIBPATH="${FrameworkDir}${Framework35Version}"
		fi
		if [ "${LIBPATH:-}" != "" ]; then
			export LIBPATH="${FrameworkDir}${FrameworkVersion}:${LIBPATH}"
		else
			export LIBPATH="${FrameworkDir}${FrameworkVersion}"
		fi
	fi
fi

# -----------------------------------------------------------------------
