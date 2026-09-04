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

GetWindowsSdkDirHelper32() {
	GetRegistryValue "${1}\\SOFTWARE\\Microsoft\\Microsoft SDKs\\Windows\\v8.1" "InstallationFolder" "WindowsSdkDir" "winpath -u"
	return $?
}

GetWindowsSdkDirHelper64() {
	GetRegistryValue "${1}\\SOFTWARE\\Wow6432Node\\Microsoft\\Microsoft SDKs\\Windows\\v8.1" "InstallationFolder" "WindowsSdkDir" "winpath -u"
	return $?
}

GetWindowsSdkDir() {
	export WindowsSdkDir=
	if ! GetWindowsSdkDirHelper32 HKLM; then
		if ! GetWindowsSdkDirHelper32 HKCU; then
			if ! GetWindowsSdkDirHelper64 HKLM; then
				GetWindowsSdkDirHelper64 HKCU
			fi
		fi
	fi
	return 0
}

# -----------------------------------------------------------------------

GetWindowsSdkExePathHelper() {
	GetRegistryValue "${1}\\SOFTWARE\\Microsoft\\Microsoft SDKs\\Windows\\v8.1A\\WinSDK-NetFx40Tools" "InstallationFolder" "WindowsSDK_ExecutablePath_x86" "winpath -u"
	return $?
}

GetWindowsSdkExePathHelperWow6432() {
	GetRegistryValue "${1}\\SOFTWARE\\Wow6432Node\\Microsoft\\Microsoft SDKs\\Windows\\v8.1A\\WinSDK-NetFx40Tools" "InstallationFolder" "WindowsSDK_ExecutablePath_x86" "winpath -u"
	return $?
}

GetWindowsSdkExecutablePath32() {
	export WindowsSDK_ExecutablePath_x86=
	if ! GetWindowsSdkExePathHelper HKLM; then
		if ! GetWindowsSdkExePathHelper HKCU; then
			if ! GetWindowsSdkExePathHelperWow6432 HKLM; then
				GetWindowsSdkExePathHelperWow6432 HKCU
			fi
		fi
	fi
	return 0
}

# -----------------------------------------------------------------------

GetWindowsSdkExePathHelper_x64() {
	GetRegistryValue "${1}\\SOFTWARE\\Microsoft\\Microsoft SDKs\\Windows\\v8.1A\\WinSDK-NetFx40Tools-x64" "InstallationFolder" "WindowsSDK_ExecutablePath_x64" "winpath -u"
	return $?
}

GetWindowsSdkExePathHelperWow6432_x64() {
	GetRegistryValue "${1}\\SOFTWARE\\Wow6432Node\\Microsoft\\Microsoft SDKs\\Windows\\v8.1A\\WinSDK-NetFx40Tools-x64" "InstallationFolder" "WindowsSDK_ExecutablePath_x64" "winpath -u"
	return $?
}

GetWindowsSdkExecutablePath64() {
	export WindowsSDK_ExecutablePath_x64=
	if  ! GetWindowsSdkExePathHelper_x64 HKLM; then
		if ! GetWindowsSdkExePathHelper_x64 HKCU; then
			if ! GetWindowsSdkExePathHelperWow6432_x64 HKLM; then
				GetWindowsSdkExePathHelperWow6432_x64 HKCU
			fi
		fi
	fi
	return 0
}

# -----------------------------------------------------------------------

GetExtensionSdkDir() {
	export ExtensionSdkDir=

	if [ -e "${ProgramFiles}/Microsoft SDKs/Windows/v8.1/ExtensionSDKs/Microsoft.VCLibs/12.0/SDKManifest.xml" ]; then
		export ExtensionSdkDir="${ProgramFiles}/Microsoft SDKs/Windows/v8.1/ExtensionSDKs"
	fi
	if [ -e "${ProgramFilesx86}/Microsoft SDKs/Windows/v8.1/ExtensionSDKs/Microsoft.VCLibs/12.0/SDKManifest.xml" ]; then
		export ExtensionSdkDir="${ProgramFilesx86}/Microsoft SDKs/Windows/v8.1/ExtensionSDKs"
	fi

	if [ "%ExtensionSdkDir%"=="" ]; then 
		return 1
	fi
	return 0
}

# -----------------------------------------------------------------------

