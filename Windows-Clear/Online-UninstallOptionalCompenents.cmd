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

::�˵�
:menu
TITLE ����----ж�ذ��蹦��
SET /A count=0
COLOR 07
CLS
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
%dism% /Online /Format:List /English /Get-Capabilities | FIND "Capability Identity" | %sed% -e "s/Capability Identity : //g;s/~*[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*//g" >%~dp0Online-Remove\Online-List-Capability.txt
CLS
ECHO.
ECHO ���蹦���б��б������ɡ�
ECHO �� Online-Remove �ļ���
ECHO �ļ���Online-List-Capability.txt
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
IF EXIST "%~dp0Online-Remove\Online-Capability-Analysis.txt" (del /f /q "%~dp0Online-Remove\Online-Capability-Analysis.txt")
FOR /f %%t IN ('echo %time:~0,2%:%time:~3,2%:%time:~6,2%') DO (SET sttm=%%t)
FOR /f %%i IN ('%dism% /Online /Format:List /English /Get-Capabilities ^| FIND "Capability Identity" ^| %sed% -e "s/Capability Identity : //g" 2^>nul') DO (
call :time1 %%i
ECHO �������ƣ�%%i | %sed% -e "s/~*[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*//g" >>%~dp0Online-Remove\Online-Capability-Analysis.txt
%dism% /Online /Format:List /English /Get-CapabilityInfo /CapabilityName:"%%i" | FINDSTR /c:"Display Name" /c:"Description" >>%~dp0Online-Remove\Online-Capability-Analysis.txt
ECHO. >>%~dp0Online-Remove\Online-Capability-Analysis.txt
)
TITLE ����----���蹦�ܷ�����ɡ�
color 2F
ECHO.
ECHO �����ܷ��������ɡ�
ECHO �� Online-Remove �ļ���
ECHO �ļ���Online-Capability-Analysis.txt
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
IF NOT EXIST "%~dp0Online-Remove\Online-Remove-Capability.txt" (TYPE NUL>%~dp0Online-Remove\Online-Remove-Capability.txt)
for %%a in (%~dp0Online-Remove\Online-Remove-Capability.txt) do (
if "%%~za" equ "0" (
CLS
ECHO ���棺Online-Remove-Capability.txt�ļ�Ϊ�գ�
ECHO ֧��ģ������������ƥ�䰴�蹦��ж�ء�
ECHO ����Online-List-Capability.txt��ȡ���蹦����,
ECHO �����Online-Remove-Capability.txt��һ��һ����
ECHO.
ECHO ��������������˵�����
PAUSE >NUL
GOTO:menu
EXIT
)
)
CLS
FOR /f %%t IN ('echo %time:~0,2%:%time:~3,2%:%time:~6,2%') DO (SET sttm=%%t)
%sed% -i "/^[[:space:]]*$/d;/^\s*$/d;s/[[:space:]]//g" %~dp0Online-Remove\Online-Remove-Capability.txt
FOR /f %%i IN ('%dism% /Online /Format:List /English /Get-Capabilities ^| FIND "Capability Identity" ^| %sed% -e "s/Capability Identity : //g" 2^>nul ^| FINDSTR /i /g:%~dp0Online-Remove\Online-Remove-Capability.txt 2^>nul') DO (
call :time2 %%i
%dism% /Online /Remove-Capability /CapabilityName:"%%i"
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