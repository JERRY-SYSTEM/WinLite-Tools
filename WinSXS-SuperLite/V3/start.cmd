@echo off&&color 0F&&chcp 936
mode con cols=96 lines=26
set title=WinSxS-��������v3    **** ������:��ҫ  QQ:1800619  QQȺ:6281379 ****
title  %title%
set ssss=                           ɾ���з��գ���ʹ�ü�����е����գ��������޹أ�

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
echo                     ��ǰϵͳ^:%OOS% %ARCH% %OUI% %OSV% %ORS%(%OMD%^.%OZD%)
echo.
echo                                  ��ǰ����^:%date%
echo.
echo                ****************************************************************
call:colstr 4 1 "%ssss%" 0 1 1
echo                ****************************************************************
echo.
echo.
echo ��������Ҫ����ϵͳ�ľ���·���� ע�⣺·�����ܴ��пո�����ģ���
echo.
echo ��1�� �����  X:\Windows     �����룺 X:
echo.
echo ��2�� X:\Example\Windows     �����룺 X:\Example\
echo.
echo PS������ļ���·��̫����ֱ����ק�ļ��н�����
echo.
echo.
echo.
SET /p SystemPath=������·����Ȼ�󰴻س���(Enter):
REM IF /i "%SystemPath%" == "%SystemDrive%" (goto:head)
IF NOT EXIST "%SystemPath%\Windows\WinSxS" (
CLS
echo �������·������ȷ�򲻴�����Чӳ��
echo �����ԡ���
TIMEOUT 4 >NUL
goto:head
) ELSE (GOTO:menu)

:menu
CLS
ECHO ϵͳ·����%SystemPath%
ECHO.
ECHO 1.��ȡWinSxS�б�
ECHO.
ECHO 2.����WinSxS�ļ���
ECHO.
ECHO 3.���� �ļ�
ECHO.
ECHO 4.���� �ļ���
ECHO.
ECHO 5.�˳�
ECHO.
choice /C:12345 /N /M "���������ѡ�� [1,2,3,4,5]"��
if errorlevel 5 EXIT
if errorlevel 4 GOTO:CleanupFolder
if errorlevel 3 GOTO:CleanupFile
if errorlevel 2 GOTO:CleanupWinSxS
if errorlevel 1 GOTO:GetWinSxSList

:GetWinSxSList
DIR /a:d /b /o:n "%SystemPath%\Windows\WinSxS" | FINDSTR /i /v "Backup Catalogs FileMaps InstallTemp ManifestCache Manifests Temp" >%~dp0cleanup\Get-WinSxS-List.txt
ECHO.
ECHO WinSxS�б������ɡ�
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
ECHO ���棺WinSxS-List.txt�ļ�Ϊ�գ�
ECHO ����д��Ҫ�������ļ�������,
ECHO �����WinSxS-List.txt��һ��һ����
ECHO.
ECHO ��������������˵�����
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
ECHO ���棺File-List.txt�ļ�Ϊ�գ�
ECHO ����д��Ҫɾ�����ļ�����,
ECHO �����File-List.txt��һ��һ����
ECHO.
ECHO ��������������˵�����
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
ECHO ���棺Folder-List.txt�ļ�Ϊ�գ�
ECHO ����д��Ҫɾ�����ļ�������,
ECHO �����Folder-List.txt��һ��һ����
ECHO ע�⣺��������̷�
ECHO.
ECHO ��������������˵�����
PAUSE >NUL
GOTO:menu
EXIT
) ELSE (GOTO:StartFolder)
)
:StartFolder
%nsudo% -U:T -P:E cmd /c "%~dp0core.cmd %SystemPath% Folder"
GOTO:menu
EXIT

::���ո�Ŀ¼
:errdir
CLS
ECHO %~0
ECHO ��⵽���߰�����ڴ��пո��Ŀ¼
ECHO ��ѹ��߰����ڲ����ո��Ŀ¼���������
PAUSE
EXIT

rem /*--------- colstr ���� -------------
:Colstr <attr> <sp> <"str"> <bk> <sp> <enter>
for %%a in (+%2 +%4 +%5 +%6) do (
   if "%%a"=="+" echo ���Ʋ�������Ϊ��&exit/b
   if %%a lss +0 echo ����Խ��-&exit/b
   if %%a geq +a echo ����Խ��+&exit/b)
if %3 == "" echo �ַ�������Ϊ��&exit/b
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