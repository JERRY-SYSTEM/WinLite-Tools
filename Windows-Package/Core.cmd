@ECHO OFF
::��ַ��nat.ee
::��������ҫ&���� QQ:1800619
color 47
if "%~1" == "" (EXIT)
pushd "%~dp0"
IF "%PROCESSOR_ARCHITECTURE%" == "AMD64" (SET os=amd64) ELSE (SET os=x86)
SET dism=dism
SET sed=%~dp0bin\%os%\sed.exe
SET /A count=0
FOR /f %%t IN ('echo %time:~0,2%:%time:~3,2%:%time:~6,2%') DO (SET sttm=%%t)
if "%~1" == "Remover-Package" (GOTO:Remover-Package)

::ɾ�����
:Remover-Package
TITLE ɾ����������б�----ж��;��,�����˳��˴��ڡ�
SET imgpath=%SystemDrive%
ECHO �޸����ע�����,���Եȡ���
FOR /f %%i IN ('dir /b %imgpath%\Windows\servicing\Packages\*.mum ^| %sed% "s/\.mum//g" 2^>nul ^| FINDSTR /i /g:%~dp0Package\Remove-Package.txt 2^>nul') DO (
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\%%~i" /v "Visibility" /t "REG_DWORD" /d "1" /f 1>NUL 2>NUL 
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\%%~i\Owners" /f 1>NUL 2>NUL 
)
TIMEOUT 2 >NUL
ECHO.
ECHO ��ʼж���������
FOR /f %%i IN ('dir /b %imgpath%\Windows\servicing\Packages\*.mum ^| %sed% "s/\.mum//g" 2^>nul ^| FINDSTR /i /g:%~dp0Package\Remove-Package.txt 2^>nul') DO (
call :time %%i
%dism% /NoRestart /online /Remove-package /Packagename:%%i
ECHO.
)
TITLE ɾ�����������ɡ�
color 2F
ECHO ��ɡ�
ECHO.
ECHO ��ʼʱ�䣺%sttm% ����ʱ�䣺%time:~0,2%:%time:~3,2%:%time:~6,2% ͳ�ƣ�%count%
ECHO.��
ECHO ��������˳�����
PAUSE >NUL
EXIT

:time
SET /A count+=1
ECHO %time:~0,2%:%time:~3,2%:%time:~6,2% ͳ�ƣ���%count%�� %~1
goto:eof