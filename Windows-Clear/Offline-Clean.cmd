@ECHO OFF
::��ַ��nat.ee
::��������ҫ&���� QQ:1800619
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
ECHO ����������ӳ�����·��,����·�����ܴ��пո�
ECHO ��1��Y:
ECHO ��2��Z:\Example
ECHO �磺��2�ļ���·��̫��,ֱ����ק�ļ��н�����
ECHO.
ECHO ����·�������س���(Enter)
SET /p imgpath=:
ECHO;%imgpath%|find " "&&goto:header
IF NOT EXIST "%imgpath%\Program Files\WindowsApps\" (
CLS
ECHO �������·��Ŀ¼����ȷ�򲻴�����Чӳ��
ECHO �����ԡ���
TIMEOUT 4 >NUL
goto:head
)

::�˵�
:menu
TITLE ����----����ϵͳ
COLOR 07
CLS
ECHO ����ӳ��·����%imgpath%
ECHO.
ECHO 1.Windows 7 ����
ECHO.
ECHO 2.Windows 8.1/10 ����
ECHO.
ECHO 3.�˳�
ECHO.
choice /C:123 /N /M "���������ѡ�� [1,2,3]"��
if errorlevel 3 EXIT
if errorlevel 2 GOTO:Windows
if errorlevel 1 GOTO:Windows7

:Windows7
TITLE ����----Windows 7 ----����;��,�����˳��˴��ڡ�
color 47
CLS
%dism% /Image:%imgpath% /Cleanup-Image /SPSuperseded /hidesp
TITLE ����----ϵͳ������ɡ�
color 2F
ECHO.
ECHO ��������˳�����
PAUSE >NUL
EXIT

:Windows
TITLE ����----Windows 8.1/10 ----����;��,�����˳��˴��ڡ�
color 47
CLS
%dism% /Image:%imgpath% /Cleanup-Image /SPSuperseded /hidesp
%dism% /Image:%imgpath% /Cleanup-Image /StartComponentCleanup /ResetBase
TITLE ����----ϵͳ������ɡ�
color 2F
ECHO.
ECHO ��������˳�����
PAUSE >NUL
EXIT

::���ո�Ŀ¼
:errdir
CLS
ECHO %~0
ECHO ��⵽���߰�����ڴ��пո��Ŀ¼
ECHO ��ѹ��߰����ڲ����ո��Ŀ¼���������
PAUSE
EXIT
