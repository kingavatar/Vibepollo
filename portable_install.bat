@echo off
setlocal EnableDelayedExpansion

NET SESSION >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] This script must be run as Administrator to install drivers and firewall rules.
    pause
    exit /b 1
)

echo ========================================================
echo           Vibepollo Portable Setup Script
echo ========================================================
echo.
echo This script will:
echo   1. Add Windows Firewall rules for Vibepollo
echo   2. Check for ViGEmBus driver (required for gamepads)
echo.
pause

echo.
echo [1/2] Adding Firewall Rules...
if exist "scripts\add-firewall-rule.bat" (
    call "scripts\add-firewall-rule.bat"
    echo    - Firewall rules added.
) else (
    echo    - Firewall script not found!
)

echo.
echo [2/2] Checking ViGEmBus...
if exist "%ProgramFiles%\ViGEm Bus Driver\ViGEmBus.sys" (
    echo    - ViGEmBus appears to be installed.
) else (
    echo    [WARNING] ViGEmBus driver is MISSING. Gamepads will NOT work.
    echo    You must download and install it manually:
    echo    https://github.com/nefarius/ViGEmBus/releases/latest
    echo    (Look for ViGEmBus_Setup_x64.msi)
)

echo.
echo ========================================================
echo NOTE: Other scripts in the 'scripts' folder (install-service.bat)
echo are for installing Sunshine as a Windows Service.
echo This is optional and usually not needed for portable mode.
echo ========================================================
echo.
echo Setup complete! You can now run sunshine.exe.
pause
