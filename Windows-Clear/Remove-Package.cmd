@ECHO OFF
::��ַ��nat.ee
::��������ҫ&���� QQ:1800619
color 47
if "%~1" == "" (EXIT)
pushd "%~dp0"
IF "%PROCESSOR_ARCHITECTURE%" == "AMD64" (SET os=amd64) ELSE (SET os=x86)
SET dism=%~dp0bin\%os%\DISM\DISM.exe
SET sed=%~dp0bin\%os%\sed.exe
SET /A count=0
FOR /f %%t IN ('echo %time:~0,2%:%time:~3,2%:%time:~6,2%') DO (SET sttm=%%t)
if "%~1" == "Online-Remover-Package" (GOTO:Online-Remover-Package)
if "%~1" == "Offline-Remover-Package" (GOTO:Offline-Remover-Package)

::����ж�����
:Online-Remover-Package
TITLE ����----ж�ع�������б�----ж��;��,�����˳��˴��ڡ�
SET imgpath=%SystemDrive%
ECHO �������ע�����,���Եȡ���
FOR /f %%i IN ('dir /b %imgpath%\Windows\servicing\Packages\*.mum ^| %sed% "s/\.mum//g" 2^>nul ^| FINDSTR /i /g:%~dp0Online-Remove\Online-Remove-Package.txt 2^>nul') DO (
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\%%~i" /v "Visibility" /t "REG_DWORD" /d "1" /f 1>NUL 2>NUL 
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\%%~i\Owners" /f 1>NUL 2>NUL 
)
TIMEOUT 2 >NUL
ECHO.
ECHO ��ʼж���������
FOR /f %%i IN ('dir /b %imgpath%\Windows\servicing\Packages\*.mum ^| %sed% "s/\.mum//g" 2^>nul ^| FINDSTR /i /g:%~dp0Online-Remove\Online-Remove-Package.txt 2^>nul') DO (
call :time %%i
%dism% /NoRestart /online /Remove-package /Packagename:%%i
ECHO.
)
TITLE ����----ж�ع��������ɡ�
color 2F
ECHO ��ɡ�
ECHO.
ECHO ��ʼʱ�䣺%sttm% ����ʱ�䣺%time:~0,2%:%time:~3,2%:%time:~6,2% ͳ�ƣ�%count%
ECHO.��
ECHO ��������˳�����
PAUSE >NUL
EXIT

::����ж�����
:Offline-Remover-Package
TITLE ����----����ж�ع�������б�----ж��;��,�����˳��˴��ڡ�
SET imgpath=%~2
reg unload "HKLM\Temp" 1>NUL 2>NUL
ECHO ��������ע�����,���Եȡ���
reg load "HKLM\Temp" "%imgpath%\Windows\System32\config\software" 1>NUL 2>NUL
TIMEOUT 5 >NUL
ECHO.
ECHO �������ע�����,���Եȡ���
FOR /f %%i IN ('dir /b %imgpath%\Windows\servicing\Packages\*.mum ^| %sed% "s/\.mum//g" 2^>nul ^| FINDSTR /i /g:%~dp0Offline-Remove\Offline-Remove-Package.txt 2^>nul') DO (
reg add "HKLM\Temp\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\%%~i" /v "Visibility" /t "REG_DWORD" /d "1" /f 1>NUL 2>NUL 
reg delete "HKLM\Temp\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\%%~i\Owners" /f 1>NUL 2>NUL 
)
TIMEOUT 2 >NUL
reg unload "HKLM\Temp" 1>NUL 2>NUL
ECHO.
ECHO ��ʼж���������
FOR /f %%i IN ('dir /b %imgpath%\Windows\servicing\Packages\*.mum ^| %sed% "s/\.mum//g" 2^>nul ^| FINDSTR /i /g:%~dp0Offline-Remove\Offline-Remove-Package.txt 2^>nul') DO (
call :time %%i
%dism% /NoRestart /image:%imgpath% /Remove-package /Packagename:%%i
ECHO.
)
TITLE ����----ж�ع��������ɡ�
color 2F
ECHO ��ɡ�
ECHO.
ECHO ��ʼʱ�䣺%sttm% ����ʱ�䣺%time:~0,2%:%time:~3,2%:%time:~6,2% ͳ�ƣ�%count%
ECHO.
ECHO ��������˳�����
PAUSE >NUL
EXIT

:time
SET /A count+=1
ECHO %time:~0,2%:%time:~3,2%:%time:~6,2% ͳ�ƣ���%count%�� %~1
goto:eof