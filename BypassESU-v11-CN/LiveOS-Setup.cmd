@setlocal DisableDelayedExpansion
@echo off
set "_cmdf=%~f0"
if exist "%SystemRoot%\Sysnative\cmd.exe" (
setlocal EnableDelayedExpansion
start %SystemRoot%\Sysnative\cmd.exe /c ""!_cmdf!" %*"
exit /b
)
set "SysPath=%SystemRoot%\System32"
if exist "%SystemRoot%\Sysnative\reg.exe" (set "SysPath=%SystemRoot%\Sysnative")
set "Path=%SysPath%;%SystemRoot%;%SysPath%\Wbem;%SysPath%\WindowsPowerShell\v1.0\"
set "_err===== ERROR ===="
set "RDLL=HKLM\SYSTEM\CurrentControlSet\Services\wuauserv\Parameters"
set "IFEO=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"
set "_SxS=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\SideBySide"
set "_Cmp=HKLM\COMPONENTS\DerivedData\Components"
set "_OurVer=6.1.7603.25000"
set "xOS=x64"
set "xBT=amd64"
set "xSU=superUser64.exe"
set "xBE=bbe64.exe"
set "xSL=sle64.dll"
set "_EsuKey=%_SxS%\Winners\amd64_microsoft-windows-s..edsecurityupdatesai_31bf3856ad364e35_none_0e8b36cfce2fb332"
set "_EsuCom=amd64_microsoft-windows-s..edsecurityupdatesai_31bf3856ad364e35_6.1.7603.25000_none_caceb5163345f228"
set "_EsuIdn=4D6963726F736F66742D57696E646F77732D534C432D436F6D706F6E656E742D457874656E64656453656375726974795570646174657341492C2043756C747572653D6E65757472616C2C2056657273696F6E3D362E312E373630332E32353030302C205075626C69634B6579546F6B656E3D333162663338353661643336346533352C2050726F636573736F724172636869746563747572653D616D6436342C2076657273696F6E53636F70653D4E6F6E537853"
set "_EsuHsh=45D0AE442FD92CE32EE1DDC38EA3B875EAD9A53D6A17155A10FA9D9E16BEDEB2"
if /i %PROCESSOR_ARCHITECTURE%==x86 (if not defined PROCESSOR_ARCHITEW6432 (
  set "xOS=x86"
  set "xBT=x86"
  set "xSU=superUser32.exe"
  set "xBE=bbe32.exe"
  set "xSL=sle32.dll"
  set "_EsuKey=%_SxS%\Winners\x86_microsoft-windows-s..edsecurityupdatesai_31bf3856ad364e35_none_b26c9b4c15d241fc"
  set "_EsuCom=x86_microsoft-windows-s..edsecurityupdatesai_31bf3856ad364e35_6.1.7603.25000_none_6eb019927ae880f2"
  set "_EsuIdn=4D6963726F736F66742D57696E646F77732D534C432D436F6D706F6E656E742D457874656E64656453656375726974795570646174657341492C2043756C747572653D6E65757472616C2C2056657273696F6E3D362E312E373630332E32353030302C205075626C69634B6579546F6B656E3D333162663338353661643336346533352C2050726F636573736F724172636869746563747572653D7838362C2076657273696F6E53636F70653D4E6F6E537853"
  set "_EsuHsh=343B7E8DE2FE932E2FA1DB0CDFE69BB648BEE8E834B41728F1C83A12C1766ECB"
  )
)
set "SysWow=%SystemRoot%\SysWOW64"
set "_bat=%~f0"
set "_arg=%~1"
set "_elv="
if defined _arg if /i "%_arg%"=="-su" set _elv=1

for /f "tokens=6 delims=[]. " %%# in ('ver') do (
if %%# geq 9200 goto :E_Win
if %%# lss 7600 goto :E_Win
)
reg query HKU\S-1-5-19 1>nul 2>nul || goto :E_Admin

