set __VSCMD_script_err_count=0
if "%VSCMD_TEST%" NEQ "" goto :test
if "%VSCMD_ARG_CLEAN_ENV%" NEQ "" goto :clean_env

@REM ------------------------------------------------------------------------
:start

if /I "%VSCMD_ARG_HOST_ARCH%" == "x86" (
    if not exist "%VSINSTALLDIR%VC\Tools\Llvm\bin\clang-cl.exe" goto :error_setting_path
    set "PATH=%PATH%;%VSINSTALLDIR%VC\Tools\Llvm\bin"
    goto :end
)

if /I "%VSCMD_ARG_HOST_ARCH%" == "x64" (
    if not exist "%VSINSTALLDIR%VC\Tools\Llvm\x64\bin\clang-cl.exe" goto :error_setting_path
    set "PATH=%PATH%;%VSINSTALLDIR%VC\Tools\Llvm\x64\bin"
    goto :end
)

:error_setting_path
SET ERRORLEVEL=1
exit /B 1

goto :end

@REM ------------------------------------------------------------------------
:test

setlocal

@REM -- Check for clang-cl.exe, which is installed to the installation specific path --
where clang-cl.exe
if "%ERRORLEVEL%" NEQ "0" (
    @echo [ERROR:%~nx0] 'where clang-cl.exe' failed
    set /A __VSCMD_script_err_count=__VSCMD_script_err_count+1
)

@REM exports the value of __VSCMD_script_err_count from the 'setlocal' region
endlocal & set __VSCMD_script_err_count=%__VSCMD_script_err_count%

goto :end

@REM ------------------------------------------------------------------------
:clean_env

@REM this script only modifies PATH, so additional clean-up is not required.

goto :end

@REM ------------------------------------------------------------------------
:end

@REM return value other than 0 if tests failed.
if "%__VSCMD_script_err_count%" NEQ "0" (
   set __VSCMD_script_err_count=
   exit /B 1
)

set __VSCMD_script_err_count=
exit /B 0
