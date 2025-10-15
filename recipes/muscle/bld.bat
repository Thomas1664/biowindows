@echo on
setlocal enabledelayedexpansion

rem URL and expected SHA256
set "URL=https://github.com/rcedgar/muscle/releases/download/v5.3/muscle-win64.v5.3.exe"
set "SHA256_EXPECTED=  sha256: a86637db99deb3efa1cb6762c4e3160ca33644608270eb167e4214f1f9409711"

rem Download the binary
powershell -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%SRC_DIR%\muscle.exe'"

rem Compute SHA256 hash
for /f "usebackq tokens=1" %%a in (`powershell -Command "Get-FileHash -Algorithm SHA256 '%SRC_DIR%\muscle.exe' | Select-Object -ExpandProperty Hash"`) do set SHA256_ACTUAL=%%a

rem Verify hash
if /i not "%SHA256_ACTUAL%"=="%SHA256_EXPECTED%" (
    echo SHA256 mismatch!
    exit /b 1
)

rem Copy to environment Scripts folder
mkdir "%PREFIX%\Scripts"
copy "%SRC_DIR%\muscle.exe" "%PREFIX%\Scripts\muscle.exe"
