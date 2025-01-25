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
SET sed=%~dp0bin\%os%\sed.exe
SET /A count=0
ECHO;%~0|find " "&&GOTO:errdir

:head
SET imgpath=%SystemDrive%
IF NOT EXIST "%imgpath%\Program Files\WindowsApps\" (
CLS
ECHO 你的系统不支持使用！
ECHO 按任意键退出……
PAUSE >NUL
EXIT
)

::菜单
:menu
TITLE 在线----卸载Appx应用
COLOR 07
CLS
ECHO 1.获取Appx应用列表
ECHO.
ECHO 2.批量卸载Appx应用
ECHO.
ECHO 3.退出
ECHO.
choice /C:123 /N /M "请输入你的选择 [1,2,3]"：
if errorlevel 3 EXIT
if errorlevel 2 GOTO:AppxPackages-Remove
if errorlevel 1 GOTO:AppxPackages-Get


::获取Appx应用列表
:AppxPackages-Get
CLS
ECHO 请稍等……
%dism% /Online /Format:List /English /Get-ProvisionedAppxPackages|FIND "PackageName"|%sed% -e "s/PackageName : //g;s/_.*//g" >%~dp0Online-Remove\Online-List-Appx.txt
CLS
ECHO.
ECHO Appx应用列表列表已生成。
ECHO 在 Online-Remove 文件夹
ECHO 文件：Online-List-Appx.txt
ECHO.
ECHO 按任意键返回主菜单……
PAUSE >NUL
GOTO:menu
EXIT

::批量卸载Appx应用
:AppxPackages-Remove
IF NOT EXIST "%~dp0Online-Remove\Online-Remove-Appx.txt" (TYPE NUL>%~dp0Online-Remove\Online-Remove-Appx.txt)
for %%a in (%~dp0Online-Remove\Online-Remove-Appx.txt) do (
if "%%~za" equ "0" (
CLS
ECHO 警告：Online-Remove-Appx.txt文件为空！
ECHO 支持模糊和完整搜索匹配Appx应用卸载。
ECHO 请在Online-List-Appx.txt获取Appx应用名,
ECHO 添加在Online-Remove-Appx.txt，一行一个。
ECHO.
ECHO 按任意键返回主菜单……
PAUSE >NUL
GOTO:menu
EXIT
)
)
CLS
TITLE 在线----卸载Appx应用途中,请勿退出此窗口。
color 47
FOR /f %%t IN ('echo %time:~0,2%:%time:~3,2%:%time:~6,2%') DO (SET sttm=%%t)
%sed% -i "/^[[:space:]]*$/d;/^\s*$/d;s/[[:space:]]//g" %~dp0Online-Remove\Online-Remove-Appx.txt
FOR /f %%i IN ('%dism% /Online /Format:List /English /Get-ProvisionedAppxPackages ^| FIND "PackageName" ^| %sed% -e "s/PackageName : //g" 2^>nul ^| FINDSTR /i /g:%~dp0Online-Remove\Online-Remove-Appx.txt 2^>nul') DO (
call :time %%i
%dism% /online /Remove-ProvisionedAppxPackage /PackageName:%%i
call :psAppxRemove %%i
ECHO.
)
TITLE 在线----卸载Appx应用完成。
color 2F
ECHO 卸载完成。
ECHO.
ECHO 开始时间：%sttm% 结束时间：%time:~0,2%:%time:~3,2%:%time:~6,2% 统计：%count%
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

:time
SET /A count+=1
ECHO %time:~0,2%:%time:~3,2%:%time:~6,2% 正在卸载第%count%个：%~1
goto:eof

:psAppxRemove
powershell -Command "& {Remove-AppxPackage -Package "%~1" -EA SilentlyContinue}"
goto:eof