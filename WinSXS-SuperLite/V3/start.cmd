@echo off&&color 0F&&chcp 936
mode con cols=96 lines=26
set title=WinSxS-超级精简v3    **** 批处理:荣耀  QQ:1800619  QQ群:6281379 ****
title  %title%
set ssss=                           删除有风险，你使用即代表承担风险，与作者无关！

IF "%PROCESSOR_ARCHITECTURE%" == "AMD64" (SET os=amd64) ELSE (SET os=x86)
SET nsudo=%~dp0bin\%os%\NSudoLG.exe
IF EXIST "%PROGRAMFILES(X86)%" (set ARCH=x64) ELSE (set ARCH=x32)


pushd "%~dp0"
ECHO;%SystemPath%|find " "&&goto:errdir

:SETP
echo.
echo.
echo         %title%
echo.
for /f "tokens=3 delims=: " %%b in ('%YCDM% /english /online /Get-Intl ^| find /i "System locale"') do set OUI=%%b
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "BuildLabEx"') do set UBR=%%a
set UBR=%UBR:~28%
for /f "tokens=2 delims=." %%a in ('echo %UBR%') do set OZD=%%a
>NUL 2>NUL reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "UBR" ||GOTO :KAISHI
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "UBR"') do set BDH=%%a
set BDH=%BDH:~26%
set /a BDH=0x%BDH%
set OZD=%BDH%

:KAISHI
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild"') do set OMD=%%a
set OMD=%OMD:~30%
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "BuildLabEx"') do set UBR=%%a
set ORS=%UBR:~-11,4%
for /f "tokens=5 delims=._" %%a in ('echo %UBR%') do (set OSV=%%a)
for /f "tokens=1,2*" %%i in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductName"') do set OOS=%%k
for /f "tokens=1,2,3 delims= " %%a in ('echo %OOS%') do (
set NTver=%%a %%b
set Bliud=%%c
)
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "EditionID"') do set OEID=%%a
set OEID=%OEID:~27%
set PDPRO=%OEID:~0,3%
if /i %OEID% EQU Professional (
if /i %PDPRO% EQU Pro set "OEID=Pro%OEID:~12%"
if %OMD% gtr 16299 set "OOS=%NTver% %OEID%"
) ELSE (
if /i %OMD% GTR 16299 if /i %PDPRO% EQU Pro (
set "OEID=%OEID%"
set "OOS=%NTver% %OEID%"
) ELSE (
set "OOS=%OOS%"
)
)

:head
CLS
echo.
echo              %title%
echo.
echo                     当前系统^:%OOS% %ARCH% %OUI% %OSV% %ORS%(%OMD%^.%OZD%)
echo.
echo                                  当前日期^:%date%
echo.
echo                ****************************************************************
call:colstr 4 1 "%ssss%" 0 1 1
echo                ****************************************************************
echo.
echo.
echo 请输入需要精简系统的绝对路径（ 注意：路径不能带有空格或中文！）
echo.
echo 例1： 如果是  X:\Windows     请输入： X:
echo.
echo 例2： X:\Example\Windows     请输入： X:\Example\
echo.
echo PS：如果文件夹路径太长，直接拖拽文件夹进来！
echo.
echo.
echo.
SET /p SystemPath=请输入路径，然后按回车键(Enter):
REM IF /i "%SystemPath%" == "%SystemDrive%" (goto:head)
IF NOT EXIST "%SystemPath%\Windows\WinSxS" (
CLS
echo 你输入的路径不正确或不存在有效映像。
echo 请重试……
TIMEOUT 4 >NUL
goto:head
) ELSE (GOTO:menu)

:menu
CLS
ECHO 系统路径：%SystemPath%
ECHO.
ECHO 1.获取WinSxS列表
ECHO.
ECHO 2.清理WinSxS文件夹
ECHO.
ECHO 3.清理 文件
ECHO.
ECHO 4.清理 文件夹
ECHO.
ECHO 5.退出
ECHO.
choice /C:12345 /N /M "请输入你的选择 [1,2,3,4,5]"：
if errorlevel 5 EXIT
if errorlevel 4 GOTO:CleanupFolder
if errorlevel 3 GOTO:CleanupFile
if errorlevel 2 GOTO:CleanupWinSxS
if errorlevel 1 GOTO:GetWinSxSList