set "_work=%~dp0"
set "_work=%_work:~0,-1%"
setlocal EnableDelayedExpansion
pushd "!_work!"
if not exist "bin\" goto :E_DLL
cd bin\
for %%# in (
%xSU% %xBE% %xSL% x64\msislc.dll x86\msislc.dll
PatchWU.cmd PatchWU.xml
%_EsuCom%.manifest
) do (
if not exist "%%~#" (set "_file=%%~nx#"&goto :E_DLL)
)

call :TIcmd 1>nul 2>nul
whoami /USER | find /i "S-1-5-18" 1>nul && (
goto :Begin
) || (
if defined _elv goto :E_TI
net start TrustedInstaller 1>nul 2>nul
1>nul 2>nul %xSU% /c cmd.exe /c ""!_bat!" -su" &exit /b
)
whoami /USER | find /i "S-1-5-18" 1>nul || goto :E_TI

:Begin
@cls
echo.
echo ____________________________________________________________
echo.
echo 检查中 . . .
echo.

set "_sku="
for /f "tokens=2 delims==" %%# in ('"wmic OS Get OperatingSystemSKU /value" 2^>nul') do set "_sku=%%#"
if "%_sku%"=="" goto :E_WMI

set _SrvrC=0
if exist "%SystemRoot%\WinSxS\Manifests\%xBT%_windowsserverfoundation_*.manifest" set _SrvrC=1

set _Embed=0
if exist "%SystemRoot%\Servicing\Packages\*Winemb-*.mum" set _Embed=1

set _WuEsu=0
if exist "%SystemRoot%\WuEsu\bbe.exe" set _WuEsu=1

set _WiEsu=0
if %xOS%==x86 if exist "%SysPath%\msislc.dll" if exist "%SysPath%\msiexec.exe.manifest" if exist "%SysPath%\ActionCenter.dll.3.Manifest" if exist "%SysPath%\timedate.cpl.3.Manifest" set _WiEsu=1
if %xOS%==x64 if exist "%SysPath%\msislc.dll" if exist "%SysPath%\msiexec.exe.manifest" if exist "%SysPath%\ActionCenter.dll.3.Manifest" if exist "%SysPath%\timedate.cpl.3.Manifest" if exist "%SysWow%\msislc.dll" if exist "%SysWow%\msiexec.exe.manifest" if exist "%SysWow%\ActionCenter.dll.3.Manifest" if exist "%SysWow%\timedate.cpl.3.Manifest" set _WiEsu=1

set _EsuPkg=0
if exist "%SystemRoot%\WinSxS\Manifests\%_EsuCom%.manifest" (
reg query "%_EsuKey%" /ve 2>nul | find /i "%_OurVer:~0,3%" 1>nul && (
  reg query "%_EsuKey%\%_OurVer:~0,3%" /ve 2>nul | find /i "%_OurVer%" 1>nul && set _EsuPkg=1
  )
)

if %_EsuPkg% equ 0 if exist "%SystemRoot%\WinSxS\pending.xml" (
echo.
echo 检测到待处理的更新操作。
echo 首先重新启动系统，然后运行脚本。
goto :TheEnd
)

set _EsuUpdt=0
set "_EsuMajor="
set "_EsuWinner="
if not exist "%SystemRoot%\WinSxS\Manifests\%xBT%_microsoft-windows-s..edsecurityupdatesai*.manifest" goto :proceed
reg query "%_EsuKey%" 1>nul 2>nul || goto :proceed
reg query HKLM\COMPONENTS 1>nul 2>nul || reg load HKLM\COMPONENTS %SysPath%\Config\COMPONENTS 1>nul 2>nul
reg query "%_Cmp%" /f "%xBT%_microsoft-windows-s..edsecurityupdatesai_*" /k 2>nul | find /i "edsecurityupdatesai" 1>nul || goto :proceed
for /f "tokens=4 delims=_" %%# in ('dir /b "%SystemRoot%\WinSxS\Manifests\%xBT%_microsoft-windows-s..edsecurityupdatesai*.manifest"') do (
set "_ChkVer=%%#"&call :checkver
)
goto :proceed

