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
SET /A count=0
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
IF NOT EXIST "%imgpath%\Windows\WinSxS\" (
CLS
ECHO �������·��Ŀ¼����ȷ�򲻴�����Чӳ��
ECHO �����ԡ���
TIMEOUT 4 >NUL
goto:head
)

::�˵�
:menu
TITLE ����----ж��AppxӦ��
COLOR 07
CLS
ECHO ����ӳ��·����%imgpath%
ECHO.
ECHO 1.��ȡAppxӦ���б�
ECHO.
ECHO 2.����ж��AppxӦ��
ECHO.
ECHO 3.�˳�
ECHO.
choice /C:123 /N /M "���������ѡ�� [1,2,3]"��
if errorlevel 3 EXIT
if errorlevel 2 GOTO:AppxPackages-Remove
if errorlevel 1 GOTO:AppxPackages-Get


::��ȡAppxӦ���б�
:AppxPackages-Get
CLS
ECHO ���Եȡ���
%dism% /Image:%imgpath% /Format:List /English /Get-ProvisionedAppxPackages | FIND "PackageName" | %sed% -e "s/PackageName : //g;s/_.*//g" >%~dp0Offline-Remove\Offline-List-Appx.txt
CLS
ECHO.
ECHO AppxӦ���б��б������ɡ�
ECHO �� Offline-Remove �ļ���
ECHO �ļ���Offline-List-Appx.txt
ECHO.
ECHO ��������������˵�����
PAUSE >NUL
GOTO:menu
EXIT

::����ж��AppxӦ��
:AppxPackages-Remove
IF NOT EXIST "%~dp0Offline-Remove\Offline-Remove-Appx.txt" (TYPE NUL>%~dp0Offline-Remove\Offline-Remove-Appx.txt)
for %%a in (%~dp0Offline-Remove\Offline-Appx-Remove.txt) do (
if "%%~za" equ "0" (
CLS
ECHO ���棺Offline-Remove-Appx.txt�ļ�Ϊ�գ�
ECHO ֧��ģ������������ƥ��AppxӦ��ж�ء�
ECHO ����Offline-List-Appx.txt��ȡAppxӦ����,
ECHO �����Offline-Remove-Appx.txt��һ��һ����
ECHO.
ECHO ��������������˵�����
PAUSE >NUL
GOTO:menu
EXIT
)
)
CLS
TITLE ����----ж��AppxӦ��;��,�����˳��˴��ڡ�
color 47
FOR /f %%t IN ('echo %time:~0,2%:%time:~3,2%:%time:~6,2%') DO (SET sttm=%%t)
%sed% -i "/^[[:space:]]*$/d;/^\s*$/d;s/[[:space:]]//g" %~dp0Offline-Remove\Offline-Remove-Appx.txt
FOR /f %%i IN ('%dism% /Image:%imgpath% /Format:List /English /Get-ProvisionedAppxPackages ^| FIND "PackageName" ^| %sed% -e "s/PackageName : //g" 2^>nul ^| FINDSTR /i /g:%~dp0Offline-Remove\Offline-Remove-Appx.txt 2^>nul') DO (
call :time %%i
%dism% /Image:%imgpath% /Remove-ProvisionedAppxPackage /PackageName:%%i
ECHO.
)
TITLE ����----ж��AppxӦ����ɡ�
color 2F
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

:time
SET /A count+=1
ECHO %time:~0,2%:%time:~3,2%:%time:~6,2% ����ж�ص�%count%����%~1
goto:eof
