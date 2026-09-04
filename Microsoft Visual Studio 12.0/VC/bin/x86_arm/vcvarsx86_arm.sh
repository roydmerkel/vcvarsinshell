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
dollar0="$(basename "${REALPATH}")"

GetRegistryValue() {
	if [ "${1:-}" == "" ]; then
		return 1
	elif [ "${2:-}" == "" ]; then
		return 1
	elif [ "${3:-}" == "" ]; then
		return 1
	fi

	local searchkey="$1"
	local searchValue="$2"
	local outputVar="$3"
	local processor="${4:-}"

	local regqueryRes=$("${reg}" query "${searchkey}" /v "${searchValue}" 2>/dev/null | tr -d '\r')
	if [[ -n "$regqueryRes" ]]; then
		while read -r i j k; do
			if [ "${i}" == "${searchValue}" ]; then
				if [ "${processor}" != "" ]; then
					eval "${outputVar}=\$(${processor} \"\${k}\")"
				else
					eval "${outputVar}=\"\${k}\""
				fi
			fi
		done <<< "$regqueryRes"
	fi
	if [ "${!outputVar:-}" == "" ]; then 
		return 1
	fi
	return 0
}

# -----------------------------------------------------------------------

GetVSCommonToolsDirHelper32() {
	GetRegistryValue "${1}\\SOFTWARE\\Microsoft\\VisualStudio\\SxS\\VS7" "12.0" "VS120COMNTOOLS" "winpath -u"
	if [ "${VS120COMNTOOLS:-}" == "" ]; then 
		return 1
	fi
	export VS120COMNTOOLS="${VS120COMNTOOLS}Common7/Tools/"
	return 0
}

GetVSCommonToolsDirHelper64() {
	GetRegistryValue "${1}\\SOFTWARE\\Wow6432Node\\Microsoft\\VisualStudio\\SxS\\VS7" "12.0" "VS120COMNTOOLS" "winpath -u"
	if [ "${VS120COMNTOOLS:-}" == "" ]; then 
		return 1
	fi
	export VS120COMNTOOLS="${VS120COMNTOOLS}Common7/Tools/"
	return 0
}

