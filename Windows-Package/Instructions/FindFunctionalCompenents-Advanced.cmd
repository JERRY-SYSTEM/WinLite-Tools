@ECHO OFF
::网址：nat.ee
::批处理：荣耀&制作 QQ:1800619
mode con: cols=24 lines=14
color 2F
pushd "%~dp0"
IF "%PROCESSOR_ARCHITECTURE%" == "AMD64" (SET os=amd64) ELSE (SET os=x86)
SET nsudo=%~dp0bin\%os%\NSudoLG.exe
SET sed=%~dp0bin\%os%\sed.exe

::Sessions文件夹路径
SET spath=%windir%\servicing\Sessions
::过滤精简列表
SET filter1="s/.*<package id=//g;s/.*<Install package=//g;s/.*<Unproject package=//g;s/ update=.*>.*//g;s/~.*//g;s/ name=.*>.*//g"
::过滤完整列表
SET filter2="s/.*<package id=//g;s/.*<Install package=//g;s/.*<Unproject package=//g;s/ update=.*>.*//g;s/ name=.*>.*//g"
::删除重复
SET filter3="$!N; /^\(.*\)\n\1$/!P; D"
::删除空格
SET filter4="/^[[:space:]]*$/d;/^\s*$/d;s/[[:space:]]//g"

::主菜单
:menu
CLS
ECHO 1.获取完整组件列表
ECHO.
ECHO 2.获取精简组件列表
ECHO.
ECHO 3.打开Windows 功能
ECHO.
ECHO 4.清理会话记录文件
ECHO.
choice /C:1234 /N /M "请输入你的选择[1-4]"：
if errorlevel 4 GOTO:Cleanup-Session-Files
if errorlevel 3 GOTO:Open-Features
if errorlevel 2 GOTO:Get-Lite-Packages
if errorlevel 1 GOTO:Get-Full-Packages

::获取完整组件列表
:Get-Full-Packages
IF NOT EXIST "%spath%\Sessions.xml" (
ECHO.
ECHO 会话记录文件已被清理，
ECHO 请重新开启或关闭功能，
ECHO 以便本程序获取包列表。
TIMEOUT 5 >NUL
GOTO:menu
)
IF EXIST "%~dp0Package\Find-Full-Packages.txt" (DEL /f /q "%~dp0Package\Find-Full-Packages.txt" 1>NUL 2>NUL)
for /f "delims=" %%i in ('FINDSTR /c:"package id=" /c:"Install package=" /c:"Unproject package=" %spath%\Sessions.xml 2^>nul^|%sed% %filter2% 2^>nul^|sort 2^>nul') do (ECHO %%~i >>%~dp0Package\Find-Full-Packages.txt)
%sed% -i %filter3% %~dp0Package\Find-Full-Packages.txt 1>NUL 2>NUL
%sed% -i %filter4% %~dp0Package\Find-Full-Packages.txt 1>NUL 2>NUL
ECHO.
ECHO 在 Package 文件夹
ECHO 文件：Find-Full-Packages.txt
TIMEOUT 3 >NUL
GOTO:menu

::获取精简组件列表
:Get-Lite-Packages
IF NOT EXIST "%spath%\Sessions.xml" (
ECHO.
ECHO 会话记录文件已被清理，
ECHO 请重新开启或关闭功能，
ECHO 以便本程序获取包列表。
TIMEOUT 5 >NUL
GOTO:menu
)
IF EXIST "%~dp0Package\Find-Lite-Packages.txt" (DEL /f /q "%~dp0Package\Find-Lite-Packages.txt" 1>NUL 2>NUL)
for /f "delims=" %%i in ('FINDSTR /c:"package id=" /c:"Install package=" /c:"Unproject package=" %spath%\Sessions.xml 2^>nul^|%sed% %filter1% 2^>nul^|sort 2^>nul') do (ECHO %%~i >>%~dp0Package\Find-Lite-Packages.txt)
%sed% -i %filter3% %~dp0Package\Find-Lite-Packages.txt 1>NUL 2>NUL
%sed% -i %filter4% %~dp0Package\Find-Lite-Packages.txt 1>NUL 2>NUL
ECHO.
ECHO 在 Package 文件夹
ECHO 文件：Find-Lite-Packages.txt
TIMEOUT 3 >NUL
GOTO:menu

::打开Windows 功能
:Open-Features
START optionalfeatures 1>NUL 2>NUL
GOTO:menu

::清理会话记录文件
:Cleanup-Session-Files
%nsudo% -U:T -P:E -ShowWindowMode:Hide cmd /c "DEL /f /q %spath%\*.xml 1>NUL 2>NUL"
ECHO.
ECHO 清理会话记录文件完成。
TIMEOUT 3 >NUL
GOTO:menu