@ECHO OFF
::网址：nat.ee
::批处理：荣耀&制作 QQ:1800619
TITLE 在线----卸载功能组件
mode con: cols=46 lines=16
color 17
pushd "%~dp0"
ECHO;%~0|find " "&&GOTO:errdir

::菜单
:menu
CLS
IF "%PROCESSOR_ARCHITECTURE%" == "AMD64" (SET os=amd64) ELSE (SET os=x86)
SET nsudo=%~dp0bin\%os%\NSudoLG.exe
SET sed=%~dp0bin\%os%\sed.exe
ECHO.
ECHO 1.获取完整组件包列表
ECHO.
ECHO 2.获取精简组件包列表
ECHO.
ECHO 3.批量卸载组件包列表
ECHO.
ECHO 4.退出
ECHO.
choice /C:1234 /N /M "请输入你的选择 [1,2,3,4]"：
if errorlevel 4 EXIT
if errorlevel 3 GOTO:Remove-Package
if errorlevel 2 GOTO:Get-Lite-Packages
if errorlevel 1 GOTO:Get-Full-Packages

::获取完整组件包列表
:Get-Full-Packages
dir /b %SystemDrive%\Windows\servicing\Packages\*.mum | %sed% "s/\.mum//g" >%~dp0Online-Remove\Online-Full-Packages.txt
ECHO.
ECHO 完整组件包列表已生成。
ECHO 在 Online-Remove 文件夹
ECHO 文件：Online-Full-Packages.txt
TIMEOUT 3 >NUL
GOTO:menu
EXIT

::获取精简组件包列表
:Get-Lite-Packages
SET filter="s/~.*\.mum//g"
dir /b %SystemDrive%\Windows\servicing\Packages\*.mum | %sed% %filter% | %sed% "$!N; /^\(.*\)\n\1$/!P; D" >%~dp0Online-Remove\Online-Lite-Packages.txt
ECHO.
ECHO 精简组件包列表已生成。
ECHO 在 Online-Remove 文件夹
ECHO 文件：Online-Lite-Packages.txt
TIMEOUT 3 >NUL
GOTO:menu
EXIT

::删除组件包列表
:Remove-Package
IF NOT EXIST "%~dp0Online-Remove\Online-Remove-Package.txt" (TYPE NUL>%~dp0Online-Remove\Online-Remove-Package.txt)
for %%a in (%~dp0Online-Remove\Online-Remove-Package.txt) do (
if "%%~za" equ "0" (
CLS
ECHO 警告：Online-Remove-Package.txt文件为空！
ECHO 支持模糊和完整搜索匹配组件包卸载。
ECHO 如果使用精简列表，将卸载关键字所有包。
ECHO 如果使用完整列表，将单独卸载这个包。
ECHO 精简和完整列表，都可以配合在一起。
ECHO 请在精简或完整列表获取组件包名,
ECHO 添加在Online-Remove-Package.txt，一行一个。
ECHO.
ECHO 按任意键返回主菜单……
PAUSE >NUL
GOTO:menu
EXIT
) ELSE (
CLS
%sed% -i "/^[[:space:]]*$/d;/^\s*$/d;s/[[:space:]]//g" %~dp0Online-Remove\Online-Remove-Package.txt
%nsudo% -U:T -P:E cmd /c "%~dp0Remove-Package.cmd Online-Remover-Package"
TIMEOUT 3 >NUL
GOTO:menu
EXIT
)
)

::检测空格目录
:errdir
CLS
ECHO %~0
ECHO 检测到工具包存放在带有空格的目录
ECHO 请把工具包放在不带空格的目录，否则出错！
PAUSE
EXIT