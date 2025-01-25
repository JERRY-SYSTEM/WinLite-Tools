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

::菜单
:menu
TITLE 在线----分析功能组件
SET /A count=0
COLOR 07
CLS
ECHO. 
ECHO 1.获取程序功能分析
ECHO.
ECHO 2.获取可选功能分析
ECHO.
ECHO 3.获取可选功能列表
ECHO.
ECHO 4.退出
ECHO.
choice /C:1234 /N /M "请输入你的选择 [1,2,3,4]"：
if errorlevel 4 EXIT
if errorlevel 3 GOTO:Get-Optional-Function-List
if errorlevel 2 GOTO:Get-Optional-Function-Analysis
if errorlevel 1 GOTO:Get-Features-Analysis

::获取程序功能分析
:Get-Features-Analysis
TITLE 在线----程序功能分析----分析途中,请勿退出此窗口。
color 47
CLS
IF EXIST "%~dp0Online-Remove\Online-Features-Analysis.txt" (del /f /q "%~dp0Online-Remove\Online-Features-Analysis.txt")
FOR /f %%t IN ('echo %time:~0,2%:%time:~3,2%:%time:~6,2%') DO (SET sttm=%%t)
FOR /f %%i IN ('%dism% /online /English /Format:List /Get-Features ^| FIND "Feature Name" ^| %sed% -e "s/Feature Name : //g"') DO (
call :time %%i
%dism% /online /English /Format:List /Get-FeatureInfo /FeatureName:"%%i"|FINDSTR /c:"Feature Name" /c:"Display Name" /c:"Description" >>%~dp0Online-Remove\Online-Features-Analysis.txt
ECHO. >>%~dp0Online-Remove\Online-Features-Analysis.txt
)
TITLE 在线----程序功能分析完成。
color 2F
ECHO.
ECHO 程序功能分析已生成。
ECHO 在 Online-Remove 文件夹
ECHO 文件：Online-Features-Analysis.txt
ECHO.
ECHO 开始时间：%sttm% 结束时间：%time:~0,2%:%time:~3,2%:%time:~6,2% 统计：%count%
ECHO.
ECHO 按任意键返回主菜单……
PAUSE >NUL
GOTO:menu
EXIT

::获取可选功能分析
:Get-Optional-Function-Analysis
TITLE 在线----可选功能分析----分析途中,请勿退出此窗口。
color 47
CLS
IF EXIST "%~dp0Online-Remove\Online-Optional-Function-Analysis.txt" (del /f /q "%~dp0Online-Remove\Online-Optional-Function-Analysis.txt")
FOR /f %%t IN ('echo %time:~0,2%:%time:~3,2%:%time:~6,2%') DO (SET sttm=%%t)
FOR /f %%i IN ('%dism% /Online /English /Format:List /Get-Packages ^| FIND "Package Identity" ^| %sed% -e "s/Package Identity : //g"') DO (
call :time %%i
ECHO 功能名称：%%i | %sed% -e "s/~.*//g" >>%~dp0Online-Remove\Online-Optional-Function-Analysis.txt
%dism% /Online /English /Format:List /Get-PackageInfo /PackageName:"%%i"|FIND "Description" >>%~dp0Online-Remove\Online-Optional-Function-Analysis.txt
ECHO. >>%~dp0Online-Remove\Online-Optional-Function-Analysis.txt
)
TITLE 在线----可选功能分析完成。
color 2F
ECHO.
ECHO 可选功能分析已生成。
ECHO 在 Online-Remove 文件夹
ECHO 文件：Online-Optional-Function-Analysis.txt
ECHO.
ECHO 开始时间：%sttm% 结束时间：%time:~0,2%:%time:~3,2%:%time:~6,2% 统计：%count%
ECHO.
ECHO 按任意键返回主菜单……
PAUSE >NUL
GOTO:menu
EXIT

::获取可选功能列表
:Get-Optional-Function-List
CLS
ECHO 请稍等……
%dism% /Online /English /Format:List /Get-Packages | FIND "Package Identity" | %sed% -e "s/Package Identity : //g;s/~.*//g" >%~dp0Online-Remove\Online-Optional-Function-List.txt
CLS
ECHO 可选功能列表已生成。
ECHO 在 Online-Remove 文件夹
ECHO 文件：Online-Optional-Function-List.txt
ECHO.
ECHO 按任意键返回主菜单……
PAUSE >NUL
GOTO:menu
EXIT

:time
SET /A count+=1
ECHO %time:~0,2%:%time:~3,2%:%time:~6,2% 正在分析第%count%个 %~1
goto:eof