:checkver
if "%_ChkVer%"=="%_OurVer%" exit /b
reg query "%_Cmp%" /f "%xBT%_microsoft-windows-s..edsecurityupdatesai_31bf3856ad364e35_%_ChkVer%_*" /k 2>nul | find /i "%_ChkVer%" 1>nul || exit /b
reg query "%_EsuKey%\%_ChkVer:~0,3%" /t REG_BINARY 2>nul | find /i "%_ChkVer%" 1>nul || exit /b
if "%_ChkVer:~4,4%" equ "7601" if "%_ChkVer:~9,5%" geq "24548" set _EsuUpdt=1
if "%_ChkVer:~4,4%" equ "7602" if "%_ChkVer:~9,5%" geq "20587" set _EsuUpdt=1
if "%_ChkVer:~4,4%" geq "7603" set _EsuUpdt=1
set "_EsuMajor=%_ChkVer:~0,3%"
set "_EsuWinner=%_ChkVer%"
exit /b

:proceed
set _wufile=wuaueng.dll
if exist "%SysPath%\wuaueng2.dll" set _wufile=wuaueng2.dll
@title BypassESU v11

:MainMenu
set _elr=0
set _dowu=0
@CLS
ECHO 汉化：荣耀 网站：nat.ee QQ群：6281379
echo ____________________________________________________________
echo.
if %_WuEsu% equ 0 if %_WiEsu% equ 0 (
echo [1] 完全安装 {ESU 破解 + WU ESU 修复 + .NET 4 ESU 绕过}
echo.
)
if %_EsuPkg% equ 0 (
echo [2] 安装 ESU 破解
echo.
)
if %_WuEsu% equ 0 (
echo [3] 安装 WU ESU 修复 {源文件: %_wufile%}
echo.
)
if %_WuEsu% equ 1 (
echo [4] 移除 WU ESU 修复
echo.
)
if %_EsuPkg% equ 1 if %_EsuUpdt% equ 0 (
echo [5] 移除 ESU 破解
echo.
)
if %_WiEsu% equ 1 (
echo [6] 移除 .NET 4 ESU 绕过
echo.
)
if %_WiEsu% equ 0 (
echo [7] 安装 .NET 4 ESU 绕过
echo.
)
echo [9] 退出
echo.
echo ____________________________________________________________
echo.
choice /C 12345679 /N /M "选择菜单选项: "
set _elr=%errorlevel%
if %_elr%==8 goto :eof
if %_elr%==7 if %_WiEsu% equ 0 (goto :HookWI)
if %_elr%==6 if %_WiEsu% equ 1 (goto :UnHookWI)
if %_elr%==5 if %_EsuPkg% equ 1 if %_EsuUpdt% equ 0 (goto :Uninstall)
if %_elr%==4 if %_WuEsu% equ 1 (goto :UnPatchWU)
if %_elr%==3 if %_WuEsu% equ 0 (goto :PatchWU)
if %_elr%==2 if %_EsuPkg% equ 0 (goto :Install)
if %_elr%==1 if %_WuEsu% equ 0 if %_WiEsu% equ 0 (set _dowu=1&goto :Install)
goto :MainMenu

:Install
@cls
if %_EsuPkg% equ 1 goto :PatchWU
echo.
echo ____________________________________________________________
echo.
echo ESU 破解 安装中 . . .
echo.
reg query "%IFEO%\TrustedInstaller.exe" 1>nul 2>nul && (
call :StopService TrustedInstaller 1>nul 2>nul
reg delete "%IFEO%\TrustedInstaller.exe" /f 1>nul 2>nul
)
call :StopService wuauserv 1>nul 2>nul
for %%# in (
%SysPath%\kurwica*.dll %SysPath%\gesu.dll
%SysPath%\BypassESU.dll %SysPath%\esuslc.dll
%SystemRoot%\servicing\slc.dll
) do (
if exist "%%~#" del /f /q "%%~#" 1>nul 2>nul
)
call :DoManual 1>nul 2>nul
if %_dowu% equ 1 goto :PatchWU
echo.
echo 完成。
goto :TheEnd

