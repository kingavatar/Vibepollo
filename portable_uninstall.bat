@echo off
setlocal EnableDelayedExpansion

NET SESSION >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] This script must be run as Administrator to remove drivers.
    pause
    exit /b 1
)

echo ========================================================
echo           Vibepollo Portable Cleanup Script
echo ========================================================
echo.
echo [WARNING] This will:
echo   1. Force remove the SudoVDA virtual display driver
echo   2. Delete any potential Vibepollo registry keys
echo   3. Wipe this entire folder (except this script)
echo.
set /p "Confirm=Type 'YES' to proceed: "
if /i not "%Confirm%"=="YES" (
    echo Cancelled.
    pause
    exit /b 0
)

echo.
echo [1/3] Removing SudoVDA Driver...
pushd "%~dp0"
if exist "drivers\sudovda\nefconc.exe" (
    "drivers\sudovda\nefconc.exe" --remove-device-node --hardware-id root\sudomaker\sudovda --class-guid "4D36E968-E325-11CE-BFC1-08002BE10318" >nul 2>&1
    if !errorlevel! equ 0 (
        echo    - Driver removed successfully.
    ) else (
        echo    - Driver removal skipped or failed (might not be installed).
    )
) else (
    echo    - Driver tool not found, skipping.
)
popd

echo.
echo [2/4] Removing Firewall Rules...
if exist "scripts\delete-firewall-rule.bat" (
    call "scripts\delete-firewall-rule.bat" >nul 2>&1
    echo    - Firewall rules removed.
)

echo.
echo [3/4] Cleaning Registry...
reg delete "HKCU\Software\Vibepollo" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Vibepollo" /f >nul 2>&1
echo    - Registry keys cleaned (if any existed).

echo.
echo [4/4] Deleting Files...
cd /d "%~dp0"
REM Delete all files in current dir except this script
for %%F in (*) do (
    if /i not "%%F"=="%~nx0" (
        del /f /q "%%F" >nul 2>&1
    )
)
REM Delete all subdirectories
for /d %%D in (*) do (
    rd /s /q "%%D" >nul 2>&1
)

echo.
echo Done. You can now delete this script file manually.
pause
