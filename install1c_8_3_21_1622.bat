@echo off
REM ****************************************
REM
REM Written by Michael Medvedev aka mihanik.
REM
REM https://mihanik.net
REM
REM        Require administrator rights: YES
REM Antivirus software must be disabled: NO
REM
REM Скрипт установки Клиента 1С:Предприятие весрии 8.3.21.1622
REM
REM ****************************************

REM Получаем имя папки, в которой расположен скрипт

set ScriptPath=%~dp0

REM Проверяем наличие у пользователя админских прав...

SET HasAdminRights=0

FOR /F %%i IN ('WHOAMI /PRIV /NH') DO (
    IF "%%i"=="SeTakeOwnershipPrivilege" SET HasAdminRights=1
)

IF NOT %HasAdminRights%==1 (
    ECHO .
    ECHO You need administrator rights to run!!!
    ECHO .
    GOTO END
)

REM Папка для временного хранения установичных или скачанных файлов

set MyFolder=%SystemRoot%\TMP\Mihanikus
mkdir "%MyFolder%"
cd "%MyFolder%"

REM Проверяем наличие утилиты wget

SET WgetPath=C:\Program Files\Wget\wget.exe
if NOT exist "%WgetPath%" (
    ECHO .
    ECHO Wget not found!
	ECHO Install Wget first!
    ECHO .
    GOTO END
)

ECHO .
ECHO Wget found!!!
ECHO .

REM Проверяем наличие 7-ZIP

SET ZipPath=C:/Program Files/7-Zip/7z.exe
if NOT exist "%ZipPath%" (
    ECHO .
    ECHO 7-ZIP not found!!!
    ECHO .
    GOTO INSTALL7ZIP
)

ECHO .
ECHO 7-ZIP found!!!
ECHO .

GOTO INSTALL1C

:INSTALL7ZIP

REM Пробуем установить 7-ZIP

SET Zip86URL=https://meshcentral.mihanik.net/userfiles/mihanik/7z2201.msi?download=1
SET Zip64URL=https://meshcentral.mihanik.net/userfiles/mihanik/7z2201-x64.msi?download=1

If exist "%SystemDrive%\Program Files (x86)" (
	"%WgetPath%" --no-check-certificate -O "%MyFolder%\7zip.msi" %Zip64URL%
	Start /wait 7zip.msi /qn
) else (
	"%WgetPath%" --no-check-certificate -O "%MyFolder%\7zip.msi" %Zip86URL%
	Start /wait 7zip.msi /qn
)

:INSTALL1C

set Link1C=https://meshcentral.mihanik.net/userfiles/mihanik/1C/windows_8_3_21_1622.rar?download=1
rmdir /q /s "%MyFolder%\1c"
del /q "%MyFolder%\1c.rar"

"%WgetPath%" --no-check-certificate -O "%MyFolder%\1c.rar" %Link1C%

"%ZipPath%" x "%MyFolder%\1c.rar" -o"%MyFolder%\1c" -y -r

cd "%MyFolder%\1c"

start "1C " /wait "1CEnterprise 8.msi" /quiet TRANSFORMS=adminstallrelogon.mst;1049.mst DESIGNERALLCLIENTS=1 THICKCLIENT=1 THINCLIENTFILE=1 THINCLIENT=1 WEBSERVEREXT=0 SERVER=0 CONFREPOSSERVER=0 CONVERTER77=0 SERVERCLIENT=0 LANGUAGES=RU

:END

timeout 5  >> nul

REM shutdown -r -f -t 00

EXIT /B
