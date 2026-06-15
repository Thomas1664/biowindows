@echo on
setlocal enabledelayedexpansion

rem Exit immediately if any command fails
cmd /V:ON /C "set ERRLEVEL=0"

rem URL and expected SHA256
set "URL=https://github.com/evolbioinfo/goalign/releases/download/v0.4.0/goalign_v0.4.0_amd64.exe"
set "SHA256_EXPECTED=1b3a94cdc0f4fdcfcb3980bdfa933372e26ae6c1f9784d1c7256b9acad2f2d33"

rem Ensure SRC_DIR exists
if not exist "%SRC_DIR%" mkdir "%SRC_DIR%"

rem Download the binary
powershell -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%SRC_DIR%\goalign_v0.4.0_amd64.exe'"
if %ERRORLEVEL% NEQ 0 (
    echo "Download failed!"
    exit /b 1
)

rem Compute SHA256 hash
for /f "usebackq tokens=1" %%a in (`powershell -Command "Get-FileHash -Algorithm SHA256 '%SRC_DIR%\goalign_v0.4.0_amd64.exe' | Select-Object -ExpandProperty Hash"`) do set SHA256_ACTUAL=%%a

rem Verify hash
if /i not "%SHA256_ACTUAL%"=="%SHA256_EXPECTED%" (
    echo SHA256 mismatch!
    echo Expected: %SHA256_EXPECTED%
    echo Actual: %SHA256_ACTUAL%
    exit /b 1
)

rem Copy to environment Scripts folder
if not exist "%PREFIX%\Scripts" mkdir "%PREFIX%\Scripts"

copy "%SRC_DIR%\goalign_v0.4.0_amd64.exe" "%PREFIX%\Scripts\goalign.exe"
if %ERRORLEVEL% NEQ 0 (
    echo "Failed to copy binary to Scripts folder!"
    exit /b 1
)

echo "Build script completed successfully"
exit /b 0