:DoManual
set "_EsuFnd=windowsfoundation_31bf3856ad364e35_6.1.7601.17514_615fdfe2a739474c"
if %_Embed% equ 1 set "_EsuFnd=windowsembe..dfoundation_31bf3856ad364e35_6.1.7601.17514_b791db78a3ca92ca"
if %_SrvrC% equ 1 set "_EsuFnd=windowsserverfoundation_31bf3856ad364e35_6.1.7601.17514_1767904420c89fad"
if /i "%xBT%"=="x86" (
set "_EsuFnd=windowsfoundation_31bf3856ad364e35_6.1.7601.17514_0541445eeedbd616"
if %_Embed% equ 1 set "_EsuFnd=windowsembe..dfoundation_31bf3856ad364e35_6.1.7601.17514_5b733ff4eb6d2194"
)
copy /y %_EsuCom%.manifest %SystemRoot%\WinSxS\Manifests\
reg query HKLM\COMPONENTS 1>nul 2>nul || reg load HKLM\COMPONENTS %SysPath%\Config\COMPONENTS 1>nul 2>nul
reg delete "%_Cmp%\%_EsuCom%" /f
reg add "%_Cmp%\%_EsuCom%" /f /v "c^!%_EsuFnd%" /t REG_BINARY /d ""
reg add "%_Cmp%\%_EsuCom%" /f /v identity /t REG_BINARY /d "%_EsuIdn%"
reg add "%_Cmp%\%_EsuCom%" /f /v S256H /t REG_BINARY /d "%_EsuHsh%"
reg add "%_EsuKey%" /f /ve /d %_OurVer:~0,3%
reg add "%_EsuKey%\%_OurVer:~0,3%" /f /ve /d %_OurVer%
reg add "%_EsuKey%\%_OurVer:~0,3%" /f /v %_OurVer% /t REG_BINARY /d 01
for /f "tokens=* delims=" %%# in ('reg query HKLM\COMPONENTS\DerivedData\VersionedIndex 2^>nul ^| findstr /i VersionedIndex') do reg delete "%%#" /f
reg unload HKLM\COMPONENTS 1>nul 2>nul || call :StopService TrustedInstaller 1>nul 2>nul
dism.exe /Online /Get-Packages
exit /b

:Uninstall
@cls
if exist "%SystemRoot%\WinSxS\pending.xml" (
echo.
echo 检测到待处理的更新操作。
echo 首先重新启动系统，然后运行脚本。
goto :TheEnd
)
echo.
echo ____________________________________________________________
echo.
echo ESU 破解 移除中 . . .
echo.
call :RemoveManual 1>nul 2>nul
echo.
echo 完成。
goto :TheEnd

:RemoveManual
reg query HKLM\COMPONENTS 1>nul 2>nul || reg load HKLM\COMPONENTS %SysPath%\Config\COMPONENTS 1>nul 2>nul
reg delete "%_Cmp%\%_EsuCom%" /f
reg delete "%_EsuKey%\%_OurVer:~0,3%" /f /v %_OurVer%
del /f /q "%SystemRoot%\WinSxS\Manifests\%_EsuCom%.manifest"
if not exist "%SystemRoot%\WinSxS\Manifests\*_microsoft-windows-s..edsecurityupdatesai*.manifest" (
reg delete "%_EsuKey%" /f
) else (
if defined _EsuWinner (
  reg add "%_EsuKey%" /f /ve /d "%_EsuMajor%"
  reg add "%_EsuKey%\%_EsuMajor%" /f /ve /d "%_EsuWinner%"
  ) else (
  reg delete "%_EsuKey%" /f
  )
)
for /f "tokens=* delims=" %%# in ('reg query HKLM\COMPONENTS\DerivedData\VersionedIndex 2^>nul ^| findstr /i VersionedIndex') do reg delete "%%#" /f
reg unload HKLM\COMPONENTS 1>nul 2>nul || call :StopService TrustedInstaller 1>nul 2>nul
dism.exe /Online /Get-Packages
exit /b