:GetWinSxSList
DIR /a:d /b /o:n "%SystemPath%\Windows\WinSxS" | FINDSTR /i /v "Backup Catalogs FileMaps InstallTemp ManifestCache Manifests Temp" >%~dp0cleanup\Get-WinSxS-List.txt
ECHO.
ECHO WinSxS列表已生成。
ECHO Get-WinSxS-List.txt
TIMEOUT 3 >NUL
GOTO:menu
EXIT

:CleanupWinSxS
CLS
IF NOT EXIST "%~dp0cleanup\WinSxS-List.txt" (TYPE NUL>%~dp0cleanup\WinSxS-List.txt)
for %%a in (%~dp0cleanup\WinSxS-List.txt) do (
if "%%~za" equ "0" (
CLS
ECHO 警告：WinSxS-List.txt文件为空！
ECHO 请填写需要保留的文件夹名称,
ECHO 添加在WinSxS-List.txt，一行一个。
ECHO.
ECHO 按任意键返回主菜单……
PAUSE >NUL
GOTO:menu
EXIT
) ELSE (GOTO:StartWinSxS)
)
:StartWinSxS
%nsudo% -U:T -P:E cmd /c "%~dp0core.cmd %SystemPath% WinSxS"
GOTO:menu
nul&exit/b

:CleanupFile
CLS
IF NOT EXIST "%~dp0cleanup\File-List.txt" (TYPE NUL>%~dp0cleanup\File-List.txt)
for %%b in (%~dp0cleanup\File-List.txt) do (
if "%%~zb" equ "0" (
CLS
ECHO 警告：File-List.txt文件为空！
ECHO 请填写需要删除的文件名称,
ECHO 添加在File-List.txt，一行一个。
ECHO.
ECHO 按任意键返回主菜单……
PAUSE >NUL
GOTO:menu
EXIT
) ELSE (GOTO:StartFile)
)
:StartFile
%nsudo% -U:T -P:E cmd /c "%~dp0core.cmd %SystemPath% File"
GOTO:menu
EXIT

:CleanupFolder
CLS
IF NOT EXIST "%~dp0cleanup\Folder-List.txt" (TYPE NUL>%~dp0cleanup\Folder-List.txt)
for %%c in (%~dp0cleanup\Folder-List.txt) do (
if "%%~zc" equ "0" (
CLS
ECHO 警告：Folder-List.txt文件为空！
ECHO 请填写需要删除的文件夹名称,
ECHO 添加在Folder-List.txt，一行一个。
ECHO 注意：无须添加盘符
ECHO.
ECHO 按任意键返回主菜单……
PAUSE >NUL
GOTO:menu
EXIT
) ELSE (GOTO:StartFolder)
)
:StartFolder
%nsudo% -U:T -P:E cmd /c "%~dp0core.cmd %SystemPath% Folder"
GOTO:menu
EXIT

::检测空格目录
:errdir
CLS
ECHO %~0
ECHO 检测到工具包存放在带有空格的目录
ECHO 请把工具包放在不带空格的目录，否则出错！
PAUSE
EXIT

rem /*--------- colstr 函数 -------------
:Colstr <attr> <sp> <"str"> <bk> <sp> <enter>
for %%a in (+%2 +%4 +%5 +%6) do (
   if "%%a"=="+" echo 控制参数不能为空&exit/b
   if %%a lss +0 echo 参数越界-&exit/b
   if %%a geq +a echo 参数越界+&exit/b)
if %3 == "" echo 字符串不能为空&exit/b
pushd %tmp%&setlocal ENABLEEXTENSIONS
if exist "%~3?" del/a/q "%~3?">nul 2>nul
if %2 gtr 0 call:%0_bs %2 sp " "&call set/p=%%sp%%<nul
if %4 gtr 0 (call:%0_bs %4 bk "") else set "bk="
call:%0_bs %5 sp " "
set/p=%bk%%sp%<nul>"%~3"&findstr /a:%1 .* "%~3?" 2>nul
if not %6 equ 0 for /l %%a in (1 1 %6)do echo.
endlocal&popd&goto:eof
:Colstr_bs
set "p="&for /l %%a in (1 1 %1)do call set "p=%%p%%%~3"
set "%2=%p%"&goto:eof
rem ------------------------------------*/