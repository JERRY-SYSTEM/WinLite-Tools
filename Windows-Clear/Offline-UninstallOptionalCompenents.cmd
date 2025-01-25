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
IF NOT EXIST "%imgpath%\Windows\servicing\TrustedInstaller.exe" (
CLS
ECHO 你输入的路径目录不正确或不存在有效映像。
ECHO 请重试……
TIMEOUT 4 >NUL
goto:head
)

::菜单
:menu
TITLE 离线----卸载按需功能
SET /A count=0
COLOR 07
CLS
ECHO 离线映像路径：%imgpath%
ECHO.
ECHO 1.获取按需功能列表
ECHO.
ECHO 2.分析按需功能列表
ECHO.
ECHO 3.批量卸载按需功能
ECHO.
ECHO 4.退出
ECHO.
choice /C:1234 /N /M "请输入你的选择 [1,2,3,4]"：
if errorlevel 4 EXIT
if errorlevel 3 GOTO:Capability-Remove
if errorlevel 2 GOTO:Capability-Analysis
if errorlevel 1 GOTO:Capability-Get

::获取按需功能列表
:Capability-Get
CLS
ECHO 请稍等……
%dism% /Image:%imgpath% /Format:List /English /Get-Capabilities | FIND "Capability Identity" | %sed% -e "s/Capability Identity : //g;s/~*[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*//g" >%~dp0Offline-Remove\Offline-List-Capability.txt
CLS
ECHO.
ECHO 按需功能列表列表已生成。
ECHO 在 Offline-Remove 文件夹
ECHO 文件：Offline-List-Capability.txt
ECHO.
ECHO 按任意键返回主菜单……
PAUSE >NUL
GOTO:menu
EXIT

::分析按需功能列表
:Capability-Analysis
TITLE 离线----按需功能分析----分析途中,请勿退出此窗口。
color 47
CLS
IF EXIST "%~dp0Offline-Remove\Offline-Capability-Analysis.txt" (del /f /q "%~dp0Offline-Remove\Offline-Capability-Analysis.txt")
FOR /f %%t IN ('echo %time:~0,2%:%time:~3,2%:%time:~6,2%') DO (SET sttm=%%t)
FOR /f %%i IN ('%dism% /Image:%imgpath% /Format:List /English /Get-Capabilities ^| FIND "Capability Identity" ^| %sed% -e "s/Capability Identity : //g" 2^>nul') DO (
call :time1 %%i
ECHO 功能名称：%%i | %sed% -e "s/~*[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*//g" >>%~dp0Offline-Remove\Offline-Capability-Analysis.txt
%dism% /Image:%imgpath% /Format:List /English /Get-CapabilityInfo /CapabilityName:"%%i" | FINDSTR /c:"Display Name" /c:"Description" >>%~dp0Offline-Remove\Offline-Capability-Analysis.txt
ECHO. >>%~dp0Offline-RemoveOffline-Capability-Analysis.txt
)
TITLE 离线----按需功能分析完成。
color 2F
ECHO.
ECHO 程序功能分析已生成。
ECHO 在 Offline-Remove 文件夹
ECHO 文件：Offline-Capability-Analysis.txt
ECHO.
ECHO 开始时间：%sttm% 结束时间：%time:~0,2%:%time:~3,2%:%time:~6,2% 统计：%count%
ECHO.
ECHO 按任意键返回主菜单……
PAUSE >NUL
GOTO:menu
EXIT

::批量卸载按需功能
:Capability-Remove
TITLE 离线----卸载按需功能----卸载途中,请勿退出此窗口。
color 47
IF NOT EXIST "%~dp0Offline-Remove\Offline-Remove-Capability.txt" (TYPE NUL>%~dp0Offline-Remove\Offline-Remove-Capability.txt)
for %%a in (%~dp0Offline-Remove\Offline-Remove-Capability.txt) do (
if "%%~za" equ "0" (
CLS
ECHO 警告：Offline-Remove-Capability.txt文件为空！
ECHO 支持模糊和完整搜索匹配按需功能卸载。
ECHO 请在Offline-List-Capability.txt获取按需功能名,
ECHO 添加在Offline-Remove-Capability.txt，一行一个。
ECHO.
ECHO 按任意键返回主菜单……
PAUSE >NUL
GOTO:menu
EXIT
)
)
CLS
FOR /f %%t IN ('echo %time:~0,2%:%time:~3,2%:%time:~6,2%') DO (SET sttm=%%t)
%sed% -i "/^[[:space:]]*$/d;/^\s*$/d;s/[[:space:]]//g" %~dp0Offline-Remove\Offline-Remove-Capability.txt
FOR /f %%i IN ('%dism% /Image:%imgpath% /Format:List /English /Get-Capabilities ^| FIND "Capability Identity" ^| %sed% -e "s/Capability Identity : //g" 2^>nul ^| FINDSTR /i /g:%~dp0Offline-Remove\Offline-Remove-Capability.txt 2^>nul') DO (
call :time2 %%i
%dism% /Image:%imgpath% /Remove-Capability /CapabilityName:"%%i"
ECHO.
)
TITLE 离线----卸载按需功能完成。
color 2F
ECHO.
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

:time1
SET /A count+=1
ECHO %time:~0,2%:%time:~3,2%:%time:~6,2% 正在分析第%count%个 %~1
goto:eof

:time2
SET /A count+=1
ECHO %time:~0,2%:%time:~3,2%:%time:~6,2% 正在卸载第%count%个 %~1
goto:eof