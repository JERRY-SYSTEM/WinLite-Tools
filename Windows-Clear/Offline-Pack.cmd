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
SET bcdboot=%~dp0bin\%os%\bcdboot.exe
SET dism=%~dp0bin\%os%\DISM\DISM.exe
SET imagex=%~dp0bin\%os%\DISM\imagex.exe
ECHO;%~0|find " "&&GOTO:errdir

::����
:head
CLS
ECHO ���߷�װ Windows ϵͳ
ECHO.
ECHO ʹ��ǰ�����������ļ��Ž���Ӧ�ļ���
ECHO.
ECHO ˵����
ECHO iso �ļ��У����(��1��)ISOϵͳ����
ECHO packages �ļ��У���Ų����ļ�
ECHO driver �ļ��У���������ļ�
ECHO vhd �ļ��У����(��1��).vhd��ʽ����Ӳ��
ECHO �������顭�����Ķ� _ReadMe.txt �ĵ�
ECHO.
ECHO ׼������
ECHO �����ò�����VHD����Ӳ�̷����̷�/·��
ECHO.
ECHO ���磺Z:
ECHO.
ECHO ���س���(Enter),ȷ��
SET /p diskdir=·��:
IF NOT EXIST "%diskdir%" (
CLS
ECHO ����Ӳ�̷���·�����������ԡ�
ECHO.
TIMEOUT 3 >NUL
GOTO:head
EXIT
)

::�˵�
:menu
TITLE ���߷�װϵͳ
CLS
ECHO ��ǰ����������%diskdir%
ECHO.
ECHO 1.��װϵͳ
ECHO.
ECHO 2.��װ����
ECHO.
ECHO 3.��װ����
ECHO.
ECHO 4.����ֵ��
ECHO.
ECHO 5.����wim�ļ�
ECHO.
choice /C:12345 /N /M "���������ѡ�� [1-5]"��
if errorlevel 5 GOTO:wim-file
if errorlevel 4 GOTO:apply-unattend
if errorlevel 3 GOTO:install-driver
if errorlevel 2 GOTO:install-packages
if errorlevel 1 GOTO:install-win

::��װϵͳ
:install-win
CLS
for /f %%i in ('dir /b %~dp0iso^|findstr "^.*\.iso$"') do (set winisofile=%%i)
IF NOT EXIST "%~dp0iso\install.wim" (
IF DEFINED winisofile (
ECHO ������ȡ install.wim �ļ�
%~dp0bin\%os%\7z.exe e -y "%~dp0iso\%winisofile%" "sources\install.wim" -o"%~dp0iso"
IF NOT EXIST "%~dp0iso\install.wim" (
CLS
ECHO.
ECHO ���棺
ECHO %winisofile%
ECHO ������Ч��Windows ISO �����ļ���
ECHO û����ȡ�� install.wim �ļ���
ECHO �����ԡ���
ECHO.
PAUSE
GOTO:menu
EXIT
)
ECHO.
ECHO ��ȡ��ɡ�
ECHO.
TIMEOUT 3 >NUL
)ELSE (
CLS
ECHO.
ECHO ϵͳ����ISO�ļ������ڣ���������Windowsϵͳ����
ECHO �����غõ�ISOϵͳ���񣬸��Ƶ� iso �ļ��С�
ECHO ע�⣺iso �ļ��У�ֻ�ܴ���һ��.iso�ļ���
ECHO.
PAUSE
GOTO:menu
EXIT
)
)
CLS
%Dism% /Get-ImageInfo /ImageFile:"%~dp0iso\install.wim"||ECHO.&&PAUSE&&GOTO:menu
ECHO.
ECHO ���س���(Enter),ȷ��
SET /p ov=�����밲װ���������֣�
ECHO.
%imagex% /apply "%~dp0iso\install.wim" "%ov%" "%diskdir%"||ECHO.&&PAUSE&&GOTO:menu
:: %bcdboot% "%diskdir%\Windows" /s "%diskdir%" /f BIOS /l zh-CN
ECHO ��װ��ɡ�
ECHO.
TIMEOUT 3 >NUL
GOTO:menu
EXIT

::��װ����
:install-packages
CLS
IF EXIST "%diskdir%\Windows\servicing\Packages" (
%Dism% /Image:"%diskdir%" /Add-Package /PackagePath:"%~dp0packages" /IgnoreCheck||ECHO.&&PAUSE&&GOTO:menu
)ELSE (
CLS
ECHO ϵͳ�����޷���װ�����������ԣ�
ECHO.
TIMEOUT 5 >NUL
GOTO:menu
EXIT
)


::��װ����
:install-driver
CLS
IF EXIST "%diskdir%\Windows\System32\drivers" (
%Dism% /Image:"%diskdir%" /Add-Driver /Driver:%~dp0driver /Recurse /ForceUnsigned||ECHO.&&PAUSE&&GOTO:menu
)ELSE (
CLS
ECHO ϵͳ�����޷���װ�����������ԣ�
ECHO.
TIMEOUT 5 >NUL
GOTO:menu
EXIT
)


::����ֵ��
:apply-unattend
CLS
ECHO Windowsϵͳ-�������ֵ��
ECHO.
ECHO ��Administrator�������Զ���¼
ECHO.
ECHO 1.Windows 7 32λ
ECHO 2.Windows 7 64λ
ECHO 3.Windows 8.1 32λ
ECHO 4.Windows 8.1 64λ
ECHO 5.Windows 10 32λ
ECHO 6.Windows 10 64λ
ECHO.
SET /p winauto=������ѡ�񣬰��س���
IF "%winauto%" == "1" (SET unattend=Windows7x86.xml)
IF "%winauto%" == "2" (SET unattend=Windows7amd64.xml)
IF "%winauto%" == "3" (SET unattend=Windows8.1x86.xml)
IF "%winauto%" == "4" (SET unattend=Windows8.1amd64.xml)
IF "%winauto%" == "5" (SET unattend=Windows10x86.xml)
IF "%winauto%" == "6" (SET unattend=Windows10amd64.xml)
CLS
IF EXIST "%diskdir%\Windows\System32\sysprep\sysprep.exe" (
ECHO �����������ֵ�ء���
ECHO.
RMDIR /s /q "%diskdir%\Windows\Panther" 1>nul 2>nul
MD "%diskdir%\Windows\Panther" 1>nul 2>nul
COPY /y "%~dp0bin\unattend\%unattend%" "%diskdir%\Windows\Panther\Unattend.xml"
ECHO.
ECHO �����ɡ�
ECHO.
TIMEOUT 3 >NUL
GOTO:menu
EXIT
)ELSE (
CLS
ECHO.
ECHO ϵͳ�����޷���ӣ������ԡ�
ECHO.
TIMEOUT 5 >NUL
GOTO:menu
EXIT
)

:wim-file
CLS
TITLE ѹ�����ɹ�����,�����˳��˴��ڡ�
ECHO ѹ���ļ���.....
for /f %%t in ('echo %time:~0,2%%time:~3,2%%time:~6,2%') DO (SET newtime=%%t)
%imagex% /capture "%diskdir%" "%~dp0\export\%newtime%-install.wim" "Windows" /COMPRESS maximum||PAUSE&&GOTO:menu
ECHO ѹ�������ļ���ɡ�
ECHO �� export �ļ���
ECHO �ļ���%newtime%-install.wim
ECHO.
PAUSE
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
