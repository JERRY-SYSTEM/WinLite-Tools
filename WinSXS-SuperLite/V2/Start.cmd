@echo OFF
::网址：nat.ee
::QQ群：6281379
::TG群：https://t.me/nat_ee
::批处理：荣耀&制作 QQ:1800619
IF "%PROCESSOR_ARCHITECTURE%" == "AMD64" (SET os=amd64) ELSE (SET os=x86)
SET nsudo=%~dp0bin\%os%\NSudoLG.exe

TITLE WinSxS-超级精简 ---- nat.ee
pushd "%~dp0"
ECHO;%SystemPath%|find " "&&goto:errdir

:head
CLS
ECHO 删除有风险，你使用即代表承担风险，与作者无关。
ECHO.
ECHO 请输入系统绝对路径,并且路径不能带有空格。
ECHO 例1：Y:\Windows 输入：Y:
ECHO 例2：Z:\Example\Windows 输入：Z:\Example\
ECHO 如：例2文件夹路径太长,直接拖拽文件夹进来。
ECHO 你所输入的路径，不能带有空格或中文！
ECHO.
ECHO 输入路径，按回车键(Enter)
SET /p SystemPath=:
REM IF /i "%SystemPath%" == "%SystemDrive%" (goto:head)
IF NOT EXIST "%SystemPath%\Windows\WinSxS" (
CLS
ECHO 你输入的路径不正确或不存在有效映像。
ECHO 请重试……
TIMEOUT 4 >NUL
goto:head
) ELSE (GOTO:menu)

:menu
IF NOT EXIST "%~dp0winsxslist.txt" (TYPE NUL>%~dp0winsxslist.txt)
for %%a in (%~dp0winsxslist.txt) do (
if "%%~za" equ "0" (
CLS
ECHO 警告：winsxslist.txt文件为空！
ECHO 请填写需要保留的文件夹名称,
ECHO 添加在winsxslist.txt，一行一个。
ECHO.
ECHO 按任意键退出……
PAUSE >NUL
EXIT
) ELSE (GOTO:Remove)
)

:Remove
%nsudo% -U:T -P:E cmd /c "%~dp0core.cmd %SystemPath%"
EXIT

::检测空格目录
:errdir
CLS
ECHO %~0
ECHO 检测到工具包存放在带有空格的目录
ECHO 请把工具包放在不带空格的目录，否则出错！
PAUSE
EXIT