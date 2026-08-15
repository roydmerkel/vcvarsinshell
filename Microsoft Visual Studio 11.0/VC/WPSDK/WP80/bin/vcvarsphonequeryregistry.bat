@call :GetWindowsPhoneKitDir
@call :GetWindowsPhoneSdkDir
@call :GetExtensionSdkDir
@call :GetVSInstallDir
@call :GetVCInstallDir
@if "%1"=="32bit" (
	@call :GetFrameworkDir32
	@call :GetFrameworkVer32
)
@if "%2"=="64bit" (
	@call :GetFrameworkDir64
	@call :GetFrameworkVer64
)
@SET Framework35Version=v3.5

@goto end

@REM -----------------------------------------------------------------------
:GetWindowsPhoneKitDir
@set WindowsPhoneKitDir=
@call :GetWindowsPhoneKitDirHelper32 HKLM > nul 2>&1
@if errorlevel 1 call :GetWindowsPhoneKitDirHelper32 HKCU > nul 2>&1
@if errorlevel 1 call :GetWindowsPhoneKitDirHelper64 HKLM > nul 2>&1
@if errorlevel 1 call :GetWindowsPhoneKitDirHelper64 HKCU > nul 2>&1
@exit /B 0

:GetWindowsPhoneKitDirHelper32
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Microsoft\Microsoft SDKs\WindowsPhone\v8.0" /v "InstallationFolder"') DO (
	@if "%%i"=="InstallationFolder" (
		@SET "WindowsPhoneKitDir=%%k"
	)
)
@if "%WindowsPhoneKitDir%"=="" exit /B 1
@exit /B 0

:GetWindowsPhoneKitDirHelper64
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Wow6432Node\Microsoft\Microsoft SDKs\WindowsPhone\v8.0" /v "InstallationFolder"') DO (
	@if "%%i"=="InstallationFolder" (
		@SET "WindowsPhoneKitDir=%%k"
	)
)
@if "%WindowsPhoneKitDir%"=="" exit /B 1
@exit /B 0

@REM -----------------------------------------------------------------------
:GetWindowsPhoneSdkDir
@set WindowsPhoneSdkDir=
@call :GetWindowsPhoneSdkDirHelper32 HKLM > nul 2>&1
@if errorlevel 1 call :GetWindowsPhoneSdkDirHelper32 HKCU > nul 2>&1
@if errorlevel 1 call :GetWindowsPhoneSdkDirHelper64 HKLM > nul 2>&1
@if errorlevel 1 call :GetWindowsPhoneSdkDirHelper64 HKCU > nul 2>&1
@exit /B 0

:GetWindowsPhoneSdkDirHelper32
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Microsoft\Microsoft SDKs\WindowsPhone\v8.0\InstallPath" /v "InstallPath"') DO (
	@if "%%i"=="InstallationFolder" (
		@SET "WindowsPhoneSdkDir=%%k"
	)
)
@if "%WindowsPhoneSdkDir%"=="" exit /B 1
@exit /B 0

:GetWindowsPhoneSdkDirHelper64
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Wow6432Node\Microsoft\Microsoft SDKs\WindowsPhone\v8.0\InstallPath" /v "InstallPath"') DO (
	@if "%%i"=="InstallationFolder" (
		@SET "WindowsPhoneSdkDir=%%k"
	)
)
@if "%WindowsPhoneSdkDir%"=="" exit /B 1
@exit /B 0

@REM -----------------------------------------------------------------------
:GetExtensionSdkDir
@set ExtensionSdkDir=

@if exist "%ProgramFiles%\Microsoft SDKs\Windows Phone\v8.0\ExtensionSDKs\Microsoft.VCLibs\11.0\SDKManifest.xml" set ExtensionSdkDir=%ProgramFiles%\Microsoft SDKs\Windows\v8.0\ExtensionSDKs
@if exist "%ProgramFiles(x86)%\Microsoft SDKs\Windows Phone\v8.0\ExtensionSDKs\Microsoft.VCLibs\11.0\SDKManifest.xml" set ExtensionSdkDir=%ProgramFiles(x86)%\Microsoft SDKs\Windows\v8.0\ExtensionSDKs

@if "%ExtensionSdkDir%"=="" exit /B 1
@exit /B 0

@REM -----------------------------------------------------------------------
:GetVSInstallDir
@set VSINSTALLDIR=
@call :GetVSInstallDirHelper32 HKLM > nul 2>&1
@if errorlevel 1 call :GetVSInstallDirHelper32 HKCU > nul 2>&1
@if errorlevel 1 call :GetVSInstallDirHelper64  HKLM > nul 2>&1
@if errorlevel 1 call :GetVSInstallDirHelper64  HKCU > nul 2>&1
@exit /B 0

:GetVSInstallDirHelper32
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Microsoft\VisualStudio\SxS\VS7" /v "11.0"') DO (
	@if "%%i"=="11.0" (
		@SET "VSINSTALLDIR=%%k"
	)
)
@if "%VSINSTALLDIR%"=="" exit /B 1
@exit /B 0

:GetVSInstallDirHelper64
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VS7" /v "11.0"') DO (
	@if "%%i"=="11.0" (
		@SET "VSINSTALLDIR=%%k"
	)
)
@if "%VSINSTALLDIR%"=="" exit /B 1
@exit /B 0

