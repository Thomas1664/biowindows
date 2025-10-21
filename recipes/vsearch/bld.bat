@echo on
setlocal enabledelayedexpansion

rem Exit immediately if any command fails
cmd /V:ON /C "set ERRLEVEL=0"

rem URL and expected SHA256
set "URL=https://github.com/torognes/vsearch/releases/download/v2.30.0/vsearch-2.30.0-win-x86_64.zip"
set "SHA256_EXPECTED=dc2ce52bd032068a0f728235f15ed0ed753a05c2a3a04f1e633cea6cb428539c"

rem Ensure SRC_DIR exists
if not exist "%SRC_DIR%" mkdir "%SRC_DIR%"

rem Download the binary
powershell -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%SRC_DIR%\vsearch-2.30.0-win-x86_64.zip'"
if %ERRORLEVEL% NEQ 0 (
    echo "Download failed!"
    exit /b 1
)

rem Compute SHA256 hash
for /f "usebackq tokens=1" %%a in (`powershell -Command "Get-FileHash -Algorithm SHA256 '%SRC_DIR%\vsearch-2.30.0-win-x86_64.zip' | Select-Object -ExpandProperty Hash"`) do set SHA256_ACTUAL=%%a

rem Verify hash
if /i not "%SHA256_ACTUAL%"=="%SHA256_EXPECTED%" (
    echo SHA256 mismatch!
    echo Expected: %SHA256_EXPECTED%
    echo Actual: %SHA256_ACTUAL%
    exit /b 1
)

rem Copy to environment Scripts folder
if not exist "%PREFIX%\Scripts" mkdir "%PREFIX%\Scripts"
powershell -Command "Expand-Archive -Force '%SRC_DIR%\vsearch-2.30.0-win-x86_64.zip' '%SRC_DIR%\vsearch'"

copy "%SRC_DIR%\vsearch\bin\vsearch.exe" "%PREFIX%\Scripts\vsearch.exe"
if %ERRORLEVEL% NEQ 0 (
    echo "Failed to copy binary to Scripts folder!"
    dir /s "%SRC_DIR%" /b /o:gn
    exit /b 1
)

echo "Build script completed successfully"
exit /b 0
