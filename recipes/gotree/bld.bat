@echo on
setlocal enabledelayedexpansion

rem Exit immediately if any command fails
cmd /V:ON /C "set ERRLEVEL=0"

rem URL and expected SHA256
set "URL=https://github.com/evolbioinfo/gotree/releases/download/v0.5.1/gotree_v0.5.1_amd64.exe"
set "SHA256_EXPECTED=d33000f7cce8f489c160f8b0450aa0d4fb47fb9b8bcb6a4b4c3052cd9187f272"

rem Ensure SRC_DIR exists
if not exist "%SRC_DIR%" mkdir "%SRC_DIR%"

rem Download the binary
powershell -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%SRC_DIR%\gotree_v0.5.1_amd64.exe'"
if %ERRORLEVEL% NEQ 0 (
    echo "Download failed!"
    exit /b 1
)

rem Compute SHA256 hash
for /f "usebackq tokens=1" %%a in (`powershell -Command "Get-FileHash -Algorithm SHA256 '%SRC_DIR%\gotree_v0.5.1_amd64.exe' | Select-Object -ExpandProperty Hash"`) do set SHA256_ACTUAL=%%a

rem Verify hash
if /i not "%SHA256_ACTUAL%"=="%SHA256_EXPECTED%" (
    echo SHA256 mismatch!
    echo Expected: %SHA256_EXPECTED%
    echo Actual: %SHA256_ACTUAL%
    exit /b 1
)

rem Copy to environment Scripts folder
if not exist "%PREFIX%\Scripts" mkdir "%PREFIX%\Scripts"

copy "%SRC_DIR%\gotree_v0.5.1_amd64.exe" "%PREFIX%\Scripts\gotree.exe"
if %ERRORLEVEL% NEQ 0 (
    echo "Failed to copy binary to Scripts folder!"
    exit /b 1
)

echo "Build script completed successfully"
exit /b 0