@echo OFF
::��ַ��nat.ee
::��������ҫ&���� QQ:1800619
TITLE ����----ж�ع������
mode con: cols=46 lines=16
color 17
pushd "%~dp0"
ECHO;%~0|find " "&&GOTO:errdir

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
CLS
IF "%PROCESSOR_ARCHITECTURE%" == "AMD64" (SET os=amd64) ELSE (SET os=x86)
SET nsudo=%~dp0bin\%os%\NSudoLG.exe
SET sed=%~dp0bin\%os%\sed.exe
ECHO ����ӳ��·����%imgpath%
ECHO.
ECHO 1.��ȡ����������б�
ECHO.
ECHO 2.��ȡ����������б�
ECHO.
ECHO 3.����ж��������б�
ECHO.
ECHO 4.�˳�
ECHO.
choice /C:1234 /N /M "���������ѡ�� [1,2,3,4]"��
if errorlevel 4 EXIT
if errorlevel 3 GOTO:Remove-Package
if errorlevel 2 GOTO:Get-Lite-Packages
if errorlevel 1 GOTO:Get-Full-Packages

::��ȡ����������б�
:Get-Full-Packages
dir /b %imgpath%\Windows\servicing\Packages\*.mum | %sed% "s/\.mum//g" >%~dp0Offline-Remove\Offline-Full-Packages.txt
ECHO.
ECHO ��������������б������ɡ�
ECHO �� Offline-Remove �ļ���
ECHO �ļ���Offline-Full-Packages.txt
TIMEOUT 3 >NUL
GOTO:menu
EXIT

::��ȡ����������б�
:Get-Lite-Packages
SET filter="s/~.*\.mum//g"
dir /b %imgpath%\Windows\servicing\Packages\*.mum | %sed% %filter% | %sed% "$!N; /^\(.*\)\n\1$/!P; D" >%~dp0Offline-Remove\Offline-Lite-Packages.txt
ECHO.
ECHO ��������������б������ɡ�
ECHO �� Offline-Remove �ļ���
ECHO �ļ���Offline-Lite-Packages.txt
TIMEOUT 3 >NUL
GOTO:menu
EXIT

::ɾ��������б�
:Remove-Package
IF NOT EXIST "%~dp0Offline-Remove\Offline-Remove-Package.txt" (TYPE NUL>%~dp0Offline-Remove\Offline-Remove-Package.txt)
for %%a in (%~dp0Offline-Remove\Offline-Remove-Package.txt) do (
if "%%~za" equ "0" (
CLS
ECHO ���棺Offline-Remove-Package.txt�ļ�Ϊ�գ�
ECHO ֧��ģ������������ƥ�������ж�ء�
ECHO ���ʹ�þ����б���ж�عؼ������а���
ECHO ���ʹ�������б�������ж���������
ECHO ����������б������������һ��
ECHO ���ھ���������б��ȡ�������,
ECHO �����Offline-Remove-Package.txt��һ��һ����
ECHO.
ECHO ��������������˵�����
PAUSE >NUL
GOTO:menu
EXIT
) ELSE (
CLS
%sed% -i "/^[[:space:]]*$/d;/^\s*$/d;s/[[:space:]]//g" %~dp0Offline-Remove\Offline-Remove-Package.txt
%nsudo% -U:T -P:E cmd /c "%~dp0Remove-Package.cmd Offline-Remover-Package %imgpath%"
TIMEOUT 3 >NUL
GOTO:menu
EXIT
)
)

::���ո�Ŀ¼
:errdir
CLS
ECHO %~0
ECHO ��⵽���߰�����ڴ��пո��Ŀ¼
ECHO ��ѹ��߰����ڲ����ո��Ŀ¼���������
PAUSE
EXIT