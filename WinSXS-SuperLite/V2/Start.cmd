@echo OFF
::��ַ��nat.ee
::QQȺ��6281379
::TGȺ��https://t.me/nat_ee
::��������ҫ&���� QQ:1800619
IF "%PROCESSOR_ARCHITECTURE%" == "AMD64" (SET os=amd64) ELSE (SET os=x86)
SET nsudo=%~dp0bin\%os%\NSudoLG.exe

TITLE WinSxS-�������� ---- nat.ee
pushd "%~dp0"
ECHO;%SystemPath%|find " "&&goto:errdir

:head
CLS
ECHO ɾ���з��գ���ʹ�ü�����е����գ��������޹ء�
ECHO.
ECHO ������ϵͳ����·��,����·�����ܴ��пո�
ECHO ��1��Y:\Windows ���룺Y:
ECHO ��2��Z:\Example\Windows ���룺Z:\Example\
ECHO �磺��2�ļ���·��̫��,ֱ����ק�ļ��н�����
ECHO ���������·�������ܴ��пո�����ģ�
ECHO.
ECHO ����·�������س���(Enter)
SET /p SystemPath=:
REM IF /i "%SystemPath%" == "%SystemDrive%" (goto:head)
IF NOT EXIST "%SystemPath%\Windows\WinSxS" (
CLS
ECHO �������·������ȷ�򲻴�����Чӳ��
ECHO �����ԡ���
TIMEOUT 4 >NUL
goto:head
) ELSE (GOTO:menu)

:menu
IF NOT EXIST "%~dp0winsxslist.txt" (TYPE NUL>%~dp0winsxslist.txt)
for %%a in (%~dp0winsxslist.txt) do (
if "%%~za" equ "0" (
CLS
ECHO ���棺winsxslist.txt�ļ�Ϊ�գ�
ECHO ����д��Ҫ�������ļ�������,
ECHO �����winsxslist.txt��һ��һ����
ECHO.
ECHO ��������˳�����
PAUSE >NUL
EXIT
) ELSE (GOTO:Remove)
)

:Remove
%nsudo% -U:T -P:E cmd /c "%~dp0core.cmd %SystemPath%"
EXIT

::���ո�Ŀ¼
:errdir
CLS
ECHO %~0
ECHO ��⵽���߰�����ڴ��пո��Ŀ¼
ECHO ��ѹ��߰����ڲ����ո��Ŀ¼���������
PAUSE
EXIT