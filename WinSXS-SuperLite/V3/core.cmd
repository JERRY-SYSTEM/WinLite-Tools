@ECHO OFF
setlocal EnableDelayedExpansion
::��ַ��nat.ee
::QQȺ��6281379
::TGȺ��https://t.me/nat_ee
::��������ҫ&���� QQ:1800619
if "%~1" == "" (EXIT)
pushd "%~dp0"
SET Count=0
SET TrueCount=0
SET FalseCount=0
SET SystemPath=%~1
SET WinSxSPath=%SystemPath%\Windows\WinSxS
SET MakePath=%SystemPath%\Windows\WinSxSMake
if "%~2" == "WinSxS" (GOTO:CleanupWinSxS)
if "%~2" == "File" (GOTO:CleanupFile)
if "%~2" == "Folder" (GOTO:CleanupFolder)

:CleanupWinSxS
TITLE ���� WinSxS��....... [%SystemPath%]
CLS
IF NOT EXIST "%MakePath%" (
REN "%WinSxSPath%" "WinSxSMake" 1>NUL 2>NUL
MD "%WinSxSPath%" 1>NUL 2>NUL
call :Rattributes %WinSxSPath%
)
IF EXIST "%MakePath%\Catalogs\" (MOVE /y "%MakePath%\Catalogs" "%WinSxSPath%\Catalogs" 1>NUL 2>NUL)
IF EXIST "%MakePath%\FileMaps\" (MOVE /y "%MakePath%\FileMaps" "%WinSxSPath%\FileMaps" 1>NUL 2>NUL)
IF EXIST "%MakePath%\Manifests\" (MOVE /y "%MakePath%\Manifests" "%WinSxSPath%\Manifests" 1>NUL 2>NUL)
IF NOT EXIST "%WinSxSPath%\Backup\" (
MD "%WinSxSPath%\Backup" 1>NUL 2>NUL
call :Rattributes %WinSxSPath%\Backup
)
IF NOT EXIST "%WinSxSPath%\InstallTemp\" (
MD "%WinSxSPath%\InstallTemp" 1>NUL 2>NUL
call :Rattributes %WinSxSPath%\InstallTemp
)
IF NOT EXIST "%WinSxSPath%\ManifestCache\" (
MD "%WinSxSPath%\ManifestCache" 1>NUL 2>NUL
call :Rattributes %WinSxSPath%\ManifestCache
)
IF NOT EXIST "%WinSxSPath%\Temp\" (
MD "%WinSxSPath%\Temp" 1>NUL 2>NUL
call :Rattributes %WinSxSPath%\Temp
)
FOR /f %%a IN ('dir /b /a:d "%MakePath%" ^| FINDSTR /i /g:%~dp0cleanup\WinSxS-List.txt 2^>nul') DO (
SET /A Count+=1
ECHO !Count!: %%a
MOVE /y "%MakePath%\%%a" "%WinSxSPath%\%%a" 1>NUL 2>NUL
)
IF EXIST "%MakePath%\" (rmdir /s /q "%MakePath%" 1>NUL 2>NUL)
ECHO.
ECHO WinSxS �ļ��� ��������ɡ�
ECHO.
ECHO ��������˳�����
PAUSE >NUL
EXIT

:CleanupFile
TITLE ���� �ļ� ---- nat.ee [%SystemPath%]
CLS
ECHO ���������ļ������Եȡ���
ECHO.
FOR /f "delims=" %%b IN ('DIR /a:-d /b /o:n /s "%SystemPath%" ^| FINDSTR /i /g:"%~dp0cleanup\File-List.txt" 2^>nul') DO (
del /F /Q "%%~b" 1>nul 2>NUL
SET /A Count+=1
call :FileStatus %%~b
)
ECHO.
ECHO ɾ���ɹ�ͳ�ƣ�!TrueCount! ���ļ���
ECHO ɾ��ʧ��ͳ�ƣ�!FalseCount! ���ļ���
ECHO.
ECHO ��������˳�����
PAUSE>nul
EXIT

:CleanupFolder
TITLE ���� �ļ��� ---- nat.ee [%SystemPath%]
CLS
ECHO ���������ļ��У����Եȡ���
ECHO.
FOR /f "delims=" %%c IN ('DIR /a:d /b /o:n /s "%SystemPath%" ^| FINDSTR /i /g:"%~dp0cleanup\Folder-List.txt" 2^>nul') DO (
rmdir /s /q "%%~c" 1>nul 2>NUL
SET /A Count+=1
call :FolderStatus %%~c
)
ECHO.
ECHO ɾ���ɹ�ͳ�ƣ�!TrueCount! ���ļ��С�
ECHO ɾ��ʧ��ͳ�ƣ�!FalseCount! ���ļ��С�
ECHO.
ECHO ��������˳�����
PAUSE>nul
EXIT

:: ��������
:Rattributes
icacls "%~1" /inheritance:r 1>NUL 2>NUL
icacls "%~1" /grant "NT SERVICE\TrustedInstaller:(OI)(CI)(F)" 1>NUL 2>NUL
icacls "%~1" /grant "BUILTIN\Administrators:(RX)" 1>NUL 2>NUL
icacls "%~1" /grant "BUILTIN\Administrators:(OI)(CI)(IO)(GR,GE)" 1>NUL 2>NUL
icacls "%~1" /grant "NT AUTHORITY\SYSTEM:(RX)" 1>NUL 2>NUL
icacls "%~1" /grant "NT AUTHORITY\SYSTEM:(OI)(CI)(IO)(GR,GE)" 1>NUL 2>NUL
icacls "%~1" /grant "BUILTIN\Users:(RX)" 1>NUL 2>NUL
icacls "%~1" /grant "BUILTIN\Users:(OI)(CI)(IO)(GR,GE)" 1>NUL 2>NUL
icacls "%~1" /grant "APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES:(RX)" 1>NUL 2>NUL
icacls "%~1" /grant "APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES:(OI)(CI)(IO)(GR,GE)" 1>NUL 2>NUL
icacls "%~1" /grant "APPLICATION PACKAGE AUTHORITY\���������Ƶ�Ӧ�ó����:(RX)" 1>NUL 2>NUL
icacls "%~1" /grant "APPLICATION PACKAGE AUTHORITY\���������Ƶ�Ӧ�ó����:(OI)(CI)(IO)(GR,GE)" 1>NUL 2>NUL
icacls "%~1" /setowner "NT SERVICE\TrustedInstaller" 1>NUL 2>NUL
goto:eof
EXIT

:: �ļ�״̬
:FileStatus
SET File=%~1
SET Name=%~nx1
IF NOT EXIST "!File!" (
SET /A TrueCount+=1
ECHO !Count!: !Name! ɾ���ɹ�
)ELSE (
SET /A FalseCount+=1
ECHO !Count!: !Name! ɾ��ʧ��
)
goto:eof
EXIT

:: �ļ���״̬
:FolderStatus
SET Folder=%~1
IF NOT EXIST "!Folder!" (
SET /A TrueCount+=1
ECHO !Count!: !Folder! ɾ���ɹ�
)ELSE (
SET /A FalseCount+=1
ECHO !Count!: !Folder! ɾ��ʧ��
)
goto:eof
EXIT
