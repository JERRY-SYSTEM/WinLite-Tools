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
SET sed=%~dp0bin\%os%\sed.exe

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
IF EXIST "%~dp0Online-Remove\Online-Features-Analysis.txt" (del /f /q "%~dp0Online-Remove\Online-Features-Analysis.txt")
FOR /f %%t IN ('echo %time:~0,2%:%time:~3,2%:%time:~6,2%') DO (SET sttm=%%t)
FOR /f %%i IN ('%dism% /online /English /Format:List /Get-Features ^| FIND "Feature Name" ^| %sed% -e "s/Feature Name : //g"') DO (
call :time %%i
%dism% /online /English /Format:List /Get-FeatureInfo /FeatureName:"%%i"|FINDSTR /c:"Feature Name" /c:"Display Name" /c:"Description" >>%~dp0Online-Remove\Online-Features-Analysis.txt
ECHO. >>%~dp0Online-Remove\Online-Features-Analysis.txt
)
TITLE ����----�����ܷ�����ɡ�
color 2F
ECHO.
ECHO �����ܷ��������ɡ�
ECHO �� Online-Remove �ļ���
ECHO �ļ���Online-Features-Analysis.txt
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
IF EXIST "%~dp0Online-Remove\Online-Optional-Function-Analysis.txt" (del /f /q "%~dp0Online-Remove\Online-Optional-Function-Analysis.txt")
FOR /f %%t IN ('echo %time:~0,2%:%time:~3,2%:%time:~6,2%') DO (SET sttm=%%t)
FOR /f %%i IN ('%dism% /Online /English /Format:List /Get-Packages ^| FIND "Package Identity" ^| %sed% -e "s/Package Identity : //g"') DO (
call :time %%i
ECHO �������ƣ�%%i | %sed% -e "s/~.*//g" >>%~dp0Online-Remove\Online-Optional-Function-Analysis.txt
%dism% /Online /English /Format:List /Get-PackageInfo /PackageName:"%%i"|FIND "Description" >>%~dp0Online-Remove\Online-Optional-Function-Analysis.txt
ECHO. >>%~dp0Online-Remove\Online-Optional-Function-Analysis.txt
)
TITLE ����----��ѡ���ܷ�����ɡ�
color 2F
ECHO.
ECHO ��ѡ���ܷ��������ɡ�
ECHO �� Online-Remove �ļ���
ECHO �ļ���Online-Optional-Function-Analysis.txt
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
%dism% /Online /English /Format:List /Get-Packages | FIND "Package Identity" | %sed% -e "s/Package Identity : //g;s/~.*//g" >%~dp0Online-Remove\Online-Optional-Function-List.txt
CLS
ECHO ��ѡ�����б������ɡ�
ECHO �� Online-Remove �ļ���
ECHO �ļ���Online-Optional-Function-List.txt
ECHO.
ECHO ��������������˵�����
PAUSE >NUL
GOTO:menu
EXIT

:time
SET /A count+=1
ECHO %time:~0,2%:%time:~3,2%:%time:~6,2% ���ڷ�����%count%�� %~1
goto:eof