:PatchWU
if %_dowu% equ 0 (
@cls
)
echo.
echo ____________________________________________________________
echo.
echo WU ESU 修复 安装中 . . .
echo.
call :StopService wuauserv 1>nul 2>nul
if exist "%SystemRoot%\WuEsu\" rmdir /s /q "%SystemRoot%\WuEsu\"
if exist "%SysPath%\wuaueng3.dll" del /f /q %SysPath%\wuaueng3.dll
echo.
echo 添加中 "%SystemRoot%\WuEsu"
mkdir %SystemRoot%\WuEsu
copy /y PatchWU.cmd %SystemRoot%\WuEsu 1>nul 2>nul
copy /y %xBE% %SystemRoot%\WuEsu\bbe.exe 1>nul 2>nul
echo.
echo 添加中 "%SystemRoot%\System32\sle.dll"
copy /y %xSL% %SysPath%\sle.dll 1>nul 2>nul
echo.
echo 添加计划任务 "Patch WU ESU"
schtasks /Delete /F /TN "Patch WU ESU" 1>nul 2>nul
schtasks /Create /F /TN "Patch WU ESU" /XML PatchWU.xml 1>nul 2>nul
echo.
echo 运行计划任务 "Patch WU ESU"
schtasks /Run /I /TN "Patch WU ESU" 1>nul 2>nul
if %_dowu% equ 1 goto :HookWI
echo.
echo 完成。
goto :TheEnd

:UnPatchWU
@cls
echo.
echo ____________________________________________________________
echo.
echo WU ESU 修复 移除中 . . .
echo.
call :StopService wuauserv 1>nul 2>nul
if exist "%SystemRoot%\WuEsu\" (echo removing "%SystemRoot%\WuEsu\"&rmdir /s /q "%SystemRoot%\WuEsu\")
if exist "%SysPath%\wuaueng3.dll" (echo removing "%SystemRoot%\System32\wuaueng3.dll"&del /f /q "%SysPath%\wuaueng3.dll")
if exist "%SysPath%\sle.dll" (removing "%SystemRoot%\System32\sle.dll"&del /f /q "%SysPath%\sle.dll")
echo.
echo 移除计划任务 "Patch WU ESU"
schtasks /Delete /F /TN "Patch WU ESU" 1>nul 2>nul
echo.
echo 恢复注册表值 "ServiceDll" 到 "%_wufile%"
reg add "%RDLL%" /f /v ServiceDll /t REG_EXPAND_SZ /d ^%%SystemRoot^%%\System32\%_wufile% 1>nul 2>nul
echo.
set "_ebak="
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID_bak 1>nul 2>nul && for /f "skip=2 tokens=2*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID_bak 2^>nul') do set "_ebak=%%b"
if defined _ebak (
echo 恢复注册表值 "EditionID" 到 "%_ebak%"
echo.
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /f /v EditionID /d %_ebak% 1>nul 2>nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /f /v EditionID_bak 1>nul 2>nul
)
echo.
echo 完成。
goto :TheEnd

