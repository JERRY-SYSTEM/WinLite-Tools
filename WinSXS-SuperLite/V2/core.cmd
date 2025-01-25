@ECHO Off
::网址：nat.ee
::QQ群：6281379
::TG群：https://t.me/nat_ee
::批处理：荣耀&制作 QQ:1800619
if "%~1" == "" (EXIT)
pushd "%~dp0"
SET SystemPath=%~1

CLS
TITLE 删除WinSxS文件夹途中,请勿退出此窗口。
FOR /f %%a IN ('dir /b /a:d "%SystemPath%\Windows\WinSxS" ^| FINDSTR /i /v /g:%~dp0winsxslist.txt 2^>nul') DO (call :DeleteFolder %%a)

TITLE 删除WinSxS文件夹完成。
color 2F
ECHO.
ECHO 删除完成。
ECHO.
ECHO 按任意键退出……
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