GetVSCommonToolsDir() {
	export VS120COMNTOOLS=
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
if [ "${VS120COMNTOOLS:-}" == "" ]; then 
	echo "ERROR: Cannot determine the location of the VS Common Tools folder."
else

	. "${VS120COMNTOOLS}VCVarsQueryRegistry.sh" 32bit No64bit

	if [ "${VSINSTALLDIR:-}" == "" ]; then 
		echo "ERROR: Cannot determine the location of the VS installation."
	elif [ "${VCINSTALLDIR:-}" == "" ]; then 
		echo "ERROR: Cannot determine the location of the VC installation."
	elif [ "${FrameworkDir32:-}" == "" ]; then 
		echo "ERROR: Cannot determine the location of the .NET Framework 32bit installation."
	elif [ "${FrameworkVersion32:-}" == "" ]; then 
		echo "ERROR: Cannot determine the version of the .NET Framework 32bit installation."
	elif [ "${Framework40Version:-}" == "" ]; then 
		echo "ERROR: Cannot determine the .NET Framework 4.0 version."
	else
		export FrameworkDir="${FrameworkDir32}"
		export FrameworkVersion="${FrameworkVersion32}"

		if [ "${WindowsSDK_ExecutablePath_x64:-}" != "" ]; then
			export PATH="${WindowsSDK_ExecutablePath_x64}${PATH:+:${PATH}}"
		fi

		if [ "${WindowsSdkDir:-}" != "" ]; then
			export PATH="${WindowsSdkDir}bin/x86${PATH:+:${PATH}}"
			export INCLUDE="${WindowsSdkDir}include/shared:${WindowsSdkDir}include/um:${WindowsSdkDir}include/winrt${INCLUDE:+:${INCLUDE}}"
			export LIB="${WindowsSdkDir}lib/winv6.3/um/ARM${LIB:+:${LIB}}"
			export LIBPATH="${WindowsSdkDir}References/CommonConfiguration/Neutral:${ExtensionSDKDir}/Microsoft.VCLibs/12.0/References/CommonConfiguration/neutral${LIBPATH:+:${LIBPATH}}"
		fi

		#
		# Root of Visual Studio IDE installed files.
		#
		export DevEnvDir="${VSINSTALLDIR}Common7/IDE/"

		# PATH
		# ----
		if [ -e "${VSINSTALLDIR}Team Tools/Performance Tools" ]; then
			export PATH="${VSINSTALLDIR}Team Tools/Performance Tools${PATH:+:${PATH}}"
		fi
		if [ -e "${ProgramFiles}/HTML Help Workshop" ]; then
			export PATH="${ProgramFiles}/HTML Help Workshop${PATH:+:${PATH}}"
		fi
		if [ -e "${ProgramFilesx86}/HTML Help Workshop" ]; then 
			export PATH="${ProgramFilesx86}/HTML Help Workshop${PATH:+:${PATH}}"
		fi
		if [ -e "${VCINSTALLDIR}VCPackages" ]; then 
			export PATH="${VCINSTALLDIR}VCPackages${PATH:+:${PATH}}"
		fi
		if [ -e "${FrameworkDir}${Framework40Version}" ]; then 
			export PATH="${FrameworkDir}${Framework40Version}${PATH:+:${PATH}}"
		fi
		if [ -e "${FrameworkDir}${FrameworkVersion}" ]; then 
			export PATH="${FrameworkDir}${FrameworkVersion}${PATH:+:${PATH}}"
		fi
		if [ -e "${VSINSTALLDIR}Common7/Tools" ]; then 
			export PATH="${VSINSTALLDIR}Common7/Tools${PATH:+:${PATH}}"
		fi
		if [ -e "${VCINSTALLDIR}BIN" ]; then 
			export PATH="${VCINSTALLDIR}BIN${PATH:+:${PATH}}"
		fi
		if [ -e "${VCINSTALLDIR}BIN/x86_ARM" ]; then
			export PATH="${VCINSTALLDIR}BIN/x86_ARM${PATH:+:${PATH}}"
		fi
		export PATH="${DevEnvDir}${PATH:+:${PATH}}"

		# Add path to MSBuild Binaries
		if [ -e "${ProgramFiles}/MSBuild/12.0/bin" ]; then 
			export PATH="${ProgramFiles}/MSBuild/12.0/bin${PATH:+:${PATH}}"
		fi
		if [ -e "${ProgramFilesx86}/MSBuild/12.0/bin" ]; then 
			export PATH="${ProgramFilesx86}/MSBuild/12.0/bin${PATH:+:${PATH}}"
		fi

		if [ "${FSHARPINSTALLDIR:-}" != "" ]; then 
			export PATH="${FSHARPINSTALLDIR}${PATH:+:${PATH}}"
		fi

		if [ -e "${DevEnvDir}CommonExtensions/Microsoft/TestWindow" ]; then 
			export PATH="${DevEnvDir}CommonExtensions/Microsoft/TestWindow${PATH:+:${PATH}}"
		fi

		# INCLUDE
		# -------
		if [ -e "${VCINSTALLDIR}ATLMFC/INCLUDE" ]; then 
			export INCLUDE="${VCINSTALLDIR}ATLMFC/INCLUDE${INCLUDE:+:${INCLUDE}}"
		fi
		if [ -e "${VCINSTALLDIR}INCLUDE" ]; then 
			export INCLUDE="${VCINSTALLDIR}INCLUDE${INCLUDE:+:${INCLUDE}}"
		fi

		# LIB
		# ---
		if [ -e "${VCINSTALLDIR}ATLMFC/LIB/ARM" ]; then 
			export LIB="${VCINSTALLDIR}ATLMFC/LIB/ARM${LIB:+:${LIB}}"
		fi
		if [ -e "${VCINSTALLDIR}LIB/ARM" ]; then 
			export LIB="${VCINSTALLDIR}LIB/ARM${LIB:+:${LIB}}"
		fi

		# LIBPATH
		# -------
		if [ -e "${VCINSTALLDIR}ATLMFC/LIB/ARM" ]; then 
			export LIBPATH="${VCINSTALLDIR}ATLMFC/LIB/ARM${LIBPATH:+:${LIBPATH}}"
		fi
		if [ -e "${VCINSTALLDIR}LIB/ARM" ]; then 
			export LIBPATH="${VCINSTALLDIR}LIB/ARM${LIBPATH:+:${LIBPATH}}"
		fi
		if [ -e "${FrameworkDir}${Framework40Version}" ]; then 
			export LIBPATH="${FrameworkDir}${Framework40Version}${LIBPATH:+:${LIBPATH}}"
		fi
		if [ -e "${FrameworkDir}${FrameworkVersion}" ]; then 
			export LIBPATH="${FrameworkDir}${FrameworkVersion}${LIBPATH:+:${LIBPATH}}"
		fi

		export Platform="ARM"
		export CommandPromptType="Cross"
	fi
fi

# -----------------------------------------------------------------------