GetVSInstallDirHelper32() {
	GetRegistryValue "${1}\\SOFTWARE\\Microsoft\\VisualStudio\\SxS\\VS7" "12.0" "VSINSTALLDIR" "winpath -u"
	return $?
}

GetVSInstallDirHelper64() {
	GetRegistryValue "${1}\\SOFTWARE\\Wow6432Node\\Microsoft\\VisualStudio\\SxS\\VS7" "12.0" "VSINSTALLDIR" "winpath -u"
	return $?
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

# -----------------------------------------------------------------------

GetVCInstallDirHelper32() {
	GetRegistryValue "${1}\\SOFTWARE\\Microsoft\\VisualStudio\\SxS\\VC7" "12.0" "VCINSTALLDIR" "winpath -u"
	return $?
}

GetVCInstallDirHelper64() {
	GetRegistryValue "${1}\\SOFTWARE\\Wow6432Node\\Microsoft\\VisualStudio\\SxS\\VC7" "12.0" "VCINSTALLDIR" "winpath -u"
	return $?
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

GetFSharpInstallDirHelper32() {
	GetRegistryValue "${1}\\SOFTWARE\\Microsoft\\VisualStudio\\12.0\\Setup\\F#" "ProductDir" "FSHARPINSTALLDIR" "winpath -u"
	return $?
}

GetFSharpInstallDirHelper64() {
	GetRegistryValue "${1}\\SOFTWARE\\Wow6432Node\\Microsoft\\VisualStudio\\12.0\\Setup\\F#" "ProductDir" "FSHARPINSTALLDIR" "winpath -u"
	return $?
}

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

# -----------------------------------------------------------------------

GetFrameworkDir32Helper32() {
	GetRegistryValue "${1}\\SOFTWARE\\Microsoft\\VisualStudio\\SxS\\VC7" "FrameworkDir32" "FrameworkDir32" "winpath -u"
	return $?
}

GetFrameworkDir32Helper64() {
	GetRegistryValue "${1}\\SOFTWARE\\Wow6432Node\\Microsoft\\VisualStudio\\SxS\\VC7" "FrameworkDir32" "FrameworkDir32" "winpath -u"
	return $?
}

GetFrameworkDir32() {
	export FrameworkDir32=
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
GetFrameworkVer32Helper32() {
	GetRegistryValue "${1}\\SOFTWARE\\Microsoft\\VisualStudio\\SxS\\VC7" "FrameworkVer32" "FrameworkVersion32"
	return $?
}

GetFrameworkVer32Helper64() {
	GetRegistryValue "${1}\\SOFTWARE\\Wow6432Node\\Microsoft\\VisualStudio\\SxS\\VC7" "FrameworkVer32" "FrameworkVersion32"
	return $?
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

GetFrameworkDir64Helper32() {
	GetRegistryValue "${1}\\SOFTWARE\\Microsoft\\VisualStudio\\SxS\\VC7" "FrameworkDir64" "FrameworkDir64" "winpath -u"
	return $?
}

GetFrameworkDir64Helper64() {
	GetRegistryValue "${1}\\SOFTWARE\\Wow6432Node\\Microsoft\\VisualStudio\\SxS\\VC7" "FrameworkDir64" "FrameworkDir64" "winpath -u"
	return $?
}

GetFrameworkDir64() {
	export FrameworkDir64=
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

GetFrameworkVer64Helper32() {
	GetRegistryValue "${1}\\SOFTWARE\\Microsoft\\VisualStudio\\SxS\\VC7" "FrameworkVer64" "FrameworkVersion64"
	return $?
}

GetFrameworkVer64Helper64() {
	GetRegistryValue "${1}\\SOFTWARE\\Wow6432Node\\Microsoft\\VisualStudio\\SxS\\VC7" "FrameworkVer64" "FrameworkVersion64"
	return $?
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

GetWindowsSdkDir
GetWindowsSdkExecutablePath32
GetWindowsSdkExecutablePath64
GetExtensionSdkDir
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
if [ "${1:-} ${2:-}" == "64bit 32bit" ]; then
	GetFrameworkDir64
	GetFrameworkVer64
fi
export Framework40Version=v4.0

# -----------------------------------------------------------------------
# Used by MsBuild to determine where to look in the registry for VCTargetsPath
# -----------------------------------------------------------------------
export VisualStudioVersion=12.0

# -----------------------------------------------------------------------
