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
ECHO;%~0|find " "&&GOTO:errdir
IF "%PROCESSOR_ARCHITECTURE%" == "AMD64" (SET os=amd64) ELSE (SET os=x86)
SET dism=%~dp0bin\%os%\DISM\DISM.exe
SET sed=%~dp0bin\%os%\sed.exe

:head
CLS
ECHO ����������ӳ�����·��,����·�����ܴ��пո�
ECHO ��1��Y:
ECHO ��2��Z:\Example
ECHO �磺��2�ļ���·��̫��,ֱ����ק�ļ��н�����
ECHO.
ECHO ����·�������س�(Enter)
SET /p imgpath=:
ECHO;%imgpath%|find " "&&goto:header
IF NOT EXIST "%imgpath%\Windows\servicing\TrustedInstaller.exe" (
CLS
ECHO �������·������ȷ�򲻴�����Чӳ��
ECHO �����ԡ���
TIMEOUT 4 >NUL
goto:head
)

::�˵�
:menu
TITLE ����----�����������
SET /A count=0
COLOR 07
CLS
ECHO. 
ECHO 1.��ȡ�����ܷ���
ECHO.
ECHO 2.��ȡ��ѡ���ܷ���
ECHO.
ECHO 3.��ȡ��ѡ�����б�
ECHO.
ECHO 4.�˳�
ECHO.
choice /C:1234 /N /M "���������ѡ�� [1,2,3,4]"��
if errorlevel 4 EXIT
if errorlevel 3 GOTO:Get-Optional-Function-List
if errorlevel 2 GOTO:Get-Optional-Function-Analysis
if errorlevel 1 GOTO:Get-Features-Analysis

::��ȡ�����ܷ���
:Get-Features-Analysis
TITLE ����----�����ܷ���----����;��,�����˳��˴��ڡ�
color 47
CLS
IF EXIST "%~dp0Offline-Remove\Offline-Features-Analysis.txt" (del /f /q "%~dp0Offline-Remove\Offline-Features-Analysis.txt")
FOR /f %%t IN ('echo %time:~0,2%:%time:~3,2%:%time:~6,2%') DO (SET sttm=%%t)
FOR /f %%i IN ('%dism% /image:%imgpath% /Format:List /English /Get-Features ^| FIND "Feature Name" ^| %sed% -e "s/Feature Name : //g"') DO (
call :time %%i
%dism% /image:%imgpath% /Format:List /English /Get-FeatureInfo /FeatureName:"%%i"|FINDSTR /c:"Feature Name" /c:"Display Name" /c:"Description" >>%~dp0Offline-Remove\Offline-Features-Analysis.txt
ECHO. >>%~dp0Offline-Remove\Offline-Features-Analysis.txt
)
TITLE ����----�����ܷ�����ɡ�
color 2F
ECHO.
ECHO �����ܷ��������ɡ�
ECHO �� Offline-Remove �ļ���
ECHO �ļ���Offline-Features-Analysis.txt
ECHO.
ECHO ��ʼʱ�䣺%sttm% ����ʱ�䣺%time:~0,2%:%time:~3,2%:%time:~6,2% ͳ�ƣ�%count%
ECHO.
ECHO ��������������˵�����
PAUSE >NUL
GOTO:menu
EXIT

::��ȡ��ѡ���ܷ���
:Get-Optional-Function-Analysis
TITLE ����----��ѡ���ܷ���----����;��,�����˳��˴��ڡ�
color 47
CLS
IF EXIST "%~dp0Offline-Remove\Offline-Optional-Function-Analysis.txt" (del /f /q "%~dp0Offline-Remove\Offline-Optional-Function-Analysis.txt")
FOR /f %%t IN ('echo %time:~0,2%:%time:~3,2%:%time:~6,2%') DO (SET sttm=%%t)
FOR /f %%i IN ('%dism% /image:%imgpath% /Format:List /English /Get-Packages ^| FIND "Package Identity" ^| %sed% -e "s/Package Identity : //g"') DO (
call :time %%i
ECHO �������ƣ�%%i | %sed% -e "s/~.*//g" >>%~dp0Offline-Remove\Offline-Optional-Function-Analysis.txt
%dism% /image:%imgpath% /Format:List /English /Get-PackageInfo /PackageName:"%%i"|FIND "Description" >>%~dp0Offline-Remove\Offline-Optional-Function-Analysis.txt
ECHO. >>%~dp0Offline-Remove\Offline-Optional-Function-Analysis.txt
)
TITLE ����----��ѡ���ܷ�����ɡ�
color 2F
ECHO.
ECHO ��ѡ���ܷ��������ɡ�
ECHO �� Offline-Remove �ļ���
ECHO �ļ���Offline-Optional-Function-Analysis.txt
ECHO.
ECHO ��ʼʱ�䣺%sttm% ����ʱ�䣺%time:~0,2%:%time:~3,2%:%time:~6,2% ͳ�ƣ�%count%
ECHO.
ECHO ��������������˵�����
PAUSE >NUL
GOTO:menu
EXIT

::��ȡ��ѡ�����б�
:Get-Optional-Function-List
CLS
ECHO ���Եȡ���
%dism% /image:%imgpath% /Format:List /English /Get-Packages | FIND "Package Identity" | %sed% -e "s/Package Identity : //g;s/~.*//g" >%~dp0Offline-Remove\Offline-Optional-Function-List.txt
CLS
ECHO ��ѡ�����б������ɡ�
ECHO �� Offline-Remove �ļ���
ECHO �ļ���Offline-Optional-Function-List.txt
ECHO.
ECHO ��������������˵�����
PAUSE >NUL
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

:time
SET /A count+=1
ECHO %time:~0,2%:%time:~3,2%:%time:~6,2% ���ڷ�����%count%�� %~1
goto:eof
