@shift /0
@echo off&&color 8F&&chcp 936
mode con cols=96 lines=36
set title=WinLite1.1 破解10次限制版
title  %title%

:MENU
cd /d "%~dp0" 
SET "Root=%~dp0"
SET "DIC=%~dp0"
SET MOU=%Root%win10
SET NSD=%DIC%NSudo.exe -U:C -P:E -ShowWindowMode:Hide cmd /c 
SET NSDT=%DIC%NSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c 
SET TWK=%DIC%install_wim_tweak.exe

Reg unload HKLM\0 >nul 2>nul
SET DEREG=Reg load HKLM\0 "%MOU%\Windows\System32\config\DEFAULT"
SET USREG=Reg load HKLM\0 "%MOU%\Users\Default\NTUSER.DAT"
SET SSREG=Reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE"
SET SYREG=Reg load HKLM\0 "%MOU%\Windows\System32\config\SYSTEM"
SET UNREG=Reg unload HKLM\0

ECHO.                                                           

ECHO.        *********************************************************************************
ECHO.                                            WinLite1.1                            
ECHO.            *************************************************************************     
ECHO.                            1 、  导 出 映 像                                                                                   
ECHO.                            2 、  装 载 映 像                                                                                  
ECHO.                            3 、  卸 载 部 分 App                                                                          
ECHO.                            4 、  卸 载 OneDrive                                                                     
ECHO.                            5 、  卸 载 Windows Defender                                                        
ECHO.                            6 、  通 用 安 全 适 度 精 简                                                               
ECHO.                            7 、  卸 载 Edge                                                                             
ECHO.                            8 、  系 统 优 化                                                                                 
ECHO.                            9 、  无 人 值 守                                                                              
ECHO.                           10 、  更 新 补 丁或.Net（补丁放在Patch，.Net放在sxs目录）             
ECHO.                           11 、  优化WinSxS（不能更新）                                                          
ECHO.                           12 、  优 化 压 缩、保 存 映 像                                                              
ECHO.                           13 、  卸 载 退 出                                                                                    
ECHO.            **************************************************************************  
ECHO.             注意：程序运行时请勿关闭窗口！根据需要依次运行3-11进行精简，App保留了     
ECHO.         计算器，截图，游戏，画图，录音机及混合现实等.    %date:~0,4%年%date:~5,2%月%date:~8,2%日%time:~0,8%
ECHO.        *********************************************************************************
ECHO.                   
Set m=N
Set /p m=.       请输入你要操作的菜单序号数字(1-13) 按回车执行操作:
cls
If "%m%"=="1"  Goto EXPORT
If "%m%"=="2"  Goto MOUNT
If "%m%"=="3"  Goto UNAPP
If "%m%"=="4"  Goto UNONE
If "%m%"=="5"  Goto KLWD
If "%m%"=="6"  Goto GENLIT
If "%m%"=="7"  Goto UNEDGE
If "%m%"=="8"  Goto OPTOS
If "%m%"=="9"  Goto WRZS
If "%m%"=="10"  Goto GXBD
If "%m%"=="11"  Goto OPTWINSXS
If "%m%"=="12"  Goto UNMO
If "%m%"=="13"  Goto TUIC
echo.
echo    你的输入有误 程序并未提供该项操作及相关的序号 请重新输入程序所提供的菜单序号！！！
echo.
ping -n 3 127.1 >nul
cls
Goto MENU

:EXPORT
echo.
echo 导出映像%Root%new_install......
echo.
if not exist %Root%win10 md %Root%win10
SET MOU=%Root%win10
if exist %MOU%\Windows\System32\config\SOFTWARE (
echo.
echo 已经装载映像 请不要重复装载 如果已经装载的映像损坏请先执行废除操作
echo.
ping -n 3 127.1>nul
cls
Goto MENU )
Set WimF=n
Set /p WimF=请输入根目录%Root%下的映像名称(带扩展名):
Dism /Get-Wiminfo /WimFile:%Root%%WimF%
for /f "tokens=3 delims= " %%a in ('Dism /english /get-wiminfo /wimfile:%Root%%WimF% ^| find /i "index"') do set ZS=%%a
set index=1
set /p index=请输入%Root%%WimF%中要操作的索引序号共%ZS%个子映像 直接回车默认为1:
if not exist %Root%new_install.wim Dism /export-image /sourceimagefile:%Root%%WimF% /sourceindex:%index% /destinationimagefile:%Root%new_install.wim
echo.
echo 导出%Root%new_install.wim映像完成！！！ 
echo.
ping -n 5 127.1>nul
cls
goto MENU

:MOUNT
Set WimF=n
Set /p WimF=请输入根目录%Root%下的映像名称(带扩展名):
if not exist %Root%win10 md %Root%win10
SET MOU=%Root%win10
if exist %MOU%\Windows\System32\config\SOFTWARE (
echo.
echo 已经装载映像 请不要重复装载 如果已经装载的映像损坏请先执行废除操作
echo.
ping -n 3 127.1>nul
cls
Goto MENU )
echo.
echo 装载%Root%%WimF%映像...... 
echo.
Dism /Get-Wiminfo /WimFile:%Root%%WimF%
for /f "tokens=3 delims= " %%a in ('Dism /english /get-wiminfo /wimfile:%Root%%WimF% ^| find /i "index"') do set ZS=%%a
set index=1
set /p index=请输入%Root%%WimF%中要操作的索引序号共%ZS%个子映像 直接回车默认为1:
Dism /Mount-Image /ImageFile:%Root%%WimF% /index:%index% /MountDir:%MOU% 2>nul
echo.
echo 装载%Root%%WimF%映像完成！！！ 
echo.
ping -n 5 127.1>nul
cls
goto MENU

