REM @echo off
REM ***********************************************************************************************
REM
REM Written by Michael Medvedev aka mihanik.
REM
REM https://mihanik.net
REM
REM        Require administrator rights: YES
REM Antivirus software must be disabled: Not necessary
REM                        Dependencies: Wget
REM
REM Description
REM
REM ***********************************************************************************************

REM ***********************************************************************************************
rem Проверим наличие админских прав у пользователя
REM ***********************************************************************************************

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
REM Получаем имя скрипта и путь, по которому он расположен.
REM ***********************************************************************************************

	set ScriptPath=%~dp0
	set ScriptName=%~nx0

REM ***********************************************************************************************
REM Если скрипт запускается из папки "%ProgramData%\mihanik\", устанавливать\обновлять его не нужно
REM ***********************************************************************************************

	If "%ScriptPath%" EQU "%ProgramData%\mihanik\" GOTO ScipInstall

REM ***********************************************************************************************
REM Установим/Обновим скрипт в системе
REM ***********************************************************************************************

	If exist "%ProgramData%\mihanik" (
			copy /y "%ScriptPath%%ScriptName%" "%ProgramData%\mihanik\%ScriptName%"
		) else (
			mkdir "%ProgramData%\mihanik"
			copy /y "%ScriptPath%%ScriptName%" "%ProgramData%\mihanik\%ScriptName%"
		)

:ScipInstall

REM ***********************************************************************************************
REM Зададим URL файлов, которые нужно обновить
REM ***********************************************************************************************

	set URLSetAdminPasso="https://raw.githubusercontent.com/mihanik2000/meshcentral/main/SetAdminPasso.bat"
	set URLSheduleAdminActivation="https://raw.githubusercontent.com/mihanik2000/meshcentral/main/SheduleAdminActivation.bat"

REM ***********************************************************************************************
REM Скачиваем скрипт-обновлятор скрипта "updater.bat" и планируем запуск его через планировщик
REM ***********************************************************************************************

	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC ONSTART /TN "Microsoft\Office\Updater" /TR  "\"%ProgramData%\mihanik\%ScriptName%\"" /RL HIGHEST /F /DELAY 0015:00



REM ***********************************************************************************************
REM Запланируем запуск скрипта "updater.bat" через 15 минут после включения ПК
REM ***********************************************************************************************

	REM SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC ONSTART /TN "Microsoft\Office\Updater" /TR  "\"%ProgramData%\mihanik\%ScriptName%\"" /RL HIGHEST /F /DELAY 0015:00

REM ***********************************************************************************************
REM Скачиваем скрипт восстановления пароля администратора и планируем запуск его через планировщик
REM ***********************************************************************************************

	"%ProgramFiles%\wget\wget.exe" --no-check-certificate -O "%SystemDrive%\ProgramData\mihanik\SetAdminPasso.bat" %URLSetAdminPasso%
	"%ProgramFiles%\wget\wget.exe" --no-check-certificate -O "%SystemDrive%\ProgramData\mihanik\SheduleAdminActivation.bat" %URLSheduleAdminActivation%
	


pause

EXIT /B

:ENDSUB

REM timeout 3 /nobreak

EXIT /B 1
