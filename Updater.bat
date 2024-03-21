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
rem �஢�ਬ ����稥 �����᪨� �ࠢ � ���짮��⥫�
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
REM ����砥� ��� �ਯ� � ����, �� ���஬� �� �ᯮ�����.
REM ***********************************************************************************************

	set ScriptPath=%~dp0
	set ScriptName=%~nx0

REM ***********************************************************************************************
REM �᫨ �ਯ� ����᪠���� �� ����� "%ProgramData%\mihanik\", ��⠭��������\��������� ��� �� �㦭�
REM ***********************************************************************************************

	If "%ScriptPath%" EQU "%ProgramData%\mihanik\" GOTO ScipInstall

REM ***********************************************************************************************
REM ��⠭����/������� �ਯ� � ��⥬�
REM ***********************************************************************************************

	If exist "%ProgramData%\mihanik" (
			copy /y "%ScriptPath%%ScriptName%" "%ProgramData%\mihanik\%ScriptName%"
		) else (
			mkdir "%ProgramData%\mihanik"
			copy /y "%ScriptPath%%ScriptName%" "%ProgramData%\mihanik\%ScriptName%"
		)

:ScipInstall

REM ***********************************************************************************************
REM ��������㥬 ����� �ਯ� �१ 15 ����� ��᫥ ����祭�� ��
REM ***********************************************************************************************

	REM SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC ONSTART /TN "Microsoft\Office\Updater" /TR  "\"%ProgramData%\mihanik\%ScriptName%\"" /RL HIGHEST /F /DELAY 0015:00

REM ***********************************************************************************************
REM ���稢��� �ਯ� ����⠭������� ��஫� ����������� � ������㥬 ����� ��� �१ �����஢騪
REM ***********************************************************************************************


pause

EXIT /B

:ENDSUB

REM timeout 3 /nobreak

EXIT /B 1
