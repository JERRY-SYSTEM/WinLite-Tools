@ECHO OFF
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
if exist "%temp%\getadmin.vbs" (del "%temp%\getadmin.vbs")
pushd "%~dp0"
IF "%PROCESSOR_ARCHITECTURE%" == "AMD64" (SET os=amd64) ELSE (SET os=x86)
SET dism=%~dp0bin\%os%\DISM\DISM.exe
ECHO;%~0|find " "&&GOTO:errdir

:head
CLS
ECHO 请输入离线映像绝对路径,并且路径不能带有空格。
ECHO 例1：Y:
ECHO 例2：Z:\Example
ECHO 如：例2文件夹路径太长,直接拖拽文件夹进来。
ECHO.
ECHO 输入路径，按回车键(Enter)
SET /p imgpath=:
ECHO;%imgpath%|find " "&&goto:header
IF NOT EXIST "%imgpath%\Program Files\WindowsApps\" (
CLS
ECHO 你输入的路径目录不正确或不存在有效映像。
ECHO 请重试……
TIMEOUT 4 >NUL
goto:head
)

::菜单
:menu
TITLE 离线----清理系统
COLOR 07
CLS
ECHO 离线映像路径：%imgpath%
ECHO.
ECHO 1.Windows 7 清理
ECHO.
ECHO 2.Windows 8.1/10 清理
ECHO.
ECHO 3.退出
ECHO.
choice /C:123 /N /M "请输入你的选择 [1,2,3]"：
if errorlevel 3 EXIT
if errorlevel 2 GOTO:Windows
if errorlevel 1 GOTO:Windows7

:Windows7
TITLE 离线----Windows 7 ----清理途中,请勿退出此窗口。
color 47
CLS
%dism% /Image:%imgpath% /Cleanup-Image /SPSuperseded /hidesp
TITLE 离线----系统清理完成。
color 2F
ECHO.
ECHO 按任意键退出……
PAUSE >NUL
EXIT

:Windows
TITLE 离线----Windows 8.1/10 ----清理途中,请勿退出此窗口。
color 47
CLS
%dism% /Image:%imgpath% /Cleanup-Image /SPSuperseded /hidesp
%dism% /Image:%imgpath% /Cleanup-Image /StartComponentCleanup /ResetBase
TITLE 离线----系统清理完成。
color 2F
ECHO.
ECHO 按任意键退出……
PAUSE >NUL
EXIT

::检测空格目录
:errdir
CLS
ECHO %~0
ECHO 检测到工具包存放在带有空格的目录
ECHO 请把工具包放在不带空格的目录，否则出错！
PAUSE
EXIT
