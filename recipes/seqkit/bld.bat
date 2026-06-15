@echo on
setlocal enabledelayedexpansion

rem Exit immediately if any command fails
cmd /V:ON /C "set ERRLEVEL=0"

rem URL and expected SHA256
set "URL=https://github.com/shenwei356/seqkit/releases/download/v2.13.0/seqkit_windows_amd64.exe.tar.gz"
set "SHA256_EXPECTED=789a11df5306ae9d8cc0ccc9a11b76b6b8f44c31e6cc3ba3e4bc13db5819b1dd"

rem Ensure SRC_DIR exists
if not exist "%SRC_DIR%" mkdir "%SRC_DIR%"

rem Download the binary
powershell -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%SRC_DIR%\seqkit_windows_amd64.exe.tar.gz'"
if %ERRORLEVEL% NEQ 0 (
    echo "Download failed!"
    exit /b 1
)

rem Compute SHA256 hash
for /f "usebackq tokens=1" %%a in (`powershell -Command "Get-FileHash -Algorithm SHA256 '%SRC_DIR%\seqkit_windows_amd64.exe.tar.gz' | Select-Object -ExpandProperty Hash"`) do set SHA256_ACTUAL=%%a

rem Verify hash
if /i not "%SHA256_ACTUAL%"=="%SHA256_EXPECTED%" (
    echo SHA256 mismatch!
    echo Expected: %SHA256_EXPECTED%
    echo Actual: %SHA256_ACTUAL%
    exit /b 1
)

rem Extract the tarball (tar is available on Windows 10+)
tar -xzf "%SRC_DIR%\seqkit_windows_amd64.exe.tar.gz" -C "%SRC_DIR%"
if %ERRORLEVEL% NEQ 0 (
    echo "Extraction failed!"
    exit /b 1
)

rem Copy to environment Scripts folder
if not exist "%PREFIX%\Scripts" mkdir "%PREFIX%\Scripts"

copy "%SRC_DIR%\seqkit.exe" "%PREFIX%\Scripts\seqkit.exe"
if %ERRORLEVEL% NEQ 0 (
    echo "Failed to copy binary to Scripts folder!"
    dir /s "%SRC_DIR%" /b /o:gn
    exit /b 1
)

echo "Build script completed successfully"
exit /b 0