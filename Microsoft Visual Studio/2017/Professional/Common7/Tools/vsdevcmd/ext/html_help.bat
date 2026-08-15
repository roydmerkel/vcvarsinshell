
if "%VSCMD_TEST%" NEQ "" goto :test
if "%VSCMD_ARG_CLEAN_ENV%" NEQ "" goto :clean_env

if exist "%ProgramFiles%\HTML Help Workshop" set "HTMLHelpDir=%ProgramFiles%\HTML Help Workshop"

if "%ProgramFiles%" NEQ "%ProgramFiles(x86)%" (
    if exist "%ProgramFiles(x86)%\HTML Help Workshop" set "HTMLHelpDir=%ProgramFiles(x86)%\HTML Help Workshop"
)

if NOT "%HTMLHelpDir%"=="" set "PATH=%HTMLHelpDir%;%PATH%"


goto :end

@REM -----------------------------------------------------------------------
:test

set __VSCMD_TEST_FailCount=0

setlocal

if NOT "%HTMLHelpDir%"=="" (
    @echo [TEST:%~nx0] Checking for hhc.exe...
    where hhc.exe > NUL 2>&1
    if "%ERRORLEVEL%" NEQ "0" (
    @echo [ERROR:%~nx0] failed to find hhc.exe
    set /A __VSCMD_TEST_FailCount=__VSCMD_TEST_FailCount+1
    )
) else (
    @echo [TEST:%~nx0] HTML Help Workshop not installed - skipping test.
)
endlocal & set __VSCMD_TEST_FailCount=%__VSCMD_TEST_FailCount%

@REM return value other than 0 if tests failed.
if "%__VSCMD_TEST_FailCount%" NEQ "0" (
   set __VSCMD_Test_FailCount=
   exit /B 1
)

set __VSCMD_Test_FailCount=
exit /B 0

@REM -----------------------------------------------------------------------
:clean_env
set HTMLHelpDir=
@REM This script sets PATH for which -clean_env is handled by vsdevcmd.bat.
goto :end

@REM -----------------------------------------------------------------------
:end

exit /B 0