@REM -----------------------------------------------------------------------
:GetVCInstallDir
@set VCINSTALLDIR=
@call :GetVCInstallDirHelper32 HKLM > nul 2>&1
@if errorlevel 1 call :GetVCInstallDirHelper32 HKCU > nul 2>&1
@if errorlevel 1 call :GetVCInstallDirHelper64  HKLM > nul 2>&1
@if errorlevel 1 call :GetVCInstallDirHelper64  HKCU > nul 2>&1
@exit /B 0

:GetVCInstallDirHelper32
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Microsoft\VisualStudio\SxS\VC7" /v "11.0"') DO (
	@if "%%i"=="11.0" (
		@SET "VCINSTALLDIR=%%k"
	)
)
@if "%VCINSTALLDIR%"=="" exit /B 1
@exit /B 0

:GetVCInstallDirHelper64
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VC7" /v "11.0"') DO (
	@if "%%i"=="11.0" (
		@SET "VCINSTALLDIR=%%k"
	)
)
@if "%VCINSTALLDIR%"=="" exit /B 1
@exit /B 0

@REM -----------------------------------------------------------------------
:GetFrameworkDir32
@set FrameworkDir32=
@call :GetFrameworkDir32Helper32 HKLM > nul 2>&1
@if errorlevel 1 call :GetFrameworkDir32Helper32 HKCU > nul 2>&1
@if errorlevel 1 call :GetFrameworkDir32Helper64  HKLM > nul 2>&1
@if errorlevel 1 call :GetFrameworkDir32Helper64  HKCU > nul 2>&1
@exit /B 0

:GetFrameworkDir32Helper32
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Microsoft\VisualStudio\SxS\VC7" /v "FrameworkDir32"') DO (
	@if "%%i"=="FrameworkDir32" (
		@SET "FrameworkDIR32=%%k"
	)
)
@if "%FrameworkDir32%"=="" exit /B 1
@exit /B 0

:GetFrameworkDir32Helper64
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VC7" /v "FrameworkDir32"') DO (
	@if "%%i"=="FrameworkDir32" (
		@SET "FrameworkDIR32=%%k"
	)
)
@if "%FrameworkDIR32%"=="" exit /B 1
@exit /B 0

@REM -----------------------------------------------------------------------
:GetFrameworkDir64
@set FrameworkDir64=
@call :GetFrameworkDir64Helper32 HKLM > nul 2>&1
@if errorlevel 1 call :GetFrameworkDir64Helper32 HKCU > nul 2>&1
@if errorlevel 1 call :GetFrameworkDir64Helper64  HKLM > nul 2>&1
@if errorlevel 1 call :GetFrameworkDir64Helper64  HKCU > nul 2>&1
@exit /B 0

:GetFrameworkDir64Helper32
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Microsoft\VisualStudio\SxS\VC7" /v "FrameworkDir64"') DO (
	@if "%%i"=="FrameworkDir64" (
		@SET "FrameworkDIR64=%%k"
	)
)
@if "%FrameworkDIR64%"=="" exit /B 1
@exit /B 0

:GetFrameworkDir64Helper64
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VC7" /v "FrameworkDir64"') DO (
	@if "%%i"=="FrameworkDir64" (
		@SET "FrameworkDIR64=%%k"
	)
)
@if "%FrameworkDIR64%"=="" exit /B 1
@exit /B 0

@REM -----------------------------------------------------------------------
:GetFrameworkVer32
@set FrameworkVer32=
@call :GetFrameworkVer32Helper32 HKLM > nul 2>&1
@if errorlevel 1 call :GetFrameworkVer32Helper32 HKCU > nul 2>&1
@if errorlevel 1 call :GetFrameworkVer32Helper64  HKLM > nul 2>&1
@if errorlevel 1 call :GetFrameworkVer32Helper64  HKCU > nul 2>&1
@exit /B 0

:GetFrameworkVer32Helper32
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Microsoft\VisualStudio\SxS\VC7" /v "FrameworkVer32"') DO (
	@if "%%i"=="FrameworkVer32" (
		@SET "FrameworkVersion32=%%k"
	)
)
@if "%FrameworkVersion32%"=="" exit /B 1
@exit /B 0

:GetFrameworkVer32Helper64
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VC7" /v "FrameworkVer32"') DO (
	@if "%%i"=="FrameworkVer32" (
		@SET "FrameworkVersion32=%%k"
	)
)
@if "%FrameworkVersion32%"=="" exit /B 1
@exit /B 0

@REM -----------------------------------------------------------------------
:GetFrameworkVer64
@set FrameworkVer64=
@call :GetFrameworkVer64Helper32 HKLM > nul 2>&1
@if errorlevel 1 call :GetFrameworkVer64Helper32 HKCU > nul 2>&1
@if errorlevel 1 call :GetFrameworkVer64Helper64  HKLM > nul 2>&1
@if errorlevel 1 call :GetFrameworkVer64Helper64  HKCU > nul 2>&1
@exit /B 0

:GetFrameworkVer64Helper32
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Microsoft\VisualStudio\SxS\VC7" /v "FrameworkVer64"') DO (
	@if "%%i"=="FrameworkVer64" (
		@SET "FrameworkVersion64=%%k"
	)
)
@if "%FrameworkVersion64%"=="" exit /B 1
@exit /B 0

:GetFrameworkVer64Helper64
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VC7" /v "FrameworkVer64"') DO (
	@if "%%i"=="FrameworkVer64" (
		@SET "FrameworkVersion64=%%k"
	)
)
@if "%FrameworkVersion64%"=="" exit /B 1
@exit /B 0

@REM -----------------------------------------------------------------------
:end
