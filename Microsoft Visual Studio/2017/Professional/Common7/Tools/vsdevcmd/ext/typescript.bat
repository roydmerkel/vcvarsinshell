


@REM setup an error counter local to this script.
set __script_error=0

if "%VSCMD_TEST%" NEQ "" goto :test
if "%VSCMD_ARG_CLEAN_ENV%" NEQ "" goto :clean_env

@REM Add path to TypeScript Compiler
@REM "\\" in the paths are required to escape the '<' character in the template.
if exist "%ProgramFiles%\Microsoft SDKs\TypeScript\3.1" (
    set "PATH=%ProgramFiles%\Microsoft SDKs\TypeScript\3.1;%PATH%"
    set _TypeScript_Found=1
)
if exist "%ProgramFiles(x86)%\Microsoft SDKs\TypeScript\3.1" (
    set "PATH=%ProgramFiles(x86)%\Microsoft SDKs\TypeScript\3.1;%PATH%"
    set _TypeScript_Found=1
)

@REM Report error if the TypeScript installation directory could not be found.
if "%_TypeScript_Found%" NEQ "1" (
    @echo [ERROR:%~nx0] TypeScript was not added to PATH since a valid installation was not found
    set /A __script_error=__script_error+1
)
set _TypeScript_Found=

goto :end

@REM ------------------------------------------------------------------------
:test

setlocal

set __test_error=0

@echo [TEST:%~nx0] Checking for tsc.exe...
where tsc.exe > NUL 2>&1
if "%ERRORLEVEL%" NEQ "0" (
    @echo [ERROR:%~nx0] 'where tsc.exe' failed
    set /A __test_error=__test_error+1
)

endlocal & set /A __script_error=__script_error+%__test_error%

goto :end

@REM ------------------------------------------------------------------------
:clean_env

@REM This script only updates PATH, so no action required in :clean_env

@REM ------------------------------------------------------------------------
:end

if "%__script_error%" NEQ "0" (
   set __script_error=
   exit /B 1
)

set __script_error=
exit /B 0
