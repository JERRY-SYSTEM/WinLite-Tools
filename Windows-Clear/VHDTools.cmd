@echo OFF
::��ַ��nat.ee
::��������ҫ&���� QQ:1800619
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
if exist %tmp%\vhdconf (del /f /q %tmp%\vhdconf)
title 
mode con: cols=28 lines=10
color 2F
pushd "%~dp0"
for /f %%i in ('dir /b %~dp0vhd\^|findstr "^.*\.vhd$"') do (set vhdfile=%%i)

ECHO;%~0|find " "&&GOTO:errdir

::���˵�
:menu
cls
echo.
echo 1.���� %vhdfile%
echo.
echo 2.���� %vhdfile%
echo.
echo 3.���� VHD
echo.
echo 4.��ʽ�� %vhdfile%
echo.
choice /C:1234 /N /M "���������ѡ��[1,2,3,4]"��
if errorlevel 4 goto:vhdformat
if errorlevel 3 goto:vhdadd
if errorlevel 2 goto:vhdseparate
if errorlevel 1 goto:vhdmount

::����
:vhdmount
(
echo SELECT VDISK FILE= "%~dp0vhd\%vhdfile%"
echo ATTACH VDISK NOERR
echo LIST DISK
)>%tmp%\vhdconf
DISKPART /s %tmp%\vhdconf >nul
EXIT

::����
:vhdseparate
(
echo SELECT VDISK FILE= "%~dp0vhd\%vhdfile%"
echo ATTACH VDISK NOERR
echo DETACH VDISK
echo LIST DISK
)>%tmp%\vhdconf
DISKPART /s %tmp%\vhdconf >nul
EXIT

::����
:vhdadd
cls
echo ����VHD����Ӳ��
ECHO ���س���(Enter)
echo.
set /p newfile=�ļ����ƣ�
echo.
set /p value=Ӳ�̴�С(G):
ECHO.
ECHO ���ڴ��������Եȡ���
set /a mx = (value)*(1024)
(
echo CREATE VDISK FILE="%~dp0vhd\%newfile%.vhd" TYPE=FIXED MAXIMUM=%mx%
echo SELECT VDISK FILE="%~dp0vhd\%newfile%.vhd"
echo ATTACH VDISK NOERR
echo CLEAN
echo CREATE PARTITION PRIMARY
echo FORMAT FS=NTFS QUICK
echo ACTIVE
echo ASSIGN
)>%tmp%\vhdconf
DISKPART /s %tmp%\vhdconf >nul
EXIT

::��ʽ��
:vhdformat
(
echo SELECT VDISK FILE="%~dp0vhd\%vhdfile%"
echo ATTACH VDISK NOERR
echo CLEAN
echo CREATE PARTITION PRIMARY
echo FORMAT FS=NTFS QUICK
echo ACTIVE
echo ASSIGN
)>%tmp%\vhdconf
DISKPART /s %tmp%\vhdconf >NUL
TIMEOUT 3 >NUL
EXIT

::���ո�Ŀ¼
:errdir
CLS
ECHO %~0
ECHO ��⵽���߰�����ڴ��пո��Ŀ¼
ECHO ��ѹ��߰����ڲ����ո��Ŀ¼���������
PAUSE
EXIT