:UNAPP
echo.
echo 卸载部分App......
echo.
Dism  /Image:%MOU% /Get-ProvisionedAppxPackages >%DIC%AppxPackages.txt
findstr "_~_" %DIC%AppxPackages.txt>%DIC%Applist.txt
for /f "tokens=2 delims=: " %%a in (%DIC%Applist.txt) do (echo "%%a"|find /i ".549981C3F5F10_" &&Dism /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "tokens=2 delims=: " %%a in (%DIC%Applist.txt) do (echo "%%a"|find /i ".BingWeather_" &&Dism /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "tokens=2 delims=: " %%a in (%DIC%Applist.txt) do (echo "%%a"|find /i ".GetHelp_" &&Dism /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "tokens=2 delims=: " %%a in (%DIC%Applist.txt) do (echo "%%a"|find /i ".Getstarted_" &&Dism /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "tokens=2 delims=: " %%a in (%DIC%Applist.txt) do (echo "%%a"|find /i ".MicrosoftOfficeHub_" &&Dism /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "tokens=2 delims=: " %%a in (%DIC%Applist.txt) do (echo "%%a"|find /i ".MicrosoftStickyNotes_" &&Dism /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "tokens=2 delims=: " %%a in (%DIC%Applist.txt) do (echo "%%a"|find /i ".Office.OneNote_" &&Dism /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "tokens=2 delims=: " %%a in (%DIC%Applist.txt) do (echo "%%a"|find /i ".People_" &&Dism /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "tokens=2 delims=: " %%a in (%DIC%Applist.txt) do (echo "%%a"|find /i ".SkypeApp_" &&Dism /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "tokens=2 delims=: " %%a in (%DIC%Applist.txt) do (echo "%%a"|find /i ".Wallet_" &&Dism /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "tokens=2 delims=: " %%a in (%DIC%Applist.txt) do (echo "%%a"|find /i ".WebMediaExtensions_" &&Dism /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "tokens=2 delims=: " %%a in (%DIC%Applist.txt) do (echo "%%a"|find /i ".WindowsAlarms_" &&Dism /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "tokens=2 delims=: " %%a in (%DIC%Applist.txt) do (echo "%%a"|find /i ".windowscommunicationsapps_" &&Dism /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "tokens=2 delims=: " %%a in (%DIC%Applist.txt) do (echo "%%a"|find /i ".WindowsFeedbackHub_" &&Dism /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "tokens=2 delims=: " %%a in (%DIC%Applist.txt) do (echo "%%a"|find /i ".WindowsMaps_" &&Dism /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "tokens=2 delims=: " %%a in (%DIC%Applist.txt) do (echo "%%a"|find /i ".ZuneMusic_" &&Dism /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "tokens=2 delims=: " %%a in (%DIC%Applist.txt) do (echo "%%a"|find /i ".ZuneVideo_" &&Dism /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "tokens=2 delims=: " %%a in (%DIC%Applist.txt) do (echo "%%a"|find /i ".YourPhone_" &&Dism /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
del /q /f %DIC%AppxPackages.txt
del /q /f %DIC%Applist.txt
Dism /Image:%MOU% /Cleanup-Image /StartComponentCleanup &&Dism /Image:%MOU% /Cleanup-Image /StartComponentCleanup /ResetBase
echo.
echo 卸载部分App完成！！！
echo.
ping -n 5 127.1>nul
cls
goto MENU

:UNONE
echo.
echo 移除OneDrive...
echo.
if exist %MOU%\Windows\SysWOW64\OneDriveSetup.exe (
echo.
echo 正在处理 OneDrive 安装包及注册表...
%TWK% /p "%MOU%" /c Microsoft-Windows-OneDrive-Setup /r >nul 2>nul )
if exist %MOU%\Windows\System32\OneDriveSetup.exe (
echo.
echo 正在处理 OneDrive 安装包及注册表...
%TWK% /p "%MOU%" /c Microsoft-Windows-OneDrive-Setup /r >nul 2>nul )
echo.
echo 处理注册表中的登录启动项...
echo.
%USREG% >nul
Reg delete "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f >nul 2>&1
%UNREG% >nul
if exist "%MOU%\Windows\SysWOW64\OneDriveSetup.exe" %NSD% del /q /f  "%MOU%\Windows\SysWOW64\OneDriveSetup.exe" 
dir %MOU%\Windows\WinSxS\* >%DIC%WinSxSTemp3.txt
find /i "-onedrive-setup_" %DIC%WinSxSTemp3.txt>%DIC%MyTemp3.txt
for /f "tokens=4 delims= " %%i in (%DIC%MyTemp3.txt) do (
if exist "%MOU%\Windows\WinSxS\%%i" %NSD% RMDIR /S /Q "%MOU%\Windows\WinSxS\%%i" )
del /q /f %DIC%WinSxSTemp3.txt
del /q /f %DIC%MyTemp3.txt
if exist "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive" %NSD% del /q /f  "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive" 
Dism /Image:%MOU% /Cleanup-Image /StartComponentCleanup &&Dism /Image:%MOU% /Cleanup-Image /StartComponentCleanup /ResetBase
echo.
echo OneDrive数据已移除 程序返回主菜单!
echo.
ping -n 5 127.1>nul
cls
goto MENU

:KLWD
echo.
echo 卸载Windows Defender......
echo.

%SSREG% >nul
Reg delete "HKLM\0\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /f >nul 2>&1
reg add "HKLM\0\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Policies\Microsoft\Windows Defender Security Center\Systray" /v "HideSystray" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\ReserveManager" /v "ShippedWithReserves" /d 0 /t REG_DWORD /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /t REG_SZ /d "hide:windowsdefender" /f >nul
reg add "HKLM\0\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul
Reg add "HKLM\0\Microsoft\Security Center\Feature" /v "DisableAvCheck" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\0\Microsoft\Windows Defender Security Center\Notifications" /v "DisableNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Microsoft\Windows Defender Security Center\Notifications" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\0\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Microsoft\Windows Defender" /v "DisableAntiVirus" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\0\Microsoft\Windows Defender\Features" /v "TamperProtectionSource" /t REG_DWORD /d "2" /f >nul 2>&1
			Reg add "HKLM\0\Microsoft\Windows Defender\Signature Updates" /v "FirstAuGracePeriod" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\0\Microsoft\Windows Defender\UX Configuration" /v "DisablePrivacyMode" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "SecurityHealth" /t REG_BINARY /d "030000000000000000000000" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f >nul 2>&1
		
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender" /v "PUAProtection" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender" /v "RandomizeScheduleTaskTimes" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Exclusions" /v "DisableAutoExclusions" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\MpEngine" /v "MpEnablePus" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Quarantine" /v "LocalSettingOverridePurgeItemsAfterDelay" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Quarantine" /v "PurgeItemsAfterDelay" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScriptScanning" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Remediation" /v "Scan_ScheduleDay" /t REG_DWORD /d "8" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Remediation" /v "Scan_ScheduleTime" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Reporting" /v "AdditionalActionTimeOut" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Reporting" /v "CriticalFailureTimeOut" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Reporting" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Reporting" /v "DisableGenericRePorts" /t REG_DWORD /d 1 /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Reporting" /v "NonCriticalTimeOut" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Scan" /v "AvgCPULoadFactor" /t REG_DWORD /d "10" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Scan" /v "DisableArchiveScanning" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Scan" /v "DisableCatchupFullScan" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Scan" /v "DisableCatchupQuickScan" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Scan" /v "DisableRemovableDriveScanning" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Scan" /v "DisableRestorePoint" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Scan" /v "DisableScanningMappedNetworkDrivesForFullScan" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Scan" /v "DisableScanningNetworkFiles" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Scan" /v "PurgeItemsAfterDelay" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Scan" /v "ScanOnlyIfIdle" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Scan" /v "ScanParameters" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Scan" /v "ScheduleDay" /t REG_DWORD /d 8 /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Scan" /v "ScheduleTime" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Signature Updates" /v "DisableUpdateOnStartupWithoutEngine" /t REG_DWORD /d 1 /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Signature Updates" /v "ScheduleDay" /t REG_DWORD /d 8 /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Signature Updates" /v "ScheduleTime" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Signature Updates" /v "SignatureUpdateCatchupInterval" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\SpyNet" /v "DisableBlockAtFirstSeen" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Spynet" /v "LocalSettingOverrideSpynetReporting" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Spynet" /v "SpyNetReporting" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Spynet" /v "SpyNetReportingLocation" /t REG_MULTI_SZ /d "0" /f >nul 2>&1
			Reg add "HKLM\0\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f >nul 2>&1
%UNREG% >nul
%SYREG% >nul
reg add "HKLM\0\ControlSet001\Services\SecurityHealthService" /v "Start" /t REG_DWORD /d 4 /f >nul
reg add "HKLM\0\ControlSet001\Services\wscsvc" /v "Start" /t REG_DWORD /d 4 /f >nul
Reg add "HKLM\0\ControlSet001\Services\EventLog\System\Microsoft-Antimalware-ShieldProvider" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\0\ControlSet001\Services\EventLog\System\WinDefend" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\0\ControlSet001\Services\MsSecFlt" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			
			Reg add "HKLM\0\ControlSet001\Services\Sense" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\0\ControlSet001\Services\WdBoot" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\0\ControlSet001\Services\WdFilter" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\0\ControlSet001\Services\WdNisDrv" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\0\ControlSet001\Services\WdNisSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\0\ControlSet001\Services\WinDefend" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\0\ControlSet001\Control\WMI\Autologger\DefenderApiLogger" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\0\ControlSet001\Control\WMI\Autologger\DefenderAuditLogger" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
%UNREG% >nul
echo.
echo 成功设置禁用映像中的 Windows Defender 注册表 !
echo.

rem 查询删除Package及注册表
dir /b %MOU%\Windows\servicing\Packages\*.mum >%DIC%1_Get_Full_Packages.txt
findstr /I /V "en-us zh-tw zh-cn" %DIC%1_Get_Full_Packages.txt >%DIC%2_Get_Main_Packages.txt
findstr /I "Windows-Defender" %DIC%2_Get_Main_Packages.txt >%DIC%3_Get_Full_Packages.txt
for /f "eol=* tokens=*" %%i in (%DIC%3_Get_Full_Packages.txt) do ( 
rem 设置变量a为每行内容 
set a=%%i 
rem 如果该行有.mum，则将其改为 
set "a=!a:.mum=!" 
echo !a! )>>%DIC%RemoveTemp.txt
rem 只删除Windows-Defender-Nis-Group-Package
findstr /I "Defender-Nis Management-Powershell" %DIC%RemoveTemp.txt >%DIC%Remove.txt
rem 加载注册表
reg load HKLM\SOFT "%MOU%\Windows\System32\config\software"
for /f %%i in ('findstr /i . %DIC%Remove.txt 2^>nul') do ( call :SETVALUE %%i )
reg unload HKLM\SOFT
for /f %%i in ('findstr /i . %DIC%Remove.txt 2^>nul') do dism /NoRestart /image:%MOU% /Remove-package /Packagename:%%i
del /q /f %DIC%1_Get_Full_Packages.txt
del /q /f %DIC%2_Get_Main_Packages.txt
del /q /f %DIC%3_Get_Full_Packages.txt
del /q /f %DIC%Remove.txt
del /q /f %DIC%RemoveTemp.txt

for /f "eol=: delims=" %%i in ('dir /b %MOU%\Windows\servicing\Packages ^|findstr "Windows-Defender"') do (
if exist %MOU%\Windows\servicing\Packages\%%i %NSD% del /q /f  %MOU%\Windows\servicing\Packages\%%i )

reg load HKLM\SOFT "%MOU%\Windows\System32\config\software"
for /f "eol=: tokens=*" %%i in ('reg query "HKLM\SOFT" /s /f "Defender" /k') do (%NSDT% "reg delete "%%i" /f" )
for /f "eol=: tokens=*" %%i in ('reg query "HKLM\SOFT" /s /f "Defender" /k') do (%NSDT% "reg delete "%%i" /f" )
for /f "eol=: tokens=*" %%i in ('reg query "HKLM\SOFT" /s /f "SecurityHealth" /k') do (%NSDT% "reg delete "%%i" /f" )
rem for /f "eol=: tokens=*" %%i in ('reg query "HKLM\SOFT" /s /f "Windows-Defender" /k') do (reg delete "%%i" /f )
rem for /f "eol=: tokens=*" %%i in (%DIC%Backup\SoftDefender.txt) do (reg delete "%%i" /f )
rem for /f "eol=: tokens=*" %%i in ('reg query "HKLM\SOFT" /s /f "Windows Defender" /k') do ( reg delete "%%i" /f )
reg unload HKLM\SOFT

rem 删除注册表符合字符串的项
reg load HKLM\SOFT "%MOU%\Windows\System32\config\SYSTEM"
for /f "tokens=* delims=" %%i in ('reg query "HKLM\SOFT" /s /f "Defend" /k') do (%NSDT% "reg delete "%%i" /f" )
for /f  "tokens=* delims=" %%i in ('reg query "HKLM\SOFT" /s /f "Microsoft-Antimalware-ShieldProvider" /k') do (%NSDT% "reg delete "%%i" /f" ) 
for /f "eol=: tokens=*" %%i in ('reg query "HKLM\SOFT" /s /f "SecurityHealth" /k') do (%NSDT% "reg delete "%%i" /f" )
reg unload HKLM\SOFT

if exist "%MOU%\Program Files\Windows Defender" %NSD% RD /Q /S "%MOU%\Program Files\Windows Defender"
if exist "%MOU%\ProgramData\Microsoft\Windows Defender" %NSD% RD /Q /S "%MOU%\ProgramData\Microsoft\Windows Defender"
if exist %MOU%\Windows\SysWOW64 if exist "%MOU%\Program Files (x86)\Windows Defender" %NSD% RD /Q /S "%MOU%\Program Files (x86)\Windows Defender"
if exist "%MOU%\Program Files\Windows Defender Advanced Threat Protection" (
echo.
echo 移除 SecurityHealthService 主程序...
echo.
%NSD% RD /Q /S "%MOU%\Program Files\Windows Defender Advanced Threat Protection"
%NSD% RD /Q /S "%MOU%\ProgramData\Microsoft\Windows Defender Advanced Threat Protection")
rem cmd.exe /c takeown /f %MOU%\Windows\System32\LogFiles\WMI\RtBackup && icacls %MOU%\Windows\System32\LogFiles\WMI\RtBackup /grant administrators:F /t
if exist "%MOU%\Windows\System32\SecurityHealthService.exe" (
echo.
echo 安全关闭安全中心主程序及开始菜单中的图标...
echo.
%NSD% RD /Q /S "%MOU%\ProgramData\Microsoft\Windows Security Health"
%NSD% del /q /f  %MOU%\Windows\System32\SecurityHealthService.exe)

echo.
echo 安全关闭 smartscreen 主程序...
echo.
if exist "%MOU%\Windows\System32\smartscreen.exe" %NSD% del /q /f  %MOU%\Windows\System32\smartscreen.exe 

for /f "eol=: delims=" %%i in ('dir /b /ad "%MOU%\Windows\WinSxS" ^|findstr "securityhealth-sso_"') do (
if exist "%MOU%\Windows\WinSxS\%%i" %NSD% del /q /f  %MOU%\Windows\WinSxS\%%i\SecurityHealthSystray.exe )
for /f "eol=: delims=" %%i in ('dir /b /ad "%MOU%\Windows\WinSxS" ^|findstr "shield-provider_"') do (
if exist "%MOU%\Windows\WinSxS\%%i" (%NSD% del /q /f  %MOU%\Windows\WinSxS\%%i\WindowsDefenderSecurityCenter.admx & %NSD% del /q /f  %MOU%\Windows\WinSxS\%%i\WindowsSecurityIcon.png ))

echo.
echo 移除SystemResources...
echo.
if exist "%MOU%\Program Files\Windows Security" %NSD% RD /Q /S "%MOU%\Program Files\Windows Security" 
if exist "%MOU%\ProgramData\Microsoft\Windows\WER" %NSD% RMDIR /S /Q "%MOU%\ProgramData\Microsoft\Windows\WER" 
if exist "%MOU%\Windows\SystemResources\Microsoft.Windows.SecHealthUI" %NSD% RD /Q /S "%MOU%\Windows\SystemResources\Microsoft.Windows.SecHealthUI" 

if exist "%MOU%\Windows\SystemApps\Microsoft.Windows.SecHealthUI_cw5n1h2txyewy" %NSD% RD /Q /S "%MOU%\Windows\SystemApps\Microsoft.Windows.SecHealthUI_cw5n1h2txyewy" 

for /f "eol=: delims=" %%i in ('dir /b "%MOU%\Windows\WinSxS\FileMaps" ^|findstr "$$_systemapps_microsoft.windows.sechealthui $$_systemresources_microsoft.windows.sechealthui"') do (
if exist %MOU%\Windows\WinSxS\FileMaps\%%i %NSD% del /q /f  %MOU%\Windows\WinSxS\FileMaps\%%i )

dir %MOU%\Windows\WinSxS\* >%DIC%WinSxSTemp.txt
find /i "-sechealthui.appxmain_" %DIC%WinSxSTemp.txt>%DIC%MyTemp.txt
for /f "tokens=4 delims= " %%i in (%DIC%MyTemp.txt) do (
if exist "%MOU%\Windows\WinSxS\%%i" %NSD% del /q /f %MOU%\Windows\WinSxS\%%i\*.png )
find /i "-defender-am-sigs_" %DIC%WinSxSTemp.txt>%DIC%MyTemp1.txt
for /f "tokens=4 delims= " %%i in (%DIC%MyTemp1.txt) do (
if exist "%MOU%\Windows\WinSxS\%%i" %NSD% RD /Q /S "%MOU%\Windows\WinSxS\%%i" )
dir %MOU%\Windows\WinSxS\Manifests\* >%DIC%WinSxSTemp2.txt
find /i "-defender-am-sigs_" %DIC%WinSxSTemp2.txt>%DIC%MyTemp2.txt
for /f "tokens=4 delims= " %%i in (%DIC%MyTemp2.txt) do (
if exist %MOU%\Windows\WinSxS\Manifests\%%i %NSD% del /q /f %MOU%\Windows\WinSxS\Manifests\%%i )
del /q /f %DIC%WinSxSTemp.txt
del /q /f %DIC%WinSxSTemp2.txt
del /q /f %DIC%MyTemp.txt
del /q /f %DIC%MyTemp1.txt
del /q /f %DIC%MyTemp2.txt

if exist "%MOU%\Windows\System32\SecurityHealthHost.exe" %NSD% del /q /f  %MOU%\Windows\System32\SecurityHealthHost.exe 
if exist "%MOU%\Windows\System32\SecurityHealthSystray.exe" %NSD% del /q /f  %MOU%\Windows\System32\SecurityHealthSystray.exe 

if exist "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Windows Defender.lnk" %NSD% del /q /f "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Windows Defender.lnk"
if exist "%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\System Tools\Windows Defender.lnk" %NSD% del /q /f "%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\System Tools\Windows Defender.lnk"
if exist "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\SendTo\Compressed (zipped) Folder.ZFSendToTarget" %NSD% del /q /f "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\SendTo\Compressed (zipped) Folder.ZFSendToTarget"
%NSD% RD /Q /S "%MOU%\PerfLogs"
%NSD% RMDIR /S /Q "%MOU%\Users\Default\Links"
if exist "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Help.lnk" %NSD% del /q /f "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Help.lnk"

if exist "%MOU%\Windows\System32\catroot2\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}" %NSD% RMDIR /S /Q "%MOU%\Windows\System32\catroot2\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}"
if exist "%MOU%\Windows\System32\catroot2\{127D0A1D-4EF2-11D1-8608-00C04FC295EE}" %NSD% RMDIR /S /Q "%MOU%\Windows\System32\catroot2\{127D0A1D-4EF2-11D1-8608-00C04FC295EE}"

echo.
echo 移除System32有关defender文件...
echo.
for /f "eol=: delims=" %%i in ('dir /b "%MOU%\Windows\System32" ^|findstr "FeatureToastBulldogImg.png FeatureToastDlpImg.png hvsievaluator.exe hvsigpext.dll HvsiManagementApi.dll MitigationConfiguration.dll mssecuser.dll RemoteAppLifetimeManager.exe RemoteAppLifetimeManagerProxyStub.dll SecurityHealthAgent.dll SecurityHealthHost.exe SecurityHealthProxyStub.dll SecurityHealthService.exe SecurityHealthSSO.dll SecurityHealthSystray.exe tellib.dll ThirdPartyNoticesBySHS.txt windowsdefenderapplicationguardcsp.dll WindowsSecurityIcon.png winshfhc.dll"') do (
if exist %MOU%\Windows\System32\%%i %NSD% del /q /f  %MOU%\Windows\System32\%%i )
for /f "eol=: delims=" %%i in ('dir /b "%MOU%\Windows\WinSxS\FileMaps" ^|findstr "$$_systemapps_microsoft.windows.sechealthui $$_systemresources_microsoft.windows.sechealthui"') do (
if exist %MOU%\Windows\WinSxS\FileMaps\%%i %NSD% del /q /f  %MOU%\Windows\WinSxS\FileMaps\%%i )

for /f "eol=: delims=" %%i in ('dir /b "%MOU%\Windows\System32\drivers" ^|findstr "mssecflt.sys WdBoot.sys WdFilter.sys WdNisDrv.sys"') do (
if exist %MOU%\Windows\System32\drivers\%%i %NSD% del /q /f  %MOU%\Windows\System32\drivers\%%i )
if exist "%MOU%\Windows\System32\WindowsPowerShell\v1.0\Modules\Defender" %NSD% RD /Q /S "%MOU%\Windows\System32\WindowsPowerShell\v1.0\Modules\Defender" 
if exist "%MOU%\Windows\System32\drivers\zh-CN\mssecflt.sys.mui" %NSD% del /q /f  %MOU%\Windows\System32\drivers\zh-CN\mssecflt.sys.mui 
for /f "eol=: delims=" %%i in ('dir /b "%MOU%\Windows\System32\zh-CN" ^|findstr "hvsievaluator.exe.mui hvsigpext.dll.mui MitigationConfiguration.dll.mui SecurityHealthAgent.dll.mui securityhealthsso.dll.mui"') do (
if exist %MOU%\Windows\System32\zh-CN\%%i %NSD% del /q /f  %MOU%\Windows\System32\zh-CN\%%i )
if exist "%MOU%\Windows\SysWOW64\WindowsPowerShell\v1.0\Modules\Defender" %NSD% RD /Q /S "%MOU%\Windows\SysWOW64\WindowsPowerShell\v1.0\Modules\Defender" 
for /f "eol=: delims=" %%i in ('dir /b "%MOU%\Windows\SysWOW64" ^|findstr "HvsiManagementApi.dll MitigationConfiguration.dll winshfhc.dll"') do (
if exist %MOU%\Windows\SysWOW64\%%i %NSD% del /q /f  %MOU%\Windows\SysWOW64\%%i )
for /f "eol=: delims=" %%i in ('dir /b "%MOU%\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}" ^|findstr "Microsoft-OneCoreUAP-AppRuntime-RemoteAppLifetimeManager-Package Microsoft-Windows-HVSI-Components-Package Microsoft-Windows-HVSI-Components-WOW64-Package Microsoft-Windows-HVSI-Package Microsoft-Windows-HVSI-WOW64-Package Microsoft-Windows-SenseClient-Package Windows-Defender-AM-Default-Definitions-Package Windows-Defender-AppLayer-Group-Package Windows-Defender-ApplicationGuard-Inbox-Package Windows-Defender-Client-Package Windows-Defender-Core-Group-Package Windows-Defender-Group-Policy-Package Windows-Defender-Management-Group-Package Windows-Defender-Management-MDM-Group-Package Windows-Defender-Management-Powershell-Group-Package Windows-Defender-Nis-Group-Package"') do (
if exist %MOU%\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\%%i %NSD% del /q /f  %MOU%\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\%%i )
if exist "%MOU%\Windows\ELAMBKUP\WdBoot.sys" %NSD% del /q /f  %MOU%\Windows\ELAMBKUP\WdBoot.sys 
for /f "eol=: delims=" %%i in ('dir /b "%MOU%\Windows\PolicyDefinitions" ^|findstr "AppHVSI.admx ExploitGuard.admx WindowsDefender.admx WindowsDefenderSecurityCenter.admx"') do (
if exist %MOU%\Windows\PolicyDefinitions\%%i %NSD% del /q /f  %MOU%\Windows\PolicyDefinitions\%%i )
for /f "eol=: delims=" %%i in ('dir /b "%MOU%\Windows\PolicyDefinitions\zh-CN" ^|findstr "AppHVSI.admx ExploitGuard.admx WindowsDefender.admx WindowsDefenderSecurityCenter.admx"') do (
if exist %MOU%\Windows\PolicyDefinitions\zh-CN\%%i %NSD% del /q /f  %MOU%\Windows\PolicyDefinitions\zh-CN\%%i )
if exist "%MOU%\Windows\ELAMBKUP\WdBoot.sys" %NSD% del /q /f  %MOU%\Windows\ELAMBKUP\WdBoot.sys 

ping -n 5 127.1>nul
rem 设置拒绝访问
if not exist "%MOU%\Windows\SystemApps\Microsoft.Windows.SecHealthUI_cw5n1h2txyewy" md "%MOU%\Windows\SystemApps\Microsoft.Windows.SecHealthUI_cw5n1h2txyewy"
echo Y|cacls "%MOU%\Windows\SystemApps\Microsoft.Windows.SecHealthUI_cw5n1h2txyewy" /P everyone:N >nul

Dism /Image:%MOU% /Cleanup-Image /StartComponentCleanup &&Dism /Image:%MOU% /Cleanup-Image /StartComponentCleanup /ResetBase
echo.
echo Windows Defender已经卸载，程序返回！！！
echo.
ping -n 5 127.1>nul
cls
goto MENU


:GENLIT
echo.
echo 通用安全适度精简...
echo.

Dism /Image:%MOU% /english /Get-Features>%DIC%Features.txt
rem for /f "tokens=4 delims= " %%a in (%DIC%Features.txt) do (echo "%%a"|find /i "MediaPlayer" &&Dism /image:%MOU% /Disable-Feature /Featurename:%%a)
rem for /f "tokens=4 delims= " %%a in (%DIC%Features.txt) do (echo "%%a"|find /i "SmbDirect" &&Dism /image:%MOU% /Disable-Feature /Featurename:%%a)
del /f /q %DIC%Features.txt

if exist "%MOU%\Program Files\WindowsApps\Microsoft.549981C3F5F10_1.1911.21713.0_x64__8wekyb3d8bbwe" %NSD% RMDIR /S /Q "%MOU%\Program Files\WindowsApps\Microsoft.549981C3F5F10_1.1911.21713.0_x64__8wekyb3d8bbwe" 
if exist "%MOU%\Program Files\WindowsApps\Microsoft.549981C3F5F10_1.1911.21713.0_neutral_~_8wekyb3d8bbwe" %NSD% RMDIR /S /Q "%MOU%\Program Files\WindowsApps\Microsoft.549981C3F5F10_1.1911.21713.0_neutral_~_8wekyb3d8bbwe" 
if exist %MOU%\ProgramData\Microsoft\Windows\ClipSVC\Install\Apps\microsoft.549981c3f5f10_8wekyb3d8bbwe.xml %NSD% del /q /f  %MOU%\ProgramData\Microsoft\Windows\ClipSVC\Install\Apps\microsoft.549981c3f5f10_8wekyb3d8bbwe.xml 

echo.
echo 移除assembly数据...
echo.
dir /b /a:d %MOU%\Windows\assembly\ >%DIC%WinSxSTemp4.txt
find /i "NativeImages_" %DIC%WinSxSTemp4.txt>%DIC%MyTemp4.txt
find /i "_64" %DIC%MyTemp4.txt>%DIC%MyTemp5.txt
for /f %%i in (%DIC%MyTemp5.txt) do (
if exist "%MOU%\Windows\assembly\%%i" %NSD% RMDIR /S /Q "%MOU%\Windows\assembly\%%i" )
find /i "_32" %DIC%MyTemp4.txt>MyTemp6.txt
for /f %%i in (%DIC%MyTemp6.txt) do (
if exist "%MOU%\Windows\assembly\%%i" %NSD% RMDIR /S /Q "%MOU%\Windows\assembly\%%i" )
del /q /f %DIC%WinSxSTemp4.txt
del /q /f %DIC%MyTemp4.txt
del /q /f %DIC%MyTemp5.txt
del /q /f %DIC%MyTemp6.txt

echo.
echo 移除RetailDemo...
echo.
dir /b /a:d /s %MOU%\ >%DIC%WinSxSTemp7.txt
find /i "RetailDemo" %DIC%WinSxSTemp7.txt>%DIC%MyTemp7.txt
for /f "tokens=*" %%i in (%DIC%MyTemp7.txt) do (
if exist "%%i" %NSD% RMDIR /S /Q "%%i" )
for /f "eol=: delims=" %%i in ('dir /b "%MOU%\Windows\WinSxS\FileMaps" ^|findstr "$$_systemapps_microsoft.windows.cloudexperiencehost_cw5n1h2txyewy_retaildemo programdata_microsoft_windows_retaildemo"') do (
if exist %MOU%\Windows\WinSxS\FileMaps\%%i %NSD% del /q /f  %MOU%\Windows\WinSxS\FileMaps\%%i )
if exist %MOU%\Windows\System32\RDXService.dll %NSD% del /q /f  %MOU%\Windows\System32\RDXService.dll 
if exist %MOU%\Windows\System32\zh-CN\RDXService.dll.mui %NSD% del /q /f  %MOU%\Windows\System32\zh-CN\RDXService.dll.mui 
if exist %MOU%\Windows\SystemApps\Microsoft.Windows.CloudExperienceHost_cw5n1h2txyewy\RetailDemo.Internal.winmd %NSD% del /q /f  %MOU%\Windows\SystemApps\Microsoft.Windows.CloudExperienceHost_cw5n1h2txyewy\RetailDemo.Internal.winmd 
del /q /f %DIC%WinSxSTemp7.txt
del /q /f %DIC%MyTemp7.txt

if exist "%MOU%\Windows\WinSxS\Temp" %NSD% RMDIR /S /Q "%MOU%\Windows\WinSxS\Temp" 

if exist %MOU%\Windows\Help (
echo.
echo 精简帮助 HELP 数据...
echo.
%NSD% del /f /q %MOU%\Windows\HelpPane.exe
%NSD% RMDIR /S /Q "%MOU%\Windows\Help" )

echo.
echo 移除英文简中以外输入法数据...
echo.
if exist "%MOU%\Windows\zh-CN" %NSD% "RMDIR /S /Q "%MOU%\Windows\InputMethod\CHT""
%NSD% "RMDIR /S /Q "%MOU%\Windows\InputMethod\JPN""
%NSD% "RMDIR /S /Q "%MOU%\Windows\InputMethod\KOR""
if exist "%MOU%\Windows\zh-CN" %NSD% "RMDIR /S /Q "%MOU%\Windows\System32\InputMethod\CHT""
%NSD% "RMDIR /S /Q "%MOU%\Windows\System32\InputMethod\JPN""
%NSD% "RMDIR /S /Q "%MOU%\Windows\System32\InputMethod\KOR""
if exist %MOU%\Windows\SysWOW64 %NSD% "RMDIR /S /Q "%MOU%\Windows\SysWOW64\InputMethod\JPN""
for /f %%i in ('dir /ad /b %MOU%\Windows\SysWOW64\*-*') do echo %%i |findstr /i "en-US zh-CN zh-HANS" || (%NSD% "rd %MOU%\Windows\SysWOW64\%%i /s /q" )
%NSD% "del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\mshwchsr.dll""
%NSD% "del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\mraut.dll""
%NSD% "del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\chslm.wdic2.bin""
%NSD% "del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\micaut.dll""
for /f %%i in ('dir /ad /b "%MOU%\Program Files\Common Files\microsoft shared\ink\*-*"') do echo %%i |findstr /i "en-US zh-CN" || (%NSD% "rd "%MOU%\Program Files\Common Files\microsoft shared\ink\%%i" /s /q" )
for /f %%i in ('dir /ad /b %MOU%\Windows\System32\*-*') do echo %%i |findstr /i "en-US zh-CN zh-HANS" || (%NSD% "rd %MOU%\Windows\System32\%%i /s /q" )

echo.
echo 清理一些无用的启动显示字体...
echo.
set File=%MOU%\Windows\Boot\Fonts
for /f %%i in ('dir /a-d /b %File%\*_*.ttf') do echo %%i |findstr /i "chs_boot cht_boot msjh_boot msjhn_boot wgl4_boot msyh seg" || (%NSD% del %File%\%%i /f /q)
set File=%MOU%\Windows\Boot\PCAT
for /f %%i in ('dir /ad /b %File%\*-*') do echo %%i |findstr /i "en-US zh-CN zh-TW zn-HK" || (%NSD% rd %File%\%%i /s /q )
set File=%MOU%\Windows\Boot\EFI
for /f %%i in ('dir /ad /b %File%\*-*') do echo %%i |findstr /i "en-US zh-CN zh-TW zn-HK" || (%NSD% rd %File%\%%i /s /q )

echo.
echo 移除Recovery...
echo.
if exist "%MOU%\Windows\System32\Recovery\Winre.wim" %NSD% del /q /f  %MOU%\Windows\System32\Recovery\Winre.wim 

Dism /Image:%MOU% /English /Get-packages >%DIC%packages.txt
for /f "tokens=4 delims= " %%a in (%DIC%packages.txt) do (echo "%%a"|find /i "-QuickAssist-" &&Dism /image:%MOU% /Remove-Package /PackageName:%%a)
for /f "tokens=4 delims= " %%a in (%DIC%packages.txt) do (echo "%%a"|find /i "-MediaPlayer-" &&Dism /image:%MOU% /Remove-Package /PackageName:%%a)
for /f "tokens=4 delims= " %%a in (%DIC%packages.txt) do (echo "%%a"|find /i "-DeveloperMode-" &&Dism /image:%MOU% /Remove-Package /PackageName:%%a)
rem for /f "tokens=4 delims= " %%a in (%DIC%packages.txt) do (echo "%%a"|find /i "-ContactSupport-" &&Dism /image:%MOU% /Remove-Package /PackageName:%%a)

echo.
echo 如果是多语言系统或添加了中文语言包将删除非 ZH-CN 语言数据...
echo.
for /f "tokens=4 delims= " %%a in (%DIC%packages.txt) do (echo "%%a"|find /i "LanguageFeatures-Basic-" &&echo %%a >>%DIC%Languagelist.txt)
for /f %%i in (%DIC%Languagelist.txt) do echo %%i |findstr /i "en-US zh-CN zh-TW zh-HK" || Dism /image:%MOU% /Remove-Package /PackageName:%%i
del /f /q %DIC%packages.txt
del /f /q %DIC%Languagelist.txt

echo.
echo 移除BACKUP数据...
echo.
if exist "%MOU%\Windows\WinSxS\Backup" %NSD% RMDIR /S /Q "%MOU%\Windows\WinSxS\Backup" 

Dism /Image:%MOU% /Cleanup-Image /StartComponentCleanup &&Dism /Image:%MOU% /Cleanup-Image /StartComponentCleanup /ResetBase
echo.
echo 通用安全适度精简完成，程序返回！！！
echo.
ping -n 5 127.1>nul
cls
goto MENU

:UNEDGE
echo.
echo 卸载Microsoft Edge......
echo.

%TWK% /p "%MOU%" /c Microsoft-Windows-Internet-Browser /r >nul 2>nul
if exist "%MOU%\Windows\SystemApps\Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe" %NSDT% RMDIR /S /Q "%MOU%\Windows\SystemApps\Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe"
if exist "%MOU%\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" %NSDT% RMDIR /S /Q "%MOU%\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe"

if exist "%MOU%\Program Files (x86)\Microsoft" %NSDT% RMDIR /S /Q "%MOU%\Program Files (x86)\Microsoft"

reg load HKLM\SOFT "%MOU%\Windows\System32\config\software"
for /f "eol=: tokens=*" %%i in ('reg query "HKLM\SOFT" /s /f "MicrosoftEdge" /k') do (%NSDT% "reg delete "%%i" /f" )
for /f "eol=: tokens=*" %%i in ('reg query "HKLM\SOFT" /s /f "Microsoft Edge" /k') do (%NSDT% "reg delete "%%i" /f" )
reg unload HKLM\SOFT
copy /y "%DIC%\windows\UninstallEdge.exe.lnk" "%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\" >nul 2>nul
copy /y "%DIC%\windows\UninstallEdge.exe" "%MOU%\Windows\" >nul 2>nul

ping -n 10 127.1>nul
rem 设置拒绝访问
if not exist "%MOU%\Program Files (x86)\Microsoft\EdgeUpdate\Install" md "%MOU%\Program Files (x86)\Microsoft\EdgeUpdate\Install"
echo Y|cacls "%MOU%\Program Files (x86)\Microsoft\EdgeUpdate\Install" /P everyone:N >nul
if not exist "%MOU%\Program Files (x86)\Microsoft\Edge" md "%MOU%\Program Files (x86)\Microsoft\Edge"
echo Y|cacls "%MOU%\Program Files (x86)\Microsoft\Edge" /P everyone:N >nul

echo 操作成功完成！
echo.
echo Microsoft Edge已经卸载，程序返回！！！
echo.
ping -n 5 127.1>nul
cls
goto MENU

:SETVALUE
reg add "HKLM\SOFT\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\%~1" /v Visibility /t REG_DWORD /d 1 /f
reg delete "HKLM\SOFT\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\%~1\Owners" /f
goto:eof

:GetNow
rem 查询版本
%SSREG% >nul
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild"') do (echo %%a)>19044.txt
for /f "tokens=1,2*" %%i in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "ProductName"') do (echo %%k)>Windows-10-Enterprise.txt
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "EditionID"') do (echo %%a)>Professional.txt
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "DisplayVersion"') do (echo %%a)>21H2.txt
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "UBR"') do (echo %%a)>1288.txt
%UNREG% >nul
goto :eof

:OPTOS
ECHO.
ECHO 正在执行Win10优化，请勿关闭窗口...
ECHO.
rem 隐藏此电脑的七个文件夹
%SSREG% >nul
rem 隐藏此电脑中的 视频 文件夹
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f  >nul 2>nul
reg add "HKLM\0\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f  >nul 2>nul
rem 隐藏此电脑中的 图片 文件夹
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f  >nul 2>nul
reg add "HKLM\0\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f  >nul 2>nul
rem 隐藏此电脑中的 文档 文件夹
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f  >nul 2>nul
reg add "HKLM\0\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f  >nul 2>nul
rem 隐藏此电脑中的 音乐 文件夹
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f  >nul 2>nul
reg add "HKLM\0\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f  >nul 2>nul
rem 隐藏此电脑中的 桌面 文件夹
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f  >nul 2>nul
reg add "HKLM\0\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f  >nul 2>nul
rem 隐藏此电脑中的 3D对象 文件夹
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f  >nul 2>nul
reg add "HKLM\0\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f  >nul 2>nul
rem 隐藏此电脑中的 下载 文件夹
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f  >nul 2>nul
reg add "HKLM\0\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f  >nul 2>nul
%UNREG% >nul
%SSREG% >nul
echo.
echo 系统优化相关设置 ...
echo.
reg add "HKLM\0\Microsoft\Command Processor" /v "CompletionChar" /t REG_DWORD /d 64 /f >nul
reg add "HKLM\0\Microsoft\Windows\Windows Error Reporting\Assert Filtering Policy" /v "ReportAndContinue" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\Windows Error Reporting\Assert Filtering Policy" /v "AlwaysUnloadDll" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\Windows Error Reporting\Assert Filtering Policy" /v "Max Cached Icons" /t REG_SZ /d "7500" /f >nul
rem 关闭客户体验改善计划
reg add "HKLM\0\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /d 0 /t REG_DWORD /f  >nul 2>nul 
rem 关闭在应用商店中查找关联应用
reg add "HKLM\0\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t reg_dword /d "1" /f  >nul 2>nul
rem 禁用Windows应用商店后台静默安装软件
reg add "HKLM\0\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t reg_dword /d "1" /f  >nul 2>nul
rem 从不检测更新
reg add "HKLM\0\WOW6432Node\Policies\Microsoft\Windows\WindowsUpdate\AU" /f /v "AUOptions" /t REG_DWORD /d 1
reg add "HKLM\0\WOW6432Node\Policies\Microsoft\Windows\WindowsUpdate\AU" /f /v "NoAutoUpdate" /t REG_DWORD /d 1
reg add "HKLM\0\Policies\Microsoft\Windows\WindowsUpdate\AU" /f /v "AUOptions" /t REG_DWORD /d 1
reg add "HKLM\0\Policies\Microsoft\Windows\WindowsUpdate\AU" /f /v "NoAutoUpdate" /t REG_DWORD /d 1
rem 禁止一联网就打开浏览器
rem reg add "HKLM\0\Policies\Microsoft\Windows\NetworkConnectivityStatusIndicator" /v "NoActiveProbe" /d 1 /t REG_DWORD /f  >nul 2>nul 
rem 去除UAC小盾牌
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 77 /d "%systemroot%\system32\imageres.dll,197" /t reg_sz /f  >nul 2>nul 
rem 删除SecurityHealth启动
reg delete "HKLM\0\Microsoft\Windows\CurrentVersion\Run" /f /v "SecurityHealth" >nul 2>nul
rem 关闭Smartscreen应用筛选器
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /d off /t REG_SZ /f
rem 关闭用户账户控制(UAC)
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /d 0 /t REG_DWORD /f
rem 显示我的电脑，隐藏我的文档
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /d 0 /t REG_DWORD /f
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /d 1 /t REG_DWORD /f
rem 关闭程序兼容性助手
reg add "HKLM\0\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t REG_DWORD /d "1"   /f  >nul 2>nul
rem 更新优化
reg add "HKLM\0\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /d 1 /t REG_DWORD /f  >nul 2>nul 
reg add "HKLM\0\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AutoInstallMinorUpdates" /d 1 /t REG_DWORD /f  >nul 2>nul 
reg add "HKLM\0\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /d 1 /t REG_DWORD /f  >nul 2>nul 
rem 去掉快捷方式小箭头
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 29 /d "%systemroot%\system32\imageres.dll,197" /t reg_sz /f
rem 关闭打开程序的安全警告
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\Associations" /v "ModRiskFileTypes" /d ".bat;.exe;.reg;.vbs;.chm;.msi;.js;.cmd" /t REG_SZ /f
rem 关闭自动播放
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /d 255 /t REG_DWORD /f  >nul 2>nul 
rem 删除右键菜单中兼容性疑难解答
reg delete "HKLM\0\Classes\batfile\shellex\ContextMenuHandlers\Compatibility" /f  >nul 2>nul   
reg delete "HKLM\0\Classes\cmdfile\shellex\ContextMenuHandlers\Compatibility" /f  >nul 2>nul 
reg delete "HKLM\0\Classes\exefile\shellex\ContextMenuHandlers\Compatibility" /f  >nul 2>nul 
reg delete "HKLM\0\Classes\lnkfile\shellex\ContextMenuHandlers\Compatibility" /f  >nul 2>nul 
reg delete "HKLM\0\Classes\Msi.Package\shellex\ContextMenuHandlers\Compatibility" /f  >nul 2>nul 
%UNREG% >nul
%USREG% >nul
rem 隐藏任务栏上的搜索框
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0"   /f  >nul 2>nul   
rem 关闭自动播放
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /d 255 /t REG_DWORD /f  >nul 2>nul 
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v "DisableAutoplay" /t reg_dword /d "1" /f  >nul 2>nul    
rem 快速访问不显示常用文件夹和最近使用的文件
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d "0"   /f  >nul 2>nul   
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d "0"   /f  >nul 2>nul   
rem 关闭锁屏时的Windows 聚焦推广
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnable" /t REG_DWORD /d "0"   /f  >nul 2>nul   
rem 关闭打开程序的安全警告
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Associations" /v "ModRiskFileTypes" /d ".bat;.exe;.reg;.vbs;.chm;.msi;.js;.cmd" /t REG_SZ /f
rem 开始菜单、任务栏、操作中心透明
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "ColorPrevalence" /t reg_dword /d "0" /f  >nul 2>nul    
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "ColorPrevalence" /t reg_dword /d "0" /f  >nul 2>nul    
rem 隐藏操作中心
reg add "HKLM\0\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t reg_dword /d "1" /f  >nul 2>nul    
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAHealth" /t reg_dword /d "1" /f  >nul 2>nul    
rem 显示扩展名
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t reg_dword /d "0" /f  >nul 2>nul    
rem 记事本终显示状态栏
reg add "HKLM\0\Software\Microsoft\Notepad" /v "StatusBar" /t reg_dword /d "1" /f  >nul 2>nul    
rem 记事本启用自动换行
reg add "HKLM\0\Software\Microsoft\Notepad" /v "fWrap" /t reg_dword /d "1" /f  >nul 2>nul    
rem 隐藏任务栏上的人脉
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /v "PeopleBand" /t REG_DWORD /d "0" /f  >nul 2>nul  
rem IE下载连接数10
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /f /v "MaxConnectionsPerServer" /t REG_DWORD /d 10 >nul 2>nul 
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /f /v "MaxConnectionsPer1_0Server" /t REG_DWORD /d 10 >nul 2>nul 
rem 删除onedrive开机启动
reg delete "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v "OneDrive" >nul 2>nul
rem 去除快捷方式字样
REG ADD "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer" /v link /t REG_BINARY /d 00000000 /f  >nul 2>nul 
rem 任务栏被占满时合并
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarGlomLevel" /t reg_dword /d "1" /f  >nul 2>nul      
rem 禁止商店自动安装推荐的应用程序 
rem reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0"  /f  >nul 2>nul   
rem 关闭商店应用推广
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d "0" /f  >nul 2>nul    
rem 关闭“使用Windows时获取技巧和建议
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d "0"  /f  >nul 2>nul   
%UNREG% >nul
%SYREG% >nul
rem 禁止远程修改注册表
reg add "HKLM\0\ControlSet001\Control\SecurePipeServers\winreg" /f /v "remoteregaccess" /t REG_DWORD /d 1 >nul 2>nul 
rem 开启快速启动,开启系统休眠
reg add "HKLM\0\ControlSet001\Control\Session Manager\Power" /f /v "HiberbootEnabled" /t REG_DWORD /d 1 >nul 2>nul 
reg add "HKLM\0\ControlSet001\Control\Power" /f /v "HibernateEnabled" /t REG_DWORD /d 1 >nul 2>nul 
reg add "HKLM\0\ControlSet001\Services\WerSvc" /f /v "Start" /t REG_DWORD /d 4 >nul 2>nul 
rem 诊断策略服务启用了 Windows 组件的问题检测、疑难解答和解决方案。如果该服务被停止，诊断将不再运行。
reg add "HKLM\0\ControlSet001\Services\DPS"  /f /v "Start" /t REG_DWORD /d 4 >nul 2>nul 
rem 诊断服务主机被诊断策略服务用来承载需要在本地服务上下文中运行的诊断。如果停止该服务，则依赖于该服务的任何诊断将不再运行。
reg add "HKLM\0\ControlSet001\Services\WdiServiceHost"  /f /v "Start" /t REG_DWORD /d 4 >nul 2>nul 
rem 诊断系统主机被诊断策略服务用来承载需要在本地系统上下文中运行的诊断。如果停止该服务，则依赖于该服务的任何诊断将不再运行。
reg add "HKLM\0\ControlSet001\Services\WdiSystemHost"  /f /v "Start" /t REG_DWORD /d 4 >nul 2>nul 
rem 诊断中心标准收集器服务。运行时，此服务会收集实时 ETW 事件，并对其进行处理。
reg add "HKLM\0\ControlSet001\Services\diagnosticshub.standardcollector.service"  /f /v "Start" /t REG_DWORD /d 4 >nul 2>nul 

reg add "HKLM\0\ControlSet001\Services\DialogBlockingService"  /f /v "Start" /t REG_DWORD /d 4 >nul 2>nul
%UNREG% >nul

%USREG% >nul
echo.
echo 加快网络速度 ...
echo.
reg add "HKLM\0\SYSTEM\CurrentControlSet\Services\atapi\Parameters" /v "EnableBigLba" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" /v "EnableConnectionRateLimiting" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d 80 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Lsa" /v "limitblankpassworduse" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Lsa" /v "forceguest" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Lsa" /v "Restrictanonymous" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Lsa" /v "Restrictanonymoussam" /t REG_DWORD /d 0 /f >nul
echo.
echo 优化系统预读加快运行 ...
echo.
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Session Manager" /v "AutoChkTimeOut" /t REG_DWORD /d 3 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\CurrentControlSet\Services\Messenger" /v "Start" /t REG_DWORD /d 4 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargePageMinimum" /t REG_DWORD /d "4294967295" /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\CrashControl" /v "LogEvent" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\CrashControl" /v "SendAlert" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" /v "CPUPriority" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" /v "PCIConcur" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" /v "FastDRAM" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" /v "AGPConcur" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\FileSystem" /v "ConfigFileAllocSize" /t REG_DWORD /d 500 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "1000" /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" /v "RemoteRegAccess" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Windows" /v "NoPopUpsOnBoot" /t REG_SZ /d "0" /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f >nul
reg add "HKLM\0\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f >nul
reg add "HKLM\0\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "1000" /f >nul
reg add "HKLM\0\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul
%UNREG% >nul

%SSREG% >nul
echo.
echo 右键添加获取管理员权限...
echo.
reg add "HKLM\0\Classes\*\shell\runas" /ve /t REG_SZ /d "管理员取得所有权" /f >nul
reg add "HKLM\0\Classes\*\shell\runas" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\imageres.dll,-79" /f >nul
reg add "HKLM\0\Classes\*\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >nul
reg add "HKLM\0\Classes\*\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >nul
reg add "HKLM\0\Classes\*\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >nul
reg add "HKLM\0\Classes\exefile\shell\runas2" /ve /t REG_SZ /d "管理员取得所有权" /f >nul
reg add "HKLM\0\Classes\exefile\shell\runas2" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\imageres.dll,-79" /f >nul
reg add "HKLM\0\Classes\exefile\shell\runas2" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >nul
reg add "HKLM\0\Classes\exefile\shell\runas2\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >nul
reg add "HKLM\0\Classes\exefile\shell\runas2\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >nul
reg add "HKLM\0\Classes\Directory\shell\runas" /ve /t REG_SZ /d "管理员取得所有权" /f >nul
reg add "HKLM\0\Classes\Directory\shell\runas" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\imageres.dll,-79" /f >nul
reg add "HKLM\0\Classes\Directory\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >nul
reg add "HKLM\0\Classes\Directory\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f >nul
reg add "HKLM\0\Classes\Directory\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f >nul
%UNREG% >nul
echo.
echo 优化完毕！！！
echo.
ping -n 5 127.1>nul
cls
goto MENU

:WRZS
echo.
echo 安装无人值守和更换壁纸...
echo.
XCOPY /s /e /y %DIC%Windows\Panther\ %MOU%\Windows\Panther\
cmd.exe /c takeown /f "%MOU%\Windows\Web" /r /d y && icacls "%MOU%\Windows\Web" /grant administrators:F /t
XCOPY /s /e /y %DIC%Web\Wallpaper\Windows\ %MOU%\Windows\Web\Wallpaper\Windows\
echo.
echo 安装无人值守和更换壁纸完成！！！
echo.
ping -n 5 127.1>nul
cls
goto MENU

:OPTWINSXS
echo.
echo 优化WinSxS(不能更新)，请耐心等待二十分钟左右，请勿关闭窗口...
echo.
if exist %DIC%ReserveWinSxS.txt %NSD% del /q /f %DIC%ReserveWinSxS.txt
if exist %DIC%ReserveManifest.txt %NSD% del /q /f %DIC%ReserveManifest.txt
for /f "eol=: delims=" %%i in ('dir /b /ad "%MOU%\Windows\WinSxS" ^|findstr "amd64_microsoft-windows-t..languages.resources amd64_microsoft-windows-servicingstack x86_microsoft.windows.c..-controls.resources amd64_microsoft-windows-com-dtc-runtime amd64_microsoft.vc80.crt amd64_microsoft.vc90.crt amd64_microsoft.windows.c..-controls.resources amd64_microsoft.windows.common-controls amd64_microsoft.windows.gdiplus Catalogs InstallTemp Manifests x86_microsoft-windows-servicingstack x86_microsoft.vc80.crt x86_microsoft.vc90.crt x86_microsoft.windows.common-controls x86_microsoft.windows.gdiplus"') do (echo %%i)>>%DIC%ReserveWinSxS.txt
for /f "eol=: delims=" %%i in ('dir /b %MOU%\Windows\WinSxS\Manifests ^|findstr "amd64_microsoft-windows-com-dtc-runtime amd64_microsoft-windows-coreos-revision amd64_microsoft-windows-deployment amd64_microsoft-windows-enhancedstorage-adm amd64_microsoft-windows-explorer amd64_microsoft-windows-i..national-core-winpe amd64_microsoft-windows-international-core amd64_microsoft-windows-r..-service.deployment amd64_microsoft-windows-security-spp-ux amd64_microsoft-windows-servicingstack amd64_microsoft-windows-setup_ amd64_microsoft-windows-shell-setup amd64_microsoft-windows-t..languages.resources amd64_microsoft-windows-unattendedjoin amd64_microsoft.vc80.crt amd64_microsoft.vc90.crt amd64_microsoft.windows.c..-controls.resources amd64_microsoft.windows.common-controls amd64_microsoft.windows.gdiplus amd64_microsoft.windows.i..utomation.proxystub amd64_microsoft.windows.isolationautomation amd64_microsoft.windows.systemcompatible amd64_policy.8.0.microsoft.vc80.crt amd64_policy.9.0.microsoft.vc90.crt x86_microsoft-windows-servicingstack x86_microsoft.vc80.crt x86_microsoft.vc90.crt x86_microsoft.windows.c..-controls.resources x86_microsoft.windows.common-controls x86_microsoft.windows.gdiplus x86_microsoft.windows.i..utomation.proxystub x86_microsoft.windows.isolationautomation x86_microsoft.windows.systemcompatible x86_policy.8.0.microsoft.vc80.crt x86_policy.9.0.microsoft.vc90.crt"') do (echo %%i)>>%DIC%ReserveManifest.txt
for /f "eol=: delims=" %%i in ('dir /b "%MOU%\Windows\WinSxS" /ad^|findstr /vxilg:"%DIC%ReserveWinSxS.txt"') do (
if exist "%MOU%\Windows\WinSxS\%%i" (
rem cmd.exe /c takeown /f "%MOU%\Windows\WinSxS\%%i"  /r /d y && icacls "%MOU%\Windows\WinSxS\%%i" /grant administrators:F /t 
RD /Q /S "%MOU%\Windows\WinSxS\%%i" ))
for /f "eol=: delims=" %%i in ('dir /b %MOU%\Windows\WinSxS\Manifests^|findstr /vxilg:"%DIC%ReserveManifest.txt"') do (
if exist %MOU%\Windows\WinSxS\Manifests\%%i (
rem cmd.exe /c takeown /f %MOU%\Windows\WinSxS\Manifests\%%i && icacls %MOU%\Windows\WinSxS\Manifests\%%i /grant administrators:F /t 
del /q /s %MOU%\Windows\WinSxS\Manifests\%%i ))
del /q /f %DIC%ReserveWinSxS.txt
del /q /f %DIC%ReserveManifest.txt
echo.
echo 优化WinSxS完成！！！
echo.

for /f "eol=: delims=" %%i in ('dir /b %MOU%\Windows\servicing\Packages ^|findstr "Microsoft-Hyper-V"') do (
if exist %MOU%\Windows\servicing\Packages\%%i del /q /f  %MOU%\Windows\servicing\Packages\%%i )

ping -n 5 127.1>nul
cls
goto MENU

:GXBD
echo.
echo 开始更新 ...
echo.
set patch=1
set /p patch=  更新补丁直接回车默认为1， 更新.net为2 ：
if "%patch%"=="1" ( Dism /image:%MOU% /add-package /packagepath:%DIC%Patch
echo.
echo 补丁更新完成！！！
echo.
)
if "%patch%"=="2" ( Dism /image:%MOU% /add-package /packagepath:%DIC%sxs
echo.
echo  .net更新完成！！！
echo.
)
ping -n 5 127.1>nul
cls
goto MENU

:UNMO
echo.
echo 选择保存卸载还是重构优化映像或进行转换...
echo.
set num=1
set /p num=回车默认选1保存映像，选2重构优化压缩wim映像，选3wim转换为esd，选4esd转行为wim：
set "wimname="
set index=1
if "%num%"=="1" goto BCXZ
if "%num%"=="2" goto OPTI
if "%num%"=="3" goto TOESD
if "%num%"=="4" goto TOWIM
echo.
echo 操作成功完成！！！
echo.
ping -n 3 127.1>nul
cls
goto MENU

:BCXZ
ECHO.
ECHO 保存映像(保存后请运行2重构压缩映像减小体积)...
ECHO.

if exist "%MOU%\$Recycle.Bin" %NSD% del /f /q "%MOU%\$Recycle.Bin" >nul 2>&1
if exist "%MOU%\PerfLogs" %NSD% RD /Q /S "%MOU%\PerfLogs" >nul 2>&1
if exist "%MOU%\Users\Default\*.LOG1" %NSD% del /f /q "%MOU%\Users\Default\*.LOG1" >nul 2>&1
if exist "%MOU%\Users\Default\*.LOG2" %NSD% del /f /q "%MOU%\Users\Default\*.LOG2" >nul 2>&1
if exist "%MOU%\Users\Default\*.TM.blf" %NSD% del /f /q "%MOU%\Users\Default\*.TM.blf" >nul 2>&1
if exist "%MOU%\Users\Default\*.regtrans-ms" %NSD% del /f /q "%MOU%\Users\Default\*.regtrans-ms" >nul 2>&1
if exist "%MOU%\Windows\inf\*.log" %NSD% del /f /q "%MOU%\Windows\inf\*.log" >nul 2>&1
if exist "%MOU%\Windows\CbsTemp\*" (
for /f %%i in ('"dir /s /b /ad "%MOU%\Windows\CbsTemp\*"" 2^>nul') do (%NSD% RD /Q /S %%i)
%NSD% del /s /f /q "%MOU%\Windows\CbsTemp\*" >nul 2>&1)
if exist "%MOU%\Windows\System32\config\*.LOG1" %NSD% del /f /q "%MOU%\Windows\System32\config\*.LOG1" >nul 2>&1
if exist "%MOU%\Windows\System32\config\*.LOG2" %NSD% del /f /q "%MOU%\Windows\System32\config\*.LOG2" >nul 2>&1
if exist "%MOU%\Windows\System32\config\*.TM.blf" %NSD% del /f /q "%MOU%\Windows\System32\config\*.TM.blf" >nul 2>&1
if exist "%MOU%\Windows\System32\config\*.regtrans-ms" %NSD% del /f /q "%MOU%\Windows\System32\config\*.regtrans-ms" >nul 2>&1
if exist "%MOU%\Windows\System32\SMI\Store\Machine\*.LOG1" %NSD% del /f /q "%MOU%\Windows\System32\SMI\Store\Machine\*.LOG1" >nul 2>&1
if exist "%MOU%\Windows\System32\SMI\Store\Machine\*.LOG2" %NSD% del /f /q "%MOU%\Windows\System32\SMI\Store\Machine\*.LOG2" >nul 2>&1
if exist "%MOU%\Windows\System32\SMI\Store\Machine\*.TM.blf" %NSD% del /f /q "%MOU%\Windows\System32\SMI\Store\Machine\*.TM.blf" >nul 2>&1
if exist "%MOU%\Windows\System32\SMI\Store\Machine\*.regtrans-ms" %NSD% del /f /q "%MOU%\Windows\System32\SMI\Store\Machine\*.regtrans-ms" >nul 2>&1
if exist "%MOU%\Windows\WinSxS\Backup\*.*" %NSD% del /f /q "%MOU%\Windows\WinSxS\Backup\*.*" >nul 2>&1
if exist "%MOU%\Windows\WinSxS\ManifestCache\*.bin" %NSD% del /f /q "%MOU%\Windows\WinSxS\ManifestCache\*.bin" >nul 2>&1
if exist "%MOU%\Windows\WinSxS\Temp\PendingDeletes\*" %NSD% del /f /q "%MOU%\Windows\WinSxS\Temp\PendingDeletes\*" >nul 2>&1
if exist "%MOU%\Windows\WinSxS\Temp\TransformerRollbackData\*" %NSD% del /f /q "%MOU%\Windows\WinSxS\Temp\TransformerRollbackData\*" >nul 2>&1

Dism /Image:%MOU% /Cleanup-Image /StartComponentCleanup &&Dism /Image:%MOU% /Cleanup-Image /StartComponentCleanup /ResetBase
ECHO.
ECHO 如果提示清理异常或存在挂启状态  均可忽略继续其它操作！！！
ECHO.
rem Dism  /Commit-Image /mountdir:%MOU% 
Dism  /Unmount-Image /mountdir:%MOU% /commit
ping -n 3 127.1>nul
cls
goto MENU

:OPTI
set /p wimname=请输入要重构优化%Root%下的映像文件名称(带扩展名):
ECHO.
ECHO 重构优化压缩映像%Root%%wimname%...
ECHO.
%DIC%wimlib-imagex.exe optimize %Root%%wimname% --check --compress=lzx:100
rem start /w %DIC%WimOptimize.exe %Root%%wimname%
ping -n 3 127.1>nul
cls
goto MENU

:TOESD
set /p wimname=请输入要转换为esd的%Root%下的映像文件名称(不带扩展名):
set index=1
set /p index=请输入%Root%%wimname%.wim中要操作的索引序号, 直接回车默认为1:
ECHO.
ECHO %Root%%wimname%.wim转换为%Root%%wimname%.esd...
ECHO.
DISM/Export-Image /SourceImageFile:%Root%%wimname%.wim /SourceIndex:%index% /DestinationImageFile:%Root%%wimname%.esd /compress:recovery /CheckIntegrity
ping -n 3 127.1>nul
cls
goto MENU

:TOWIM
set /p wimname=请输入要转换为wim的%Root%下的映像文件名称(不带扩展名):
set index=1
set /p index=请输入%Root%%wimname%.esd中要操作的索引序号,直接回车默认为1:
ECHO.
ECHO %Root%%wimname%.esd转换为%Root%%wimname%.wim...
ECHO.
dism /Export-Image /SourceImageFile:%Root%%wimname%.esd /SourceIndex:%index% /DestinationImageFile:%Root%%wimname%.wim /Compress:Max /CheckIntegrity
ping -n 3 127.1>nul
cls
goto MENU

:TUIC
echo.
echo 清理卸载映像......
echo.
dism /unmount-wim /MountDir:%MOU% /discard
dism /cleanup-mountpoints
if exist %Root%win10 if not exist %Root%win10\Windows\system32\config\SOFTWARE (
if exist %DIC%SOFTWAREBKP %NSD% del /f /q %DIC%SOFTWAREBKP
%NSD% RMDIR /Q /S "%Root%win10" >nul 2>nul )
echo.
echo 退出并关闭程序 欢迎再次使用，再见！！！
echo.
ping -n 3 127.1 >nul
exit /q