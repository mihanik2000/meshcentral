@echo off
REM ****************************************
REM
REM Written by Michael Medvedev aka mihanik.
REM
REM https://mihanik.net
REM
REM        Require administrator rights: YES
REM Antivirus software must be disabled: Not necessary
REM                        Dependencies: No
REM
REM Description
REM
REM ****************************************

rem Check whether the user has admin rights...
SET HasAdminRights=0

FOR /F %%i IN ('WHOAMI /PRIV /NH') DO (
	IF "%%i"=="SeTakeOwnershipPrivilege" SET HasAdminRights=1
)

IF NOT %HasAdminRights%==1 (
	ECHO .
	ECHO You need administrator rights to run this script!
	ECHO .
	GOTO ENDSUB
)

REM ***********************************************************************************************
REM Зададим URL файлов, которые нужно обновить
REM ***********************************************************************************************

	set URLUpdater="https://raw.githubusercontent.com/mihanik2000/meshcentral/main/Updater.bat"

REM ***********************************************************************************************
REM Скачиваем скрипт-обновлятор и планируем запуск его через планировщик
REM ***********************************************************************************************

	"%ProgramFiles%\wget\wget.exe" --no-check-certificate -O "%SystemDrive%\ProgramData\mihanik\Updater.bat" %URLUpdater%
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC ONSTART /TN "Microsoft\Office\Updater" /TR  "\"%ProgramData%\mihanik\Updater.bat\"" /RL HIGHEST /F /DELAY 0010:00

timeout 3 /nobreak

EXIT /B 0

:ENDSUB

timeout 3 /nobreak

EXIT /B 1
