@ECHO OFF
::��ַ��nat.ee
::��������ҫ&���� QQ:1800619
TITLE ����----ж�ع������
mode con: cols=46 lines=16
color 17
pushd "%~dp0"
ECHO;%~0|find " "&&GOTO:errdir

::�˵�
:menu
CLS
IF "%PROCESSOR_ARCHITECTURE%" == "AMD64" (SET os=amd64) ELSE (SET os=x86)
SET nsudo=%~dp0bin\%os%\NSudoLG.exe
SET sed=%~dp0bin\%os%\sed.exe
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
dir /b %SystemDrive%\Windows\servicing\Packages\*.mum | %sed% "s/\.mum//g" >%~dp0Online-Remove\Online-Full-Packages.txt
ECHO.
ECHO ����������б������ɡ�
ECHO �� Online-Remove �ļ���
ECHO �ļ���Online-Full-Packages.txt
TIMEOUT 3 >NUL
GOTO:menu
EXIT

::��ȡ����������б�
:Get-Lite-Packages
SET filter="s/~.*\.mum//g"
dir /b %SystemDrive%\Windows\servicing\Packages\*.mum | %sed% %filter% | %sed% "$!N; /^\(.*\)\n\1$/!P; D" >%~dp0Online-Remove\Online-Lite-Packages.txt
ECHO.
ECHO ����������б������ɡ�
ECHO �� Online-Remove �ļ���
ECHO �ļ���Online-Lite-Packages.txt
TIMEOUT 3 >NUL
GOTO:menu
EXIT

::ɾ��������б�
:Remove-Package
IF NOT EXIST "%~dp0Online-Remove\Online-Remove-Package.txt" (TYPE NUL>%~dp0Online-Remove\Online-Remove-Package.txt)
for %%a in (%~dp0Online-Remove\Online-Remove-Package.txt) do (
if "%%~za" equ "0" (
CLS
ECHO ���棺Online-Remove-Package.txt�ļ�Ϊ�գ�
ECHO ֧��ģ������������ƥ�������ж�ء�
ECHO ���ʹ�þ����б���ж�عؼ������а���
ECHO ���ʹ�������б�������ж���������
ECHO ����������б������������һ��
ECHO ���ھ���������б��ȡ�������,
ECHO �����Online-Remove-Package.txt��һ��һ����
ECHO.
ECHO ��������������˵�����
PAUSE >NUL
GOTO:menu
EXIT
) ELSE (
CLS
%sed% -i "/^[[:space:]]*$/d;/^\s*$/d;s/[[:space:]]//g" %~dp0Online-Remove\Online-Remove-Package.txt
%nsudo% -U:T -P:E cmd /c "%~dp0Remove-Package.cmd Online-Remover-Package"
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