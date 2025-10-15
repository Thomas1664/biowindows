@echo on
setlocal enabledelayedexpansion
mkdir %PREFIX%\Scripts
copy %SRC_DIR%\muscle-win64.v5.3.exe %PREFIX%\Scripts\muscle.exe
