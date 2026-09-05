: << 'CMDBLOCK'
@echo off
setlocal DisableDelayedExpansion
REM Polyglot dispatcher adapted from obra/superpowers: cmd.exe runs this
REM block; Bash skips it. Keep hook names extensionless to avoid .sh autodetection.
if "%~1"=="" goto missing_script
set "ADAPTIVE_HOOK_DIR=%~dp0"
if exist "%ProgramFiles%\Git\bin\bash.exe" goto git_bash
if exist "%ProgramFiles(x86)%\Git\bin\bash.exe" goto git_bash_x86
where bash.exe >nul 2>nul
if errorlevel 1 goto missing_bash
bash.exe "%ADAPTIVE_HOOK_DIR%%~1" %2 %3 %4 %5 %6 %7 %8 %9
exit /b %ERRORLEVEL%

:git_bash
"%ProgramFiles%\Git\bin\bash.exe" "%ADAPTIVE_HOOK_DIR%%~1" %2 %3 %4 %5 %6 %7 %8 %9
exit /b %ERRORLEVEL%

:git_bash_x86
"%ProgramFiles(x86)%\Git\bin\bash.exe" "%ADAPTIVE_HOOK_DIR%%~1" %2 %3 %4 %5 %6 %7 %8 %9
exit /b %ERRORLEVEL%

:missing_script
echo run-hook.cmd: missing script name >&2
exit /b 1

:missing_bash
echo run-hook.cmd: install Git for Windows or put Git Bash on PATH >&2
exit /b 1
CMDBLOCK

set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo 'run-hook.cmd: missing script name' >&2
  exit 1
fi
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_NAME="$1"
shift
if [[ ! -f "$SCRIPT_DIR/$SCRIPT_NAME" ]]; then
  echo "run-hook.cmd: no such hook script: $SCRIPT_NAME" >&2
  exit 1
fi
exec bash "$SCRIPT_DIR/$SCRIPT_NAME" "$@"
