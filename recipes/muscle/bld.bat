@echo on
echo "Hello World"
setlocal enabledelayedexpansion

echo "Hello World"
rem Exit immediately if any command fails
cmd /V:ON /C "set ERRLEVEL=0"

rem URL and expected SHA256
set "URL=https://github.com/rcedgar/muscle/releases/download/v5.3/muscle-win64.v5.3.exe"
set "SHA256_EXPECTED=a86637db99deb3efa1cb6762c4e3160ca33644608270eb167e4214f1f9409711"

rem Ensure SRC_DIR exists
if not exist "%SRC_DIR%" mkdir "%SRC_DIR%"

rem Download the binary
powershell -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%SRC_DIR%\muscle.exe'"
if %ERRORLEVEL% NEQ 0 (
    echo "Download failed!"
    exit /b 1
)

rem Compute SHA256 hash
for /f "usebackq tokens=1" %%a in (`powershell -Command "Get-FileHash -Algorithm SHA256 '%SRC_DIR%\muscle.exe' | Select-Object -ExpandProperty Hash"`) do set SHA256_ACTUAL=%%a

rem Verify hash
if /i not "%SHA256_ACTUAL%"=="%SHA256_EXPECTED%" (
    echo SHA256 mismatch!
    echo Expected: %SHA256_EXPECTED%
    echo Actual: %SHA256_ACTUAL%
    exit /b 1
)

rem Copy to environment Scripts folder
if not exist "%PREFIX%\Scripts" mkdir "%PREFIX%\Scripts"
copy "%SRC_DIR%\muscle.exe" "%PREFIX%\Scripts\muscle.exe"
if %ERRORLEVEL% NEQ 0 (
    echo "Failed to copy binary to Scripts folder!"
    exit /b 1
)

echo "Build script completed successfully"
exit /b 0
