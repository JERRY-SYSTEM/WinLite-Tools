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
IF NOT EXIST "%imgpath%\Windows\servicing\TrustedInstaller.exe" (
CLS
ECHO �������·��Ŀ¼����ȷ�򲻴�����Чӳ��
ECHO �����ԡ���
TIMEOUT 4 >NUL
goto:head
)

::�˵�
:menu
TITLE ����----ж�ذ��蹦��
SET /A count=0
COLOR 07
CLS
ECHO ����ӳ��·����%imgpath%
ECHO.
ECHO 1.��ȡ���蹦���б�
ECHO.
ECHO 2.�������蹦���б�
ECHO.
ECHO 3.����ж�ذ��蹦��
ECHO.
ECHO 4.�˳�
ECHO.
choice /C:1234 /N /M "���������ѡ�� [1,2,3,4]"��
if errorlevel 4 EXIT
if errorlevel 3 GOTO:Capability-Remove
if errorlevel 2 GOTO:Capability-Analysis
if errorlevel 1 GOTO:Capability-Get

::��ȡ���蹦���б�
:Capability-Get
CLS
ECHO ���Եȡ���
%dism% /Image:%imgpath% /Format:List /English /Get-Capabilities | FIND "Capability Identity" | %sed% -e "s/Capability Identity : //g;s/~*[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*//g" >%~dp0Offline-Remove\Offline-List-Capability.txt
CLS
ECHO.
ECHO ���蹦���б��б������ɡ�
ECHO �� Offline-Remove �ļ���
ECHO �ļ���Offline-List-Capability.txt
ECHO.
ECHO ��������������˵�����
PAUSE >NUL
GOTO:menu
EXIT

::�������蹦���б�
:Capability-Analysis
TITLE ����----���蹦�ܷ���----����;��,�����˳��˴��ڡ�
color 47
CLS
IF EXIST "%~dp0Offline-Remove\Offline-Capability-Analysis.txt" (del /f /q "%~dp0Offline-Remove\Offline-Capability-Analysis.txt")
FOR /f %%t IN ('echo %time:~0,2%:%time:~3,2%:%time:~6,2%') DO (SET sttm=%%t)
FOR /f %%i IN ('%dism% /Image:%imgpath% /Format:List /English /Get-Capabilities ^| FIND "Capability Identity" ^| %sed% -e "s/Capability Identity : //g" 2^>nul') DO (
call :time1 %%i
ECHO �������ƣ�%%i | %sed% -e "s/~*[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*//g" >>%~dp0Offline-Remove\Offline-Capability-Analysis.txt
%dism% /Image:%imgpath% /Format:List /English /Get-CapabilityInfo /CapabilityName:"%%i" | FINDSTR /c:"Display Name" /c:"Description" >>%~dp0Offline-Remove\Offline-Capability-Analysis.txt
ECHO. >>%~dp0Offline-RemoveOffline-Capability-Analysis.txt
)
TITLE ����----���蹦�ܷ�����ɡ�
color 2F
ECHO.
ECHO �����ܷ��������ɡ�
ECHO �� Offline-Remove �ļ���
ECHO �ļ���Offline-Capability-Analysis.txt
ECHO.
ECHO ��ʼʱ�䣺%sttm% ����ʱ�䣺%time:~0,2%:%time:~3,2%:%time:~6,2% ͳ�ƣ�%count%
ECHO.
ECHO ��������������˵�����
PAUSE >NUL
GOTO:menu
EXIT

::����ж�ذ��蹦��
:Capability-Remove
TITLE ����----ж�ذ��蹦��----ж��;��,�����˳��˴��ڡ�
color 47
IF NOT EXIST "%~dp0Offline-Remove\Offline-Remove-Capability.txt" (TYPE NUL>%~dp0Offline-Remove\Offline-Remove-Capability.txt)
for %%a in (%~dp0Offline-Remove\Offline-Remove-Capability.txt) do (
if "%%~za" equ "0" (
CLS
ECHO ���棺Offline-Remove-Capability.txt�ļ�Ϊ�գ�
ECHO ֧��ģ������������ƥ�䰴�蹦��ж�ء�
ECHO ����Offline-List-Capability.txt��ȡ���蹦����,
ECHO �����Offline-Remove-Capability.txt��һ��һ����
ECHO.
ECHO ��������������˵�����
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
TITLE ����----ж�ذ��蹦����ɡ�
color 2F
ECHO.
ECHO ж����ɡ�
ECHO.
ECHO ��ʼʱ�䣺%sttm% ����ʱ�䣺%time:~0,2%:%time:~3,2%:%time:~6,2% ͳ�ƣ�%count%
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

:time1
SET /A count+=1
ECHO %time:~0,2%:%time:~3,2%:%time:~6,2% ���ڷ�����%count%�� %~1
goto:eof

:time2
SET /A count+=1
ECHO %time:~0,2%:%time:~3,2%:%time:~6,2% ����ж�ص�%count%�� %~1
goto:eof