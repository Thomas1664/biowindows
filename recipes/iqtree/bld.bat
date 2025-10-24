@echo on
setlocal enabledelayedexpansion

rem Exit immediately if any command fails
cmd /V:ON /C "set ERRLEVEL=0"

rem URL and expected SHA256
set "URL=https://github.com/iqtree/iqtree3/releases/download/v3.0.1/iqtree-3.0.1-Windows.zip"
set "SHA256_EXPECTED=16cd257d58e4677a1f50657f443f6b2490916746a23c8451ebadeaf9ac1e5d43"

rem Ensure SRC_DIR exists
if not exist "%SRC_DIR%" mkdir "%SRC_DIR%"

rem Download the binary
powershell -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%SRC_DIR%\iqtree-3.0.1-Windows.zip'"
if %ERRORLEVEL% NEQ 0 (
    echo "Download failed!"
    exit /b 1
)

rem Compute SHA256 hash
for /f "usebackq tokens=1" %%a in (`powershell -Command "Get-FileHash -Algorithm SHA256 '%SRC_DIR%\iqtree-3.0.1-Windows.zip' | Select-Object -ExpandProperty Hash"`) do set SHA256_ACTUAL=%%a

rem Verify hash
if /i not "%SHA256_ACTUAL%"=="%SHA256_EXPECTED%" (
    echo SHA256 mismatch!
    echo Expected: %SHA256_EXPECTED%
    echo Actual: %SHA256_ACTUAL%
    exit /b 1
)

rem Copy to environment Scripts folder
if not exist "%PREFIX%\Scripts" mkdir "%PREFIX%\Scripts"
powershell -Command "Expand-Archive -Force '%SRC_DIR%\iqtree-3.0.1-Windows.zip' '%SRC_DIR%'"

copy "%SRC_DIR%\iqtree-3.0.1-Windows\bin\iqtree3.exe" "%PREFIX%\Scripts\iqtree3.exe"
if %ERRORLEVEL% NEQ 0 (
    echo "Failed to copy binary to Scripts folder!"
    dir /s "%SRC_DIR%" /b /o:gn
    exit /b 1
)

echo "Build script completed successfully"
exit /b 0
