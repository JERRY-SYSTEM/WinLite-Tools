@ECHO Off
::��ַ��nat.ee
::QQȺ��6281379
::TGȺ��https://t.me/nat_ee
::��������ҫ&���� QQ:1800619
if "%~1" == "" (EXIT)
pushd "%~dp0"
SET SystemPath=%~1

CLS
TITLE ɾ��WinSxS�ļ���;��,�����˳��˴��ڡ�
FOR /f %%a IN ('dir /b /a:d "%SystemPath%\Windows\WinSxS" ^| FINDSTR /i /v /g:%~dp0winsxslist.txt 2^>nul') DO (call :DeleteFolder %%a)

TITLE ɾ��WinSxS�ļ�����ɡ�
color 2F
ECHO.
ECHO ɾ����ɡ�
ECHO.
ECHO ��������˳�����
PAUSE >NUL
EXIT

:DeleteFolder
color 47
IF "%~1" == "Backup" (goto:eof)
IF "%~1" == "Catalogs" (goto:eof)
IF "%~1" == "FileMaps" (goto:eof)
IF "%~1" == "InstallTemp" (goto:eof)
IF "%~1" == "ManifestCache" (goto:eof)
IF "%~1" == "Manifests" (goto:eof)
IF "%~1" == "Temp" (goto:eof)
ECHO %~1
rmdir /s /q "%SystemPath%\Windows\WinSxS\%~1"
goto:eof