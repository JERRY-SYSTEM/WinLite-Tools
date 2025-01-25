@echo OFF
::网址：nat.ee
::批处理：荣耀&制作 QQ:1800619
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

::主菜单
:menu
cls
echo.
echo 1.挂载 %vhdfile%
echo.
echo 2.分离 %vhdfile%
echo.
echo 3.创建 VHD
echo.
echo 4.格式化 %vhdfile%
echo.
choice /C:1234 /N /M "请输入你的选择[1,2,3,4]"：
if errorlevel 4 goto:vhdformat
if errorlevel 3 goto:vhdadd
if errorlevel 2 goto:vhdseparate
if errorlevel 1 goto:vhdmount

::挂载
:vhdmount
(
echo SELECT VDISK FILE= "%~dp0vhd\%vhdfile%"
echo ATTACH VDISK NOERR
echo LIST DISK
)>%tmp%\vhdconf
DISKPART /s %tmp%\vhdconf >nul
EXIT

::分离
:vhdseparate
(
echo SELECT VDISK FILE= "%~dp0vhd\%vhdfile%"
echo ATTACH VDISK NOERR
echo DETACH VDISK
echo LIST DISK
)>%tmp%\vhdconf
DISKPART /s %tmp%\vhdconf >nul
EXIT

::创建
:vhdadd
cls
echo 创建VHD虚拟硬盘
ECHO 按回车键(Enter)
echo.
set /p newfile=文件名称：
echo.
set /p value=硬盘大小(G):
ECHO.
ECHO 正在创建，请稍等……
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

::格式化
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

::检测空格目录
:errdir
CLS
ECHO %~0
ECHO 检测到工具包存放在带有空格的目录
ECHO 请把工具包放在不带空格的目录，否则出错！
PAUSE
EXIT








