@ECHO OFF
::网址：nat.ee
::批处理：荣耀&制作 QQ:1800619
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

::在线卸载组件
:Online-Remover-Package
TITLE 在线----卸载功能组件列表----卸载途中,请勿退出此窗口。
SET imgpath=%SystemDrive%
ECHO 清理组件注册表中,请稍等……
FOR /f %%i IN ('dir /b %imgpath%\Windows\servicing\Packages\*.mum ^| %sed% "s/\.mum//g" 2^>nul ^| FINDSTR /i /g:%~dp0Online-Remove\Online-Remove-Package.txt 2^>nul') DO (
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\%%~i" /v "Visibility" /t "REG_DWORD" /d "1" /f 1>NUL 2>NUL 
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\%%~i\Owners" /f 1>NUL 2>NUL 
)
TIMEOUT 2 >NUL
ECHO.
ECHO 开始卸载组件……
FOR /f %%i IN ('dir /b %imgpath%\Windows\servicing\Packages\*.mum ^| %sed% "s/\.mum//g" 2^>nul ^| FINDSTR /i /g:%~dp0Online-Remove\Online-Remove-Package.txt 2^>nul') DO (
call :time %%i
%dism% /NoRestart /online /Remove-package /Packagename:%%i
ECHO.
)
TITLE 在线----卸载功能组件完成。
color 2F
ECHO 完成。
ECHO.
ECHO 开始时间：%sttm% 结束时间：%time:~0,2%:%time:~3,2%:%time:~6,2% 统计：%count%
ECHO.。
ECHO 按任意键退出……
PAUSE >NUL
EXIT

::离线卸载组件
:Offline-Remover-Package
TITLE 在线----离线卸载功能组件列表----卸载途中,请勿退出此窗口。
SET imgpath=%~2
reg unload "HKLM\Temp" 1>NUL 2>NUL
ECHO 挂载离线注册表中,请稍等……
reg load "HKLM\Temp" "%imgpath%\Windows\System32\config\software" 1>NUL 2>NUL
TIMEOUT 5 >NUL
ECHO.
ECHO 清理组件注册表中,请稍等……
FOR /f %%i IN ('dir /b %imgpath%\Windows\servicing\Packages\*.mum ^| %sed% "s/\.mum//g" 2^>nul ^| FINDSTR /i /g:%~dp0Offline-Remove\Offline-Remove-Package.txt 2^>nul') DO (
reg add "HKLM\Temp\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\%%~i" /v "Visibility" /t "REG_DWORD" /d "1" /f 1>NUL 2>NUL 
reg delete "HKLM\Temp\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\%%~i\Owners" /f 1>NUL 2>NUL 
)
TIMEOUT 2 >NUL
reg unload "HKLM\Temp" 1>NUL 2>NUL
ECHO.
ECHO 开始卸载组件……
FOR /f %%i IN ('dir /b %imgpath%\Windows\servicing\Packages\*.mum ^| %sed% "s/\.mum//g" 2^>nul ^| FINDSTR /i /g:%~dp0Offline-Remove\Offline-Remove-Package.txt 2^>nul') DO (
call :time %%i
%dism% /NoRestart /image:%imgpath% /Remove-package /Packagename:%%i
ECHO.
)
TITLE 在线----卸载功能组件完成。
color 2F
ECHO 完成。
ECHO.
ECHO 开始时间：%sttm% 结束时间：%time:~0,2%:%time:~3,2%:%time:~6,2% 统计：%count%
ECHO.
ECHO 按任意键退出……
PAUSE >NUL
EXIT

:time
SET /A count+=1
ECHO %time:~0,2%:%time:~3,2%:%time:~6,2% 统计：第%count%个 %~1
goto:eof