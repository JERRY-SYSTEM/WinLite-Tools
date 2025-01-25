@ECHO OFF
::��ַ��nat.ee
::��������ҫ&���� QQ:1800619
mode con: cols=24 lines=14
color 2F
pushd "%~dp0"
IF "%PROCESSOR_ARCHITECTURE%" == "AMD64" (SET os=amd64) ELSE (SET os=x86)
SET nsudo=%~dp0bin\%os%\NSudoLG.exe
SET sed=%~dp0bin\%os%\sed.exe

::Sessions�ļ���·��
SET spath=%windir%\servicing\Sessions
::���˾����б�
SET filter1="s/.*<package id=//g;s/.*<Install package=//g;s/.*<Unproject package=//g;s/ update=.*>.*//g;s/~.*//g;s/ name=.*>.*//g"
::���������б�
SET filter2="s/.*<package id=//g;s/.*<Install package=//g;s/.*<Unproject package=//g;s/ update=.*>.*//g;s/ name=.*>.*//g"
::ɾ���ظ�
SET filter3="$!N; /^\(.*\)\n\1$/!P; D"
::ɾ���ո�
SET filter4="/^[[:space:]]*$/d;/^\s*$/d;s/[[:space:]]//g"

::���˵�
:menu
CLS
ECHO 1.��ȡ��������б�
ECHO.
ECHO 2.��ȡ��������б�
ECHO.
ECHO 3.��Windows ����
ECHO.
ECHO 4.����Ự��¼�ļ�
ECHO.
choice /C:1234 /N /M "���������ѡ��[1-4]"��
if errorlevel 4 GOTO:Cleanup-Session-Files
if errorlevel 3 GOTO:Open-Features
if errorlevel 2 GOTO:Get-Lite-Packages
if errorlevel 1 GOTO:Get-Full-Packages

::��ȡ��������б�
:Get-Full-Packages
IF NOT EXIST "%spath%\Sessions.xml" (
ECHO.
ECHO �Ự��¼�ļ��ѱ�����
ECHO �����¿�����رչ��ܣ�
ECHO �Ա㱾�����ȡ���б�
TIMEOUT 5 >NUL
GOTO:menu
)
IF EXIST "%~dp0Package\Find-Full-Packages.txt" (DEL /f /q "%~dp0Package\Find-Full-Packages.txt" 1>NUL 2>NUL)
for /f "delims=" %%i in ('FINDSTR /c:"package id=" /c:"Install package=" /c:"Unproject package=" %spath%\Sessions.xml 2^>nul^|%sed% %filter2% 2^>nul^|sort 2^>nul') do (ECHO %%~i >>%~dp0Package\Find-Full-Packages.txt)
%sed% -i %filter3% %~dp0Package\Find-Full-Packages.txt 1>NUL 2>NUL
%sed% -i %filter4% %~dp0Package\Find-Full-Packages.txt 1>NUL 2>NUL
ECHO.
ECHO �� Package �ļ���
ECHO �ļ���Find-Full-Packages.txt
TIMEOUT 3 >NUL
GOTO:menu

::��ȡ��������б�
:Get-Lite-Packages
IF NOT EXIST "%spath%\Sessions.xml" (
ECHO.
ECHO �Ự��¼�ļ��ѱ�����
ECHO �����¿�����رչ��ܣ�
ECHO �Ա㱾�����ȡ���б�
TIMEOUT 5 >NUL
GOTO:menu
)
IF EXIST "%~dp0Package\Find-Lite-Packages.txt" (DEL /f /q "%~dp0Package\Find-Lite-Packages.txt" 1>NUL 2>NUL)
for /f "delims=" %%i in ('FINDSTR /c:"package id=" /c:"Install package=" /c:"Unproject package=" %spath%\Sessions.xml 2^>nul^|%sed% %filter1% 2^>nul^|sort 2^>nul') do (ECHO %%~i >>%~dp0Package\Find-Lite-Packages.txt)
%sed% -i %filter3% %~dp0Package\Find-Lite-Packages.txt 1>NUL 2>NUL
%sed% -i %filter4% %~dp0Package\Find-Lite-Packages.txt 1>NUL 2>NUL
ECHO.
ECHO �� Package �ļ���
ECHO �ļ���Find-Lite-Packages.txt
TIMEOUT 3 >NUL
GOTO:menu

::��Windows ����
:Open-Features
START optionalfeatures 1>NUL 2>NUL
GOTO:menu

::����Ự��¼�ļ�
:Cleanup-Session-Files
%nsudo% -U:T -P:E -ShowWindowMode:Hide cmd /c "DEL /f /q %spath%\*.xml 1>NUL 2>NUL"
ECHO.
ECHO ����Ự��¼�ļ���ɡ�
TIMEOUT 3 >NUL
GOTO:menu