:HookWI
if %_dowu% equ 0 (
@cls
)
echo.
echo ____________________________________________________________
echo.
echo .NET 4 ESU 绕过 安装中 . . .
echo.
call :StopService msiserver 1>nul 2>nul
taskkill /t /f /IM msiexec.exe 1>nul 2>nul
for %%# in (msiesu.dll msislc.dll slcmsi.dll msiexec.exe.manifest) do (
if exist "%SysPath%\%%#" del /f /q "%SysPath%\%%#" 1>nul 2>nul
if exist "%SysWow%\%%#" del /f /q "%SysWow%\%%#" 1>nul 2>nul
)
if exist "%SysPath%\msiexec.exe.local\" rmdir /s /q "%SysPath%\msiexec.exe.local\"
if exist "%SysWow%\msiexec.exe.local\" rmdir /s /q "%SysWow%\msiexec.exe.local\"
schtasks /Delete /F /TN NDP4_ESU_Bypass1 1>nul 2>nul
schtasks /Delete /F /TN NDP4_ESU_Bypass2 1>nul 2>nul
echo.
echo 添加文件中...
echo.
echo %SystemRoot%\System32\
echo ActionCenter.dll.3.Manifest
echo perfmon.exe.3.Manifest
echo pnidui.dll.3.Manifest
echo timedate.cpl.3.Manifest
echo msiexec.exe.manifest
echo msislc.dll
echo slcmsi.dll
xcopy /cryq %xOS% "%SysPath%\" 1>nul 2>nul
copy /y "%SysPath%\slc.dll" "%SysPath%\slcmsi.dll" 1>nul 2>nul
if %xOS%==x64 (
echo.
echo %SystemRoot%\SysWOW64\
echo ActionCenter.dll.3.Manifest
echo perfmon.exe.3.Manifest
echo pnidui.dll.3.Manifest
echo timedate.cpl.3.Manifest
echo msiexec.exe.manifest
echo msislc.dll
echo slcmsi.dll
xcopy /cryq x86 "%SysWow%\" 1>nul 2>nul
copy /y "%SysWow%\slc.dll" "%SysWow%\slcmsi.dll" 1>nul 2>nul
)
echo.
echo 添加 PreferExternalManifest 注册表中...
reg delete "%IFEO%" /v DevOverrideEnable /f 1>nul 2>nul
reg delete "%IFEO%\msiexec.exe" /f 1>nul 2>nul
reg add "%_SxS%" /v PreferExternalManifest /t REG_DWORD /d 1 /f 1>nul 2>nul
call :StopService msiserver 1>nul 2>nul
echo.
echo 完成。
goto :TheEnd

:UnHookWI
@cls
echo.
echo ____________________________________________________________
echo.
echo .NET 4 ESU 绕过 移除中 . . .
echo.
call :StopService msiserver 1>nul 2>nul
taskkill /t /f /IM msiexec.exe 1>nul 2>nul
for %%# in (msiesu.dll msislc.dll slcmsi.dll msiexec.exe.manifest) do (
if exist "%SysPath%\%%#" del /f /q "%SysPath%\%%#" 1>nul 2>nul
if exist "%SysWow%\%%#" del /f /q "%SysWow%\%%#" 1>nul 2>nul
)
if exist "%SysPath%\msiexec.exe.local\" rmdir /s /q "%SysPath%\msiexec.exe.local\"
if exist "%SysWow%\msiexec.exe.local\" rmdir /s /q "%SysWow%\msiexec.exe.local\"
reg delete "%IFEO%" /v DevOverrideEnable /f 1>nul 2>nul
reg delete "%IFEO%\msiexec.exe" /f 1>nul 2>nul
reg delete "%_SxS%" /v PreferExternalManifest /f 1>nul 2>nul
call :StopService msiserver 1>nul 2>nul
echo.
echo 完成。
goto :TheEnd

:StopService
sc query %1 | find /i "STOPPED" || net stop %1 /y
sc query %1 | find /i "STOPPED" || sc stop %1
exit /b

:TIcmd
reg add HKU\.DEFAULT\Console /f /v FaceName /t REG_SZ /d Consolas
reg add HKU\.DEFAULT\Console /f /v FontFamily /t REG_DWORD /d 0x36
reg add HKU\.DEFAULT\Console /f /v FontSize /t REG_DWORD /d 0x100000
reg add HKU\.DEFAULT\Console /f /v FontWeight /t REG_DWORD /d 0x190
reg add HKU\.DEFAULT\Console /f /v ScreenBufferSize /t REG_DWORD /d 0x12c0050
exit /b

:E_TI
echo %_err%
echo 使用TrustedInstaller权限运行脚本失败。
goto :TheEnd

:E_WMI
echo %_err%
echo 系统 SKU 检测失败。
echo 验证 Windows Management Instrumentation 服务 "WinMgmt" 是否运行。
goto :TheEnd

:E_Admin
echo %_err%
echo 该脚本需要administrator权限。
goto :TheEnd

:E_Win
echo %_err%
echo 该项目仅适用于Windows 7 / Server 2008 R2。
goto :TheEnd

:E_DLL
echo %_err%
echo 缺少脚本必须的文件 bin\%_file% 。

:TheEnd
echo.
echo 按任意键退出。
pause >nul
goto :eof
