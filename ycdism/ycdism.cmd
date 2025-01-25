@echo off&&color 1F&&chcp 936
mode con cols=98 lines=45
set title= ***** 雨晨终极 MS ISO装载精简升级制作 [YCDISM NT6-10 终结版 180501 ] *****
title  %title%
if /i %PROCESSOR_ARCHITECTURE% EQU AMD64 (set Obt=x64) ELSE (set Obt=x86)
setlocal EnableDelayedExpansion
cd /d "%~dp0" &&SET "YCDM=dism.exe"
set "SetACL=%~dp0TOOL\SetACL%Obt%.exe"
SET "YCP=%~dp0"
ver |find " 10.">nul &&set TheOS=Win10
ver |find " 6.3">nul &&set TheOS=Win81
ver |find " 6.2">nul &&set TheOS=Win8
ver |find " 6.1">nul &&set TheOS=Win7
if %TheOS% equ Win10 goto SETP
if %TheOS% equ Win81 goto SETP
if %TheOS% equ Win8 goto SETP
if %TheOS% equ Win7 goto SETP
echo.
echo   请确认你是在 Windows 7 以上系统下运行本程序 6秒后将自动退出
echo.
ping -n 6 127.1>nul
exit /q

:SETP
echo.
echo.
echo         %title%
echo.
for /f "tokens=3 delims=: " %%b in ('%YCDM% /english /online /Get-Intl ^| find /i "System locale"') do set OUI=%%b
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "BuildLabEx"') do set UBR=%%a
set UBR=%UBR:~28%
for /f "tokens=2 delims=." %%a in ('echo %UBR%') do set OZD=%%a
>NUL 2>NUL reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "UBR" ||GOTO :KAISHI
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "UBR"') do set BDH=%%a
set BDH=%BDH:~26%
set /a BDH=0x%BDH%
set OZD=%BDH%
:KAISHI
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild"') do set OMD=%%a
set OMD=%OMD:~30%
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "BuildLabEx"') do set UBR=%%a
set ORS=%UBR:~-11,4%
for /f "tokens=5 delims=._" %%a in ('echo %UBR%') do (set OSV=%%a)
for /f "tokens=1,2*" %%i in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductName"') do set OOS=%%k
for /f "tokens=1,2,3 delims= " %%a in ('echo %OOS%') do (
set NTver=%%a %%b
set Bliud=%%c
)
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "EditionID"') do set OEID=%%a
set OEID=%OEID:~27%
set PDPRO=%OEID:~0,3%
if /i "%OEID%"=="Professional" set OEID=Pro%OEID:~12%&&set OOS=%NTver% %OEID%
if not "%OEID%"=="Professional" set OEID=%OEID%&&set OOS=%NTver% %OEID%
set OOS=%OOS%
echo.
echo           当前系统^:%OOS% %Obt% %OUI% %OSV% %ORS%（%OMD%^.%OZD%）
echo.
echo                                  当前日期^:%date%
echo.
echo                程序开始工作前请确定工作分区必须为NTFS格式并大于30G自由可写空间
echo.
echo                本程序推荐放在分区根下 目录和路径中不要包含^:空格/中文或特殊符号
echo.
echo                install.wim、esd（加密ESD请用TOOL\ESDtoISO\ESDtoISO.CMD解密转换）
echo.
echo                在和程序互动时请保持输入法状态为英文 以免操作造成意外退出或终止
echo.
echo                当前本程序运行的位置为%~dp0 如果不符合继续条件请移动或更改
:SISO
echo.
echo                请装载或输入已装载ISO的盘符字母比如"H:" 双架构ISO请输入架构目录
echo.
echo                完整路径比如"H:\x86" Windows 8以上系统启用Net3.5需要ISO\SXS支持
echo.
if %TheOS% EQU Win7 (
echo                当前为Win7系统    程序自动调用UltraISO程序为您装载ISO镜像后继续
echo.
start %YCP%TOOL\UltraISO\UltraISO.EXE
)
set ISO=
SET /P "ISO=请输入ISO装载分区盘符字母和":"后按回车开始: "
if "%ISO%"==" " SET "YCDM=%YCP%TOOL\%DmVer%\%Obt%\Dism\dism.exe"
if not exist %YCDM% set "YCDM=dism.exe"
if exist "%ISO%\sources\sxs\microsoft-windows-netfx3*.cab" set "SXS=%ISO%\Sources\sxs"
if exist %ISO%\Sources\install.esd set "WEfile=%ISO%\Sources\install.esd" &&goto :CXXX
if exist %ISO%\Sources\install.wim set "WEfile=%ISO%\Sources\install.wim" &&goto :CXXX
if exist %YCP%YCSINS.WIM set "WEfile=%YCP%YCSINS.WIM" &&goto :CXXX
if exist %YCP%install.esd set "WEfile=%YCP%install.esd" &&goto :CXXX
if exist %YCP%install.wim set "WEfile=%YCP%install.wim" &&goto :CXXX
goto :CheckWE

:CXXX
if %OMD% LEQ 9600 SET YCDM=%YCP%TOOL\9600\%Obt%\Dism\dism.exe &&goto :CXJX
if exist %YCP%TOOL\%OMD%\%Obt%\Dism\dism.exe (
SET "YCDM=%YCP%TOOL\%OMD%\%Obt%\Dism\dism.exe"
) else (
set YCDM=dism.exe
)
:CXJX
set SYSZ=1
for /f "tokens=3 delims= " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%WEfile% ^| find /i "index"') do set ZS=%%a
for /f "skip=1 tokens=4 delims=:." %%G in ('%YCDM% /english /get-wiminfo /wimfile:%WEfile% /index:1 ^| find /i "Version"') do set OFFSYS=%%G
if "%OFFSYS%"=="" (
echo.
echo                可能是包含安装媒体的3+X映像   从第3个索引开始方为真正的系统映像
ping -n 2 127.1 >nul
for /f "skip=1 tokens=4 delims=:." %%G in ('%YCDM% /english /get-wiminfo /wimfile:%WEfile% /index:3 ^| find /i "Version"') do set OFFSYS=%%G
set SYSZ=3
)
if "%OFFSYS%"=="" (
echo.
echo                可能是包含安装媒体的4+X映像   从第4个索引开始方为真正的系统映像
ping -n 2 127.1 >nul
for /f "skip=1 tokens=4 delims=:." %%G in ('%YCDM% /english /get-wiminfo /wimfile:%WEfile% /index:4 ^| find /i "Version"') do set OFFSYS=%%G
set SYSZ=4
)
Set DmVer=%OFFSYS%
if %OFFSYS% GEQ 9651 set FSYS=Win10
if %OFFSYS% LSS 9601 set FSYS=Win81
if %OFFSYS% LSS 9201 set FSYS=Win8
if %OFFSYS% LEQ 7601 set FSYS=Win7
echo.
echo                如果存在%DmVer%ADK组件则优先使用 否则根据实际情况使用相应dism程序
echo.
ping -n 3 127.1 >nul
for /f "tokens=3 delims= " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%WEfile% /Index:%SYSZ% ^| find /i "Architecture"') do set Mbt=%%a
if %Obt% EQU %Mbt% (
if exist %ISO%\Sources\dism.exe SET YCDM=%ISO%\Sources\dism.exe
if %DmVer% LSS 9600 Goto :DMSY
if %TheOS% EQU Win7 Goto :DMSY
if %DmVer% gtr 17134 Goto :EXPO
if %DmVer% LEQ 17134 Goto :%DmVer%
) else (
if %Mbt% EQU x64 echo                映像为64位系统        程序将启用当前系统32位的ADK组件进行后续操作
if %Mbt% EQU x64 echo.
if %Mbt% EQU x86 echo                映像为32位系统  ^(如果存在^)程序将启用ISO或当前系统中dism继续进行
if %Mbt% EQU x86 echo.
ping -n 3 127.1>nul
if %DmVer% LSS 9600 Goto :DMSY
if %TheOS% EQU Win7 Goto :DMSY
if %Mbt% EQU x64 if %DmVer% leq 17134 Goto %DmVer%
if %Mbt% EQU x64 if %DmVer% gtr 17134 Goto 17134
if %Mbt% EQU x86 (
if exist %ISO%\Sources\dism.exe SET "YCDM=%ISO%\Sources\dism.exe"
Goto :EXPO
)
GOTO :%DmVer%
)
if %DmVer% LSS 9600 Goto :DMSY
if %TheOS% EQU Win7 Goto :DMSY

:DMSY
echo                在 %TheOS% 主系统下处理%FSYS%映像 程序默认启用9600ADK的DISM继续进行
echo.
ping -n 6 127.1 >nul
SET YCDM=%YCP%TOOL\9600\%Obt%\Dism\dism.exe
if not exist %YCP%TOOL\9600\%Obt%\Dism\dism.exe goto DMER
Goto :EXPO

:17134
echo                当前部署映像服务和管理工具%DmVer% %DmVer%以上将启用%DmVer%ADK继续进行
echo.
SET YCDM=%YCP%TOOL\17134\%Obt%\Dism\dism.exe
if not exist %YCP%TOOL\17134\%Obt%\Dism\dism.exe goto DMER
Goto :EXPO

:16299
echo                当前部署映像服务和管理工具%DmVer% %DmVer%以上将启用%DmVer%ADK继续进行
echo.
SET YCDM=%YCP%TOOL\%DmVer%\%Obt%\Dism\dism.exe
if not exist %YCP%TOOL\%DmVer%\%Obt%\Dism\dism.exe goto DMER
Goto :EXPO

:15063
echo                当前部署映像服务和管理工具%DmVer% %DmVer%以上将启用%DmVer%ADK继续进行
echo.
SET YCDM=%YCP%TOOL\%DmVer%\%Obt%\Dism\dism.exe
if not exist %YCP%TOOL\%DmVer%\%Obt%\Dism\dism.exe goto DMER
Goto :EXPO

:14393
echo                当前部署映像服务和管理工具%DmVer% %DmVer%以上将启用%DmVer%ADK继续进行
echo.
SET YCDM=%YCP%TOOL\%DmVer%\%Obt%\Dism\dism.exe
if not exist %YCP%TOOL\%DmVer%\%Obt%\Dism\dism.exe goto DMER
Goto :EXPO

:10586
echo                当前部署映像服务和管理工具%DmVer% %DmVer%以上将启用%DmVer%ADK继续进行
echo.
SET YCDM=%YCP%TOOL\%DmVer%\%Obt%\Dism\dism.exe
if not exist %YCP%TOOL\%DmVer%\%Obt%\Dism\dism.exe goto DMER
Goto :EXPO

:10240
echo                当前部署映像服务和管理工具%DmVer% %DmVer%以上将启用%DmVer%ADK继续进行
echo.
SET YCDM=%YCP%TOOL\%DmVer%\%Obt%\Dism\dism.exe
if not exist %YCP%TOOL\%DmVer%\%Obt%\Dism\dism.exe goto DMER
Goto :EXPO

:9600
echo                当前部署映像服务和管理工具%DmVer% %DmVer%以下将启用%DmVer%ADK继续进行
echo.
SET YCDM=%YCP%TOOL\%DmVer%\%Obt%\Dism\dism.exe
if not exist %YCP%TOOL\%DmVer%\%Obt%\Dism\dism.exe goto DMER

:EXPO
%YCDM% /cleanup-wim >nul
ping -n 1 127.1 >nul
set INDEX=1
if exist %YCP%YCSINS.WIM (
set SOUR=%YCP%
Goto :MENU
)
%YCDM% /Get-Wiminfo /WimFile:%WEfile% 2>nul
for /f "tokens=3 delims= " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%WEfile% ^| find /i "index"') do set ZS=%%a
SET /P INDEX=请输入要制作 %WEfile% 中的子映像索引数字共%ZS%个子映像 直接回车默认为%ZS%: 
echo %WEfile% |find ".esd" &&Set PDEW=E
if /i "%PDEW%"=="E" (
%YCDM% /Export-Image /SourceImageFile:%WEfile% /SourceIndex:%INDEX% /DestinationImageFile:%YCP%YCSINS.WIM /Compress:maximum /Checkintegrity
) ELSE (
%YCDM% /Export-Image /SourceImageFile:%WEfile% /SourceIndex:%INDEX% /DestinationImageFile:%YCP%YCSINS.WIM
)
if %errorlevel% EQU 87 %YCDM% /Export-Image /SourceImageFile:%WEfile% /SourceIndex:%INDEX% /DestinationImageFile:%YCP%YCSINS.WIM /Compress:maximum /Checkintegrity
cls
if not exist YCSINS.WIM Goto :EXPO

:MENU
cls
SET MOU=%YCP%YCMOU
Reg unload HKLM\0 >nul 2>nul
SET DEREG=Reg load HKLM\0 "%MOU%\Windows\System32\config\DEFAULT"
SET USREG=Reg load HKLM\0 "%MOU%\Users\Default\NTUSER.DAT"
if exist "%MOU%\Users\Administrator\NTUSER.DAT" SET USREG=Reg load HKLM\0 "%MOU%\Users\Administrator\NTUSER.DAT"
SET SSREG=Reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE"
SET SYREG=Reg load HKLM\0 "%MOU%\Windows\System32\config\SYSTEM"
SET UNREG=Reg unload HKLM\0
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 set GMOS=准备工作就绪 请装载映像
echo.
echo         %title%
echo.
echo      今天日期^:%date%
echo      当前系统^:%OOS% %Obt% %OUI% %OSV% %ORS%（%OMD%^.%OZD%）
set dqwz=  您好^！YCDISM2018㊣在进行...
set dqwc=  您好^！YCDISM2018已经完成
set dqcd=  主菜单序号^:
if exist %ISO%\Sources\dism.exe (set SOUR=%ISO%\Sources\) else (set SOUR=%YCP%)
if exist %MOU%\Windows\system32\config (Goto YM) ELSE (Goto NM)

:YM
if exist INDEXset.cmd Call INDEXset.cmd
for /f "tokens=3 delims= " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM ^| find /i "index"') do set ZS=%%a
%SSREG% >nul
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild"') do set MMD=%%a
set MMD=%MMD:~30%
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "BuildLabEx"') do set MUBR=%%a
SET MRS=%MUBR:~-11,4%
for /f "tokens=5 delims=._" %%a in ('echo %MUBR%') do (set MSV=%%a)
for /f "delims=" %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM /Index:%INDEX% ^| find /i "ServicePack Build"') do set MZD=%%a
set MZD=%MZD:~20%
reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "UBR" >nul 2>nul
if %errorlevel% NEQ 0 GOTO :MKAISHI
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "UBR"') do set MBDH=%%a
set MBDH=%MBDH:~26%
set /a MBDH=0x%MBDH%
set MZD=%MBDH%
CALL :GetNow

:MKAISHI
%UNREG% >nul
for /f "tokens=3 delims= " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM /Index:%INDEX% ^| find /i "Architecture"') do set Mbt=%%a
for /f "tokens=1 delims=	 " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM /Index:%INDEX% ^| find /i "Default"') do set MUI=%%a
echo %MEID% |find /i "Server">nul && Set SSYS=%OFFSYS%S
echo %MEID% |find /i "Server">nul || Set SSYS=%OFFSYS%
echo      当前装载^:%MOS% %Mbt% %MUI% %MSV% %MRS%（%MMD%^.%MZD%）
Goto MMMM

:NM
echo                                                                   %GMOS%
:MMMM
ECHO     ┏**********************************************************************************┓
ECHO     ┣***    雨  晨  绿  软   ***  YCDISM 终结版 2018-05-01 ***    纯  净  安  全    ***┫
ECHO     ┣**********************************************************************************┫
ECHO     ┃    常规按需顺序操作部分   ┋                        ┋   非常规按需自选操作部分  ┋
ECHO     ┣***************************┋** YCDISM程序组合简述 **┋***************************┫
ECHO     ┃ 1 ┋ 2 →集成补丁或功能包 ┋                        ┋ 整合绿色软件程序← 26┋ 0 ┃
ECHO     ┃***┋ 3 →卸载内置APPS应用 ┣************************┫ 添加本地中文语言← 27┋   ┃
ECHO     ┃   ┋ 4 →移除部分可选功能 ┋    YCDISM是雨晨基于DISM┋ 驱动虚链极限精简← 28┋ 保┃
ECHO     ┃装 ┋ 5 →Win7系统集成IE11 ┋                        ┋ WinSxS  极限精简← 29┋   ┃
ECHO     ┃   ┋ 6 →映像清理固化更新 ┋及相关批处理程序组合的纵┋ N版添加 WMPlayer← 30┋ 持┃
ECHO     ┃载 ┋ 7 →启用或者禁用功能 ┋                        ┋ 提升装载映像版本← 31┋   ┃
ECHO     ┃   ┋ 8 →手动集成安装密钥 ┋向及横向强大的延伸扩展。┋ Win10 九版本转换← 32┋ 现┃
ECHO     ┃即 ┋ 9 →自动集成系统密钥 ┋                        ┋ 关闭系统虚拟内存← 33┋   ┃
ECHO     ┃   ┋10 →移除系统还原映像 ┋菜单直观、互动界面通俗易┋ 添加Office绿色版← 34┋ 状┃
ECHO     ┃将 ┋11 →移除杀毒 WD 数据 ┋                        ┋ 管理员批准的模式← 35┋   ┃
ECHO     ┃   ┋12 →移除OneDrive数据 ┋用、程序智能、通用、实用┋ 去掉预览版的水印← 36┋ 安┃
ECHO     ┃制 ┋13 →卸载内置Edge数据 ┋                        ┋ 添加联网 KMS程序← 37┋   ┃
ECHO     ┃   ┋14 →卸载 Cortan 数据 ┋功能全面，简单互动即可实┋ 加入自己软件合集← 38┋ 全┃
ECHO     ┃作 ┋15 →移除 Speech 数据 ┋                        ┋ 查看装载系统封包← 39┋   ┃
ECHO     ┃   ┋16 →安全精简Font字体 ┋现精简、增强、优化固化、┋ 自选强制删除封包← 40┋ 退┃
ECHO     ┃的 ┋17 →精简Assembly数据 ┋                        ┋ 获取通用汉化数据← 41┋   ┃
ECHO     ┃   ┋18 →移除部分强制应用 ┋设置固化的纯净系统、所见┋ 汉化装载中的映像← 42┋ 出┃
ECHO     ┃WIM┋19 →移除RS2+拼音辅助 ┋                        ┋ 提取系统分区驱动← 43┋   ┃
ECHO     ┃   ┋20 →整合或者安装驱动 ┋所得、安全、绿色、稳定并┋ 卸载非内置的驱动← 44┋ 程┃
ECHO     ┃映 ┋21 →整合VC FLASH程序 ┋                        ┋ 自选卸载部分功能← 45┋   ┃
ECHO     ┃   ┋22 →更换主题锁屏图片 ┋可靠、支持NT6至NT10系统 ┋ 保存已改变的映像← 46┋ 序┃
ECHO     ┃像 ┋23 →通用安全适度精简 ┋                        ┋ 增量保存装载映像← 47┋   ┃
ECHO     ┃   ┋24 →设置优化无人值守 ┋做系统，就这么简单！！！┋ 自选卸载装载映像← 48┣***┫
ECHO     ┃ 1 ┋25 →修改默认无人值守 ┋                        ┋ 重命名或输出映像← 49┋ 0 ┃
ECHO     ┣**********************************************************************************┫
ECHO     ┃                     YCDISM批处理程序编写及数据收集整合-雨晨  QQ交流群：623436366 ┃
ECHO     ┗**********************************************************************************┛
ECHO.
Set m=N
Set /p m=请输入你要操作的菜单序号数字(0-49) 按回车执行操作:
cls
If "%m%"=="1"  Goto GZYX
If "%m%"=="2"  Goto JCBD
If "%m%"=="3"  Goto XZYY
If "%m%"=="4"  Goto MCAN
If "%m%"=="5"  Goto JCIE
If "%m%"=="6"  Goto CLEA
If "%m%"=="7"  Goto NETF
If "%m%"=="8"  Goto SDMY
If "%m%"=="9"  Goto JKEY
If "%m%"=="10" Goto KWNR
If "%m%"=="11" Goto KLWD
If "%m%"=="12" Goto KONE
If "%m%"=="13" Goto KBRO
If "%m%"=="14" Goto KCTA
If "%m%"=="15" Goto KSPH
If "%m%"=="16" Goto PEFT
If "%m%"=="17" Goto KABY
If "%m%"=="18" Goto KSAP
If "%m%"=="19" Goto SCPY
If "%m%"=="20" Goto YCQD
If "%m%"=="21" Goto ADVC
If "%m%"=="22" Goto MWEB
If "%m%"=="23" Goto SDJJ
If "%m%"=="24" Goto WRZS
If "%m%"=="25" Goto BJYD
If "%m%"=="26" Goto SOFT
If "%m%"=="27" Goto ULAN
If "%m%"=="28" Goto ZDJJ
If "%m%"=="29" Goto LITE
If "%m%"=="30" Goto NWMP
If "%m%"=="31" Goto SJBB
If "%m%"=="32" Goto BBZH
If "%m%"=="33" Goto NOPG
If "%m%"=="34" Goto OFFC
If "%m%"=="35" Goto ADMI
If "%m%"=="36" Goto QDSY
If "%m%"=="37" Goto YKMS
If "%m%"=="38" Goto ADTG
If "%m%"=="39" Goto GTPL
If "%m%"=="40" Goto KPKB
If "%m%"=="41" Goto GTZN
If "%m%"=="42" Goto ADZN
If "%m%"=="43" Goto GTQD
If "%m%"=="44" Goto YJYX
If "%m%"=="45" Goto YCYY
If "%m%"=="46" Goto SAVE
If "%m%"=="47" Goto ZLBC
If "%m%"=="48" Goto UNMO
If "%m%"=="49" Goto SHCH
If "%m%"=="0"  Goto TUIC
echo.
echo    你的输入有误 程序并未提供该项操作及相关的序号 请重新输入程序所提供的菜单序号！！！
echo.
ping -n 3 127.1 >nul
cls
Goto MENU

:GZYX
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\System32\config\SOFTWARE (
echo.
echo   已经装载映像 请不要重复装载 如果已经装载的映像损坏请先执行废除操作
echo.
ping -n 3 127.1>nul
cls
Goto MENU
)
title  %dqwz% 装载%YCP%YCSINS.WIM映像 %dqcd%1
echo.
echo   %dqwz% 装载%YCP%YCSINS.WIM映像 %dqcd%1
echo.
%YCDM% /Get-Wiminfo /WimFile:%YCP%YCSINS.WIM
for /f "tokens=3 delims= " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM ^| find /i "index"') do set ZS=%%a
set INDEX=1
set /p INDEX=请输入%YCP%YCSINS.WIM中要操作的索引序号共%ZS%个子映像 直接回车默认为1:
%YCDM% /Mount-Image /ImageFile:%YCP%YCSINS.WIM /Index:%INDEX% /MountDir:%MOU% 2>nul
if %errorlevel% EQU 11 (
cls
echo.
echo      温馨提醒：
echo.
echo          当前即将装载的映像其真实格式为ESD格式    需转换成WIM格式继续  
echo.
echo          如果无加密或错误 程序将尝试转换成标准的WIM映像以继续执行操作
echo.
echo          开始转换 不可中断或影响转换过程，可能需要一些时间 请稍候！！！
echo.
ren %YCP%YCSINS.WIM YCSINS.ESD
%YCDM% /export-image /sourceimagefile:%YCP%YCSINS.ESD /sourceindex:%INDEX% /destinationimagefile:%YCP%YCSINS.WIM /Compress:maximum /Checkintegrity
if %errorlevel% EQU 0 del %YCP%YCSINS.ESD
ping -n 1 127.1 >nul
cls
RMDIR /Q /S "%YCP%YCMOU"
Goto GZYX
)
if %errorlevel% NEQ 0 (
echo.
echo    %YCP%YCSINS.WIM 中不存在您输入的索引 %INDEX% 请输入存在的的索引序号 
echo.
ping -n 6 127.1 >nul
cls
Goto MENU
)
echo @echo off>%YCP%废弃装载中的映像.cmd
echo color 1f>>%YCP%废弃装载中的映像.cmd
echo %YCDM% /Unmount-Image /MountDir:%YCP%YCMOU /DISCARD>>%YCP%废弃装载中的映像.cmd
echo @echo off>%YCP%异常中断后重新启用已装载映像.cmd
echo color 1f>>%YCP%异常中断后重新启用已装载映像.cmd
echo %YCDM% /Remount-wim /MountDIR:%YCP%YCMOU>>%YCP%异常中断后重新启用已装载映像.cmd
for /f "tokens=3 delims= " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM ^| find /i "index"') do set ZS=%%a
if not exist %MOU%\Windows\System32\config %YCDM% /Mount-Image /ImageFile:%YCP%YCSINS.WIM /Index:%INDEX% /MountDir:%MOU%
echo set INDEX=!INDEX!>INDEXset.cmd
for /f "delims=" %%i in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM /Index:%INDEX% ^| find /i "ServicePack Build"') do set MZD=%%i
set MZD=%MZD:~20%
%SSREG% >nul
CALL :GetNow
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild"') do set MMD=%%a
set MMD=%MMD:~30%
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "BuildLabEx"') do set MUBR=%%a
SET MRS=%MUBR:~-11,4%
for /f "tokens=5 delims=._" %%a in ('echo %MUBR%') do set MSV=%%a
%UNREG% >nul
for /f "tokens=3 delims= " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM /Index:%INDEX% ^| find /i "Architecture"') do set Mbt=%%a
for /f "tokens=1 delims=	 " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM /Index:%INDEX% ^| find /i "Default"') do set MUI=%%a
echo %MEID% |find /i "Server">nul && Set SSYS=%OFFSYS%S
echo %MEID% |find /i "Server">nul || Set SSYS=%OFFSYS%
title  %dqwc% 装载%YCP%YCSINS.WIM映像%INDEX% %dqcd%1
echo.
echo               %MOS% 映像装载完成程序3秒后自动进入下一步操作
echo.
ping -n 3 127.1 >nul
cls
goto MENU

:JCBD
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% 集成MSU更新或CAB功能 %dqcd%2
echo.
echo   %dqwz% 集成MSU更新或CAB功能 %dqcd%2
echo.
echo   如现有补丁数据存在更新  请及时从MS官网获取相应更新保证作品最新并同步
echo.
echo   请确认%YCP%MSU\%SSYS%\%FSYS%%Mbt%MSU中补丁数据正确无误回车执行操作
echo.
if %OFFSYS% equ 7600 (
echo   当前挂载系统为Win7 请将%YCP%MSU中的%SSYS%目录改名为7600 另需SP1补丁
echo.
)
set qr=
set /p qr= 确认集成补丁直接回车 不做操作返回请按N回车 打开MS官网请按G回车
if /i "%qr%"=="N" goto MENU
if /i "%qr%"=="G" Start http://catalog.update.microsoft.com/v7/site/home.aspx &&goto MENU
echo.
echo   开始尝试集成%YCP%MSU\%FSYS%\%SSYS%的补丁...
if exist %YCP%MSU\%SSYS%\%FSYS%%Mbt%MSU %YCDM% /image:%MOU% /add-package /packagepath:%YCP%MSU\%SSYS%\%FSYS%%Mbt%MSU
title  %dqwc% 集成MSU更新或CAB功能 %dqcd%2
echo.
echo   如果无误%YCP%MSU\%SSYS%中%FSYS%的MSU或CAB已完成集成 程序6秒后自动返回主菜单
echo.
ping -n 6 127.1>nul
cls
goto MENU

:XZYY
if not exist "%MOU%\Program Files\WindowsApps"  GOTO MENU
title  %dqwz% 卸载自带应用 %dqcd%3
echo.
echo   %dqwz% 卸载自带应用 %dqcd%3
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo @echo off>%YCP%unapp.cmd
echo Color 1f>>%YCP%unapp.cmd
:XZFA
echo.
echo           如果存在可卸载自带应用  雨晨DISM程序默认推荐以下自带应用经典卸载方案
echo  ======================================================================================
echo                     卸载过程中如出现系统找不到指定的文件表示已经卸载
echo    ┏┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┓
echo    ┋              目 前 程 序 可 卸 载 已 知 自 带 应 用 方 案 规 则              ┋
echo    ┣┅┅┅┅┅┅┅┅┅┳┅┅┅┅┅┅┅┅┅┳┅┅┅┅┅┅┅┅┅┳┅┅┅┅┅┅┅┅┅┫
echo    ┋  A 默 认 卸 载   ┋  B 保 留 方 案   ┋  C 保 留 方 案   ┋  D 保 留 方 案   ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋HelpAndTips       ┋Reader            ┋WindowsScan       ┋XboxApp           ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋Getstarted        ┋ZuneVideo         ┋3DBuilder         ┋BingFinance       ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋MicrosoftOfficeHub┋ZuneMusic         ┋DesktopAppInstalle┋BingSports        ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋People            ┋Photos            ┋OneConnect        ┋BingWeather       ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋FeedbackHub       ┋SkypeApp          ┋OneNote           ┋BingNews          ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋Office Sway       ┋Camera            ┋SolitaireCollectio┋communicationsapps┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋GetHelp           ┋WindowsCalculator ┋StickyNotes       ┋WindowsMaps       ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋  E 保 留 方 案   ┋Microsoft3DViewer ┋Wallet            ┋XboxGameOverlay   ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋WindowsStore      ┋WindowsPhone      ┋Messaging         ┋StorePurchaseApp  ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋WindowsAlarms     ┋SoundRecorder     ┋Appconnector      ┋XboxLIVEGames     ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋                  ┋MSPaint           ┋Microsoft Print3D ┋Xbox TCUI         ┋
echo    ┣┅┅┅┅┅┅┅┅┅┻┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋若想完美使用APP 请使用新建标准账户登录┋CommsPhone        ┋ConnectivityStore ┋
echo    ┣┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┻┅┅┅┅┅┅┅┅┅┫
echo    ┋              F 全 部 卸 载           ┋           G 自 定 义 卸 载           ┋
echo    ┗┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┻┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┛
echo         温馨提醒： 本操作不适用于二次封装和已被破坏或已被强删过的非微软映像副本
echo  ======================================================================================      
set XZFA=
set /p XZFA=请选择并输入你要执行的方案字母不分大小写 ABCDEFG 按0回车不做任何操作并返回主菜单：
if "%XZFA%"=="0" goto XZFAO
if /i "%XZFA%"=="A" goto XZFAE
if /i "%XZFA%"=="B" goto XZFAE
if /i "%XZFA%"=="C" goto XZFAE
if /i "%XZFA%"=="D" goto XZFAE
if /i "%XZFA%"=="E" goto XZFAE
if /i "%XZFA%"=="F" goto XZFAE
if /i "%XZFA%"=="G" goto XZFAG
echo.
echo   输入有误  请重新输入
echo.
ping -n 3 127.1>nul
cls
goto XZFA

:XZFAE
dir /b /a "%MOU%\Program Files\WindowsApps">%YCP%tmp.txt
findstr "_~_" %YCP%tmp.txt>%YCP%Applist.txt
del /q /f %YCP%tmp.txt
echo.
echo  %XZFA%方案自带应用卸载操作...
echo.
if /i %XZFA% EQU F (
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "_~_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
GOTO :QBXZ
)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".Getstarted_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".MicrosoftOfficeHub_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".Office.Sway_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".People_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".WindowsFeedbackHub_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".HelpAndTips_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".BingHealthAndFitness_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".BingFoodAndDrink_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".BingFinance_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".BingTravel_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".GetHelp_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
if /i %XZFA% EQU A (
echo.
echo   %XZFA% 方案自带应用卸载操作完成
echo.
ping -n 3 127.1>nul
cls
goto XZFAO
)
if /i %XZFA% NEQ B (
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "ZuneVideo" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".Microsoft3DViewer_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "ZuneMusic" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "Photos" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".SkypeApp_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "Camera" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".WindowsCalculator_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "WindowsPhone" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "SoundRecorder" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "Microsoft.WindowsScan_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".WindowsReadingList_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".WindowsScan_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".Reader_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".MSPaint_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
)
if /i %XZFA% NEQ C (
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".Wallet_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "3DBuilder" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "DesktopApp" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "OneConnect" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "Solitaire" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "Note" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "Messaging" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "Appconnector" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".CommsPhone" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".Print3D_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
)
if /i %XZFA% NEQ D (
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "Xbox" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "communicationsapps_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "WindowsMaps" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "Bing" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
)
:QBXZ
title  %dqwc% %XZFA% 方案卸载自带应用 %dqcd%3
echo.
echo  %XZFA% 方案自带应用卸载操作完成           程序3秒后返回主菜单
echo.
ping -n 3 127.1>nul
goto XZFAO

:XZFAG
dir /b /a "%MOU%\Program Files\WindowsApps">%YCP%tmp.txt
findstr "_~_" %YCP%tmp.txt>%YCP%Applist.txt
del /q /f %YCP%tmp.txt
echo.
echo  开始执行 %XZFA% 方案自带应用卸载操作...
echo.
echo   请将打开的Applist.TXT每行前的 Microsoft.按 CTRL+H 键替换为改为%%un%%保存
echo.
echo   如果想保留一些应用 请将其所在的一整行从记事本中删除并保存并关闭记事本即可
echo.
start %YCP%Applist.txt
set hhcd=1
set /p hhcd= 确认按要求准备就绪直接回车执行卸载  按0回车不做任何操作并返回主菜单:
if "%hhcd%"=="0" goto XZFAO
set un=%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:Microsoft.
Type %YCP%applist.txt>>%YCP%unapp.cmd
ping -n 1 127.1>nul
call %YCP%unapp.cmd
title  %dqwc% %XZFA% 方案卸载自带应用 %dqcd%3
echo.
echo        自定义自带应用卸载操作完成           程序3秒后返回主菜单
echo.
ping -n 3 127.1>nul
:XZFAO
del /q /f %YCP%applist.txt
del /q /f %YCP%unapp.cmd
cls
goto MENU

:MCAN
title  %dqwz% 部分可以卸载数据 %dqcd%4
echo.
echo   %dqwz% 部分可以卸载数据 %dqcd%4
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if %FSYS% NEQ Win10 (
echo.
echo          本功能只限定在 Windows 10 系统下使用 程序返回主菜单
echo.
ping -n 6 127.1 >nul
cls
goto MENU
)
echo.
echo   默认移除：远程控制 内测会员 零售演示 预览推送 开发模式 媒体播放器 快速帮助 
echo   ============================================================================
%YCDM% /Image:%MOU% /English /Get-packages >%YCP%packages.txt
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "OpenSSH-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-Hello-Face-Resource-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-InsiderHub-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-RetailDemo-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-Prerelease-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-DeveloperMode-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-ContactSupport-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-QuickAssist-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "MediaPlay" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
:: 以下::依次为 光学识别 手写 中文补充字体 如需移除请去掉行首双冒号
::for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-OCR-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
::for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-Handwriting-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
::for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-Fonts-Hans-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
echo.
echo   如果是多语言系统或添加了中文语言包将删除非 ZH-CN 语言数据 开始处理...请稍候
echo.
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "LanguageFeatures-Basic-" &&echo %%a >>%YCP%Languagelist.txt)
for /f %%i in (%YCP%Languagelist.txt) do echo %%i |findstr /i "en-US zh-CN" || %YCDM% /image:%MOU% /Remove-Package /PackageName:%%i
del /f /q %YCP%packages.txt
del /f /q %YCP%Languagelist.txt
title  %dqwc% 卸载部分可以卸载数据 %dqcd%4
echo.
echo   ============================================================================
echo   只要不进行组件精简   这些删除的功能均可在可选功能按需要随时添加   请放心使用
echo.
if %OFFSYS% GEQ 15063 (
echo   移除RS2以上系统一些并不常用的功能如需请注释掉操作可能需要较长时间  请稍候...
echo.
%YCP%TOOL\Tweak.exe /p "%MOU%" /c Microsoft-OneCore-Gaming /r >nul 2>nul
echo   如果存在 游戏相关已经移除 开始移除全息相关功能数据...
echo.
%YCP%TOOL\Tweak.exe /p "%MOU%" /c Microsoft-Windows-Holographic-Desktop /r >nul 2>nul
echo   如果存在 全息相关已经移除 开始移除帮助相关功能数据...
echo.
%YCP%TOOL\Tweak.exe /p "%MOU%" /c Microsoft-Windows-Help /r >nul 2>nul
echo   如果存在 帮助相关已经移除 开始移除MRT相关功能数据...
echo.
%YCP%TOOL\Tweak.exe /p "%MOU%" /c Microsoft-Windows-MRT10-Package /r >nul 2>nul
echo   如果存在 MRT相关已经移除 开始移除Skype相关功能数据...
echo.
%YCP%TOOL\Tweak.exe /p "%MOU%" /c Microsoft-Windows-Skype /r >nul 2>nul
)
echo   程序默认移除的相关功能数据已经操作完成 程序返回
echo.
ping -n 3 127.1>nul
cls
goto MENU

:NETF
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% 启用或禁用功能 %dqcd%7
echo.
echo   %dqwz% 启用或禁用功能 %dqcd%7
echo.
echo                         雨晨DISM 默认的通用禁用、启用功能详细列表
echo  ======================================================================================
echo   通常为原始系统默认状态相反的状态 但又是安装完需要禁用或开启的一系列功能 下表仅供参考
echo    ┏┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┳┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┓
echo    ┋            默认禁用功能列表          ┋            默认启用功能列表          ┋
echo    ┣┅┅┅┅┅┅┅┅┅┳┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┳┅┅┅┅┅┅┅┅┅┫
echo    ┋ 1  所有游戏功能  ┋Windows7(SP1) Only┋ 1  Net3.5 功能   ┋     NetFx3.5     ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋ 2  传统组件功能  ┋ LegacyComponents ┋ 2  Net4.5+ ASP+  ┋   ASPNetFx4.5+   ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋ 3  Smb直通防勒索 ┋    SmbDirect     ┋ 3  打印扫描功能  ┋ScanManagementCon.┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋ 4  媒体播放器    ┋    MediaPlayer   ┋ 4  旧版组件功能  ┋    DirectPlay    ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋ 5  Power  Shell  ┋    PowerShell    ┋ 5  目录服务功能  ┋ DirectoryServices┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋ 6  自带杀毒功能  ┋ Windows Defender ┋ 6  打印扫描功能  ┋ScanManagementCon.┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋ 7  PDF 打印功能  ┋PrintToPDFServices┋ 7 远程登录客户端 ┋   TelnetClient   ┋
echo    ┗┅┅┅┅┅┅┅┅┅┻┅┅┅┅┅┅┅┅┅┻┅┅┅┅┅┅┅┅┅┻┅┅┅┅┅┅┅┅┅┛
echo   如需自定义操作 请直接复制打开的功能列表 复制 英文功能名称 粘贴 到本程序窗口 回车即可
echo  ======================================================================================
echo         要自定义禁用按1  自定义启用按2 如果功能名称包含有空格请在前后加上双引号        
echo.
:CXGN
set zd=3
set /p zd=请选择如何操作 直接回车将按默认方案进行启用和禁用 按0 回车不做任何操作返回主菜单:
If "%zd%"=="0" Goto MENU
If "%zd%"=="1" Goto JYGN
If "%zd%"=="2" Goto QYGN
If "%zd%"=="3" Goto TYFA
echo.
echo   输入有误  请重新输入
echo.
ping -n 2 127.1>nul
cls
set zd=
goto CXGN

:TYFA
title  正在按通用默认方案进行禁用和启用...请稍候
echo.
echo   正在按通用默认方案进行禁用和启用...请稍候
echo.
%YCDM% /Image:%MOU% /english /Get-Features>%YCP%Features.txt
if %OFFSYS% LEQ 7601 (
echo.
echo   为Win7系统移除随时更新、游戏和便笺 可能需要一些时间请稍候...
%YCP%TOOL\Tweak.exe /p "%MOU%" /c Windows-StickyNotes /r >nul 2>nul
%YCP%TOOL\Tweak.exe /p "%MOU%" /c Windows-Anytime /r >nul 2>nul
for /f "tokens=4,5 delims= " %%a in (%YCP%Features.txt) do (echo "%%a %%b"|find /i "More Games" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:"%%a %%b")
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "InboxGames" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "Hearts" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "FreeCell" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "Minesweeper" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "PurblePlace" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "SpiderSolitaire" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "Chess" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4,5 delims= " %%a in (%YCP%Features.txt) do (echo "%%a %%b"|find /i "Internet Games" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:"%%a %%b")
for /f "tokens=4,5 delims= " %%a in (%YCP%Features.txt) do (echo "%%a %%b"|find /i "Internet Checkers" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:"%%a %%b")
for /f "tokens=4,5 delims= " %%a in (%YCP%Features.txt) do (echo "%%a %%b"|find /i "Internet Backgammon" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:"%%a %%b")
for /f "tokens=4,5 delims= " %%a in (%YCP%Features.txt) do (echo "%%a %%b"|find /i "Internet Spades" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:"%%a %%b")
)
title  正在在行默认的功能禁用...
echo.
echo   以下功能默认禁用
echo.
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "WindowsPowerShell" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "Printing-PrintToPDFServices-" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "MediaCenter" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "MediaPlay" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "SmbDirect" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
title  正在在行默认的功能启用...
echo.
echo   以下功能默认启用
echo.
if exist "%SXS%" for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "NetFx3" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a /source:%SXS% /All /LimitAccess)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "NetFx4" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a /all)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "DirectoryServices" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a /all)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "DirectPlay" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a /all)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "ScanManagementConsole" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "Telnet" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a)
if %OFFSYS% LSS 10240 GOTO :TGMY
set jyie=N
if exist "%MOU%\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" set /p jyie=不禁用Internet Explorer直接回车     禁用按 Y 回车：
if %jyie% equ Y for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "Internet-Explorer-" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
:TGMY
title  %dqwc% 通用启用和禁用功能 %dqcd%7
echo.
echo   通用启用和禁用功能完成 3秒后返回主菜单并由您选择下一步操作
echo.
ping -n 5 127.1 >nul
cls
del /q %YCP%Features.txt
goto MENU

:JYGN
echo.
echo   开始查询装载映像中的功能... 
echo.
%YCDM% /Image:%MOU% /Get-Features>%YCP%Features.txt
ping -n 1 127.1>nul
start %YCP%Features.txt
:JYJY
echo.
echo   请复制Features文本中启用状态的功能名称冒号后的英文粘贴到本程序窗口按Enter键
echo.
echo   如果您不熟悉相关功能禁用后的影响请不要随意禁用     以免给您带去不必要的麻烦
echo.
set jy=
set /p jy=请将要禁用功能的英文名称粘贴到程序窗口中回车开始执行 按0回车 返回主菜单:
if "%jy%"=="0" del %YCP%Features.txt &&goto MENU
%YCDM% /image:%MOU% /Disable-Feature /Featurename:"%jy%" ||%YCDM% /image:%MOU% /Disable-Feature /Featurename:"%jy%" /all
echo.
echo   执行完毕 继续操作...
echo.
ping -n 1 127.1 >nul
cls
goto JYJY

:QYGN
echo.
echo   开始查询装载映像中的功能... 完成后自动打开功能列表
echo.
%YCDM% /Image:%MOU% /Get-Features>%YCP%Features.txt
ping -n 1 127.1>nul
start %YCP%Features.txt
:QYQY
echo.
echo   请复制Features文本中禁用状态的功能名称冒号后的英文粘贴到本程序窗口按Enter键
echo.
set qy=
set /p qy=请将要启用功能的英文名称粘贴到程序窗口中 回车开始执行 按0回车 返回主菜单:
if "%qy%"=="0" del %YCP%Features.txt &&goto MENU
if /i "%qy%"=="NetFx3" (set gn=%qy% /all /source:%SXS% /LimitAccess) else (set gn=%qy% /all /LimitAccess)
%YCDM% /image:%MOU% /Enable-feature /Featurename:%gn% 2>nul
echo.
echo  执行完毕 继续操作...
echo.
ping -n 1 127.1 >nul
cls
goto QYQY

:ULAN
title  %dqwz% 集成语言包 汉化系统必须执行 %dqcd%27
echo.
echo   %dqwz% 集成语言包 汉化系统必须执行 %dqcd%27
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   为挂载中的映像集成语言包后可将映像国际设置设置默认成相应语言界面
echo.
echo   请将名称为%SSYS%%Mbt%LP.cab放到%YCP%PCAB目录 如果没有将视为汉化操作
echo.
echo   直接回车本程序默认为设置成中文  如果不是请在下面直接输入其它语言
echo.
set ul=ZH-CN
set /p ul=输入你想将映像中存在并能设置成默认的区域名称比如中文则输入 ZH-CN 回车即可:
if exist %YCP%PCAB\%SSYS%%Mbt%BP.cab (
echo.
echo   发现%SSYS%%Mbt%BP.cab基础语言包数据如果适用程序开始尝试添加...
echo.
%YCDM% /image:%MOU% /add-package /packagepath:%YCP%PCAB\%SSYS%%Mbt%BP.cab
)
if not exist %YCP%PCAB\%SSYS%%Mbt%LP.cab goto ULST
echo.
echo   发现指定目录存在数据如果适用程序开始尝试添加...
echo.
%YCDM% /image:%MOU% /add-package /packagepath:%YCP%PCAB\%SSYS%%Mbt%LP.cab
if !errorlevel!==0 (
echo.
echo   %SSYS%%Mbt%LP.cab 添加成功  程序继续
echo.
ping -n 2 127.1>nul
cls
goto ULST
) ELSE (
echo.
echo   指定位置语言包不适用或损坏 程序继续进行默认区域设置
echo.
ping -n 5 127.1>nul
cls
goto ULST
)

:ULST
echo.
echo   获取装载映像中配置语言并设置为:%ul% 开始获取并进行设置请稍候...
echo.
%YCDM% /image:%MOU% /Get-Intl
if !errorlevel!==0 %YCDM% /image:%MOU% /Set-UILang:%ul%
%YCDM% /image:%MOU% /Set-Syslocale:%ul%
%YCDM% /image:%MOU% /Set-Userlocale:%ul%
%YCDM% /image:%MOU% /Set-SKUIntlDefaults:%ul%
if /i "%ul%"=="ZH-CN" %YCDM% /image:%MOU% /Set-Inputlocale:0804:00000804
if /i "%ul%"=="ZH-CN" %YCDM% /image:%MOU% /Set-TimeZone:"China Standard Time"
%YCDM% /image:%MOU% /Set-allIntl:%ul%
for /f "tokens=3 delims=: " %%b in ('%YCDM% /english /image:%MOU% /Get-Intl ^| find /i "System locale"') do set MUI=%%b
title  %dqwc% 集成语言包
echo.
echo   目前只提供完整简体中文操作 其它语言请修改相应内容 程序返回主菜单
echo.
ping -n 5 127.1>nul
cls
GOTO MENU

:JCIE
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if %OFFSYS% GTR 7601 GOTO IEER
title  %dqwz% Win7(sp1)专用 自定义集成IE11 %dqcd%5
echo.
echo   %dqwz% Win7(sp1)专用 自定义集成IE11 %dqcd%5
echo.
echo   注意此操作需要雨晨YCDISM提供标准配套或相同规范数据支持
echo.
set i=Y
set /p i=确认集成IE11直接回车 或按N回车不做任何操作返回主菜单:
if /i %i% NEQ Y GOTO :MENU
title  %dqwz% 映像集成IE11...请稍候
echo.
echo   开始为映像集成IE11...请稍候
echo.
echo   第1阶段       添加集成 IE11 必须补丁
if exist %YCP%IE\IEJB\%Mbt%\* %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IEJB\%Mbt%
echo.
echo   第2阶段       集成更新 IE11 核心数据
if exist %YCP%IE\IE11%Mbt%\*  %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IE11%Mbt%
echo.
echo   第3阶段       添加集成 IE11 修复补丁
if exist %YCP%IE\IE11%Mbt%\*.MSU  %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IE11%Mbt%H
title  %dqwc% 为装载映像集成IE11
echo.
echo   如果数据无误 IE11 已经成功集成到映像 程序返回主菜单
echo.
ping -n 5 127.1>nul
cls
goto MENU

:JKEY
title  %dqwz% 集成 %MOS% 安装密钥 %dqcd%9
echo.
echo   %dqwz% 集成 %MOS% 安装密钥 %dqcd%9
echo.
echo   程序只提供部分常用Win81和Win10提供安装密钥 安装时可跳过输入KEY
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if %OFFSYS% LSS 10240 (
echo.
echo   Windows 8.1 以下系统无需集成安装密钥 程序返回主菜单继续执行其它操作
echo.
ping -n 3 127.1 >nul
GOTO MENU
)
set KEY=
if /i "%MEID%"=="Pro" (CALL :setProfessional) else (CALL :set%MEID%)
echo.
echo   开始安装 %MOS% 默认密钥
echo.
%YCDM% /Image:%MOU% /Set-ProductKey:%KEY%
echo.
echo             %MOS% 密钥安装完成
echo.
ping -n 5 127.1 >nul
cls
GOTO MENU

echo.
echo      程序当前没有为挂载中的系统提供安装密钥 自动转到手动添加安装密钥
echo. 
ping -n 3 127.1 >nul
cls

:SDMY
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
%SSREG% >nul
CALL :GetNow
%UNREG% >nul
for /f "tokens=3 delims= " %%a in ('reg QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "BackupProductKeyDefault"') do set KEY=%%a
title   %dqwz% 手动输入密钥 %dqcd%8
echo.
echo    %dqwz% 自备安装密钥 %dqcd%8
echo.
echo    为 %MOS% 手动输入安装密钥 不集成请按N回车返回主菜单
echo.
echo    如果装载系统和当前系统版本相同且仍使用当前系统的安装密钥 按回车即可
echo.
echo    当前 %OOS% 的安装密钥为 %KEY%
echo.
set /p KEY=请正确输入一组您的安装密钥 包括中间的短划线回车执行操作:
if /i "%key%"=="N" GOTO MENU
%YCDM% /Image:%MOU% /Set-ProductKey:%KEY%
if %errorlevel% NEQ 0 (
echo.
echo    密钥安装失败  请确认你提供的密钥输入正确和适用后重新执行集成
echo.
ping -n 3 127.1>nul
cls
goto MENU
)
title  %dqwc% 手动输入密钥 %dqcd%8
echo.
echo    密钥安装操作完成 如果是您购买的正版密钥安装完成联网将自动永久激活
echo.
ping -n 5 127.1>nul
cls
goto MENU

:KWNR
title  %dqwz% 移除 Recovery 系统还原数据 %dqcd%10
echo.
echo   %dqwz% 移除 Recovery 系统还原数据 %dqcd%10
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if exist "%MOU%\Windows\system32\Recovery" (
cmd.exe /c takeown /f "%MOU%\Windows\system32\Recovery" /r /d y && icacls "%MOU%\Windows\system32\Recovery" /grant administrators:F /t
attrib -s -a -h %MOU%\Windows\system32\Recovery\*.*
RMDIR /S /Q "%MOU%\Windows\system32\Recovery"
)
title  %dqwc% 移除Recovery 系统还原数据 %dqcd%10
echo.
echo   系统自带还原映像数据已移除 在需要时可随时还原启用 程序返回主菜单
echo.
ping -n 5 127.1>nul
cls
goto MENU

:KLWD
title  %dqwz% 禁用或移除Defender %dqcd%11 
echo.
echo   %dqwz% 禁用或移除Defender %dqcd%11 
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   1 只禁用而不移除数据    直接回车禁用并移除 Windows Defender
echo.
set kwdm=2
set /p kwdm=默认直接回车卸载Windows Defender  按1禁用    按0返回主菜单
if /i "%kwdm%"=="0" (
 echo.
 echo    程序将不执行任何操作返回主菜单
 echo.
 ping -n 5 127.1>nul
 cls
 goto MENU
) ELSE (
 echo.
 echo    程序开始设置禁用映像中的 Windows Defender 及安全中心...
 echo.
%YCP%TOOL\Tweak.exe /p "%MOU%" /c Windows-Defender /r >nul 2>nul
 %SSREG% >nul
 reg add "HKLM\0\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f >nul
 reg add "HKLM\0\Policies\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d 1 /f >nul
 %UNREG% >nul
 title  %dqwc% 禁用Defender %dqcd%11-1
 echo.
 echo    成功设置禁用映像中的 Windows Defender 注册表 √
 echo.
 ping -n 5 127.1>nul
if /i %kwdm% EQU 1 CLS &&Goto MENU
)
echo.
echo    查询映像 Windows Defender 功能是否提供禁用并进行相应操作...
echo.
%YCDM% /Image:%MOU% /english /Get-Features>%YCP%Features.txt
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "Windows-Defender" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
del /f /q %YCP%Features.txt
if exist "%MOU%\Program Files\Windows Defender" (
cmd.exe /c takeown /f "%MOU%\Program Files\Windows Defender" /r /d y && icacls "%MOU%\Program Files\Windows Defender" /grant administrators:F /t
rd /S /Q "%MOU%\Program Files\Windows Defender"
)
if exist "%MOU%\ProgramData\Microsoft\Windows Defender" (
cmd.exe /c takeown /f "%MOU%\ProgramData\Microsoft\Windows Defender" /r /d y && icacls "%MOU%\ProgramData\Microsoft\Windows Defender" /grant administrators:F /t
rd /S /Q "%MOU%\ProgramData\Microsoft\Windows Defender"
)
if exist %MOU%\Windows\SysWOW64 if exist "%MOU%\Program Files (x86)\Windows Defender" (
cmd.exe /c takeown /f "%MOU%\Program Files (x86)\Windows Defender" /r /d y && icacls "%MOU%\Program Files (x86)\Windows Defender" /grant administrators:F /t
rd /S /Q "%MOU%\Program Files (x86)\Windows Defender"
)
if exist "%MOU%\Program Files\Windows Defender Advanced Threat Protection" (
echo.
echo    默认移除 SecurityHealthService 主程序
echo.
cmd.exe /c takeown /f "%MOU%\Program Files\Windows Defender Advanced Threat Protection" /r /d y && icacls "%MOU%\Program Files\Windows Defender Advanced Threat Protection" /grant administrators:F /t
rd /S /Q "%MOU%\Program Files\Windows Defender Advanced Threat Protection"
cmd.exe /c takeown /f "%MOU%\ProgramData\Microsoft\Windows Defender Advanced Threat Protection" /r /d y && icacls "%MOU%\ProgramData\Microsoft\Windows Defender Advanced Threat Protection" /grant administrators:F /t
rd /S /Q "%MOU%\ProgramData\Microsoft\Windows Defender Advanced Threat Protection"
)
if exist "%MOU%\Windows\System32\SecurityHealthService.exe" (
echo.
echo    安全关闭安全中心主程序及开始菜单中的图标
echo.
cmd.exe /c takeown /f "%MOU%\ProgramData\Microsoft\Windows Security Health" /r /d y && icacls "%MOU%\ProgramData\Microsoft\Windows Security Health" /grant administrators:F /t
rd /S /Q "%MOU%\ProgramData\Microsoft\Windows Security Health"
cmd.exe /c takeown /f %MOU%\Windows\System32\SecurityHealthService.exe && icacls %MOU%\Windows\System32\SecurityHealthService.exe /grant administrators:F /t
ren %MOU%\Windows\System32\SecurityHealthService.exe SecurityHealthService.bak
)
echo.
echo    安全关闭 smartscreen 主程序
echo.
if exist "%MOU%\Windows\System32\smartscreen.exe" (
cmd.exe /c takeown /f %MOU%\Windows\System32\smartscreen.exe && icacls %MOU%\Windows\System32\smartscreen.exe /grant administrators:F /t
ren %MOU%\Windows\System32\smartscreen.exe smartscreen.bak
)
title  %dqwc% 移除 Windows Defender %dqcd%11 
echo.
echo    系统自带 Windows Defender 已经卸载残余数据已移除 程序返回
echo.
ping -n 5 127.1>nul
cls
goto MENU

:KONE
title  %dqwz% 移除OneDrive或SkyDrive或Win10升级助手 %dqcd%12
echo.
echo   %dqwz% 移除OneDrive或SkyDrive或Win10升级助手 %dqcd%12
echo.
if exist %MOU%\Windows\System32\GWX (
cmd.exe /c takeown /f "%MOU%\Windows\System32\GWX" /r /d y && icacls "%MOU%\Windows\System32\GWX" /grant administrators:F /t
RMDIR /S /Q %MOU%\Windows\System32\GWX
%SSREG% >nul
REG ADD "HKLM\0\Policies\Microsoft\Windows\Gwx" /v "DisableGwx" /t REG_DWORD /d 0 /f >nul
%UNREG% >nul
)
if exist %MOU%\Windows\system32\SkyDrive.exe (
cmd.exe /c takeown /f %MOU%\Windows\FileManager\FileManager.exe && icacls %MOU%\Windows\FileManager\FileManager.exe /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\system32\SkyDrive.exe && icacls %MOU%\Windows\system32\SkyDrive.exe /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\system32\SkyDriveShell.dll && icacls %MOU%\Windows\system32\SkyDriveShell.dll /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\system32\SkyDriveTelemetry.dll && icacls %MOU%\Windows\system32\SkyDriveTelemetry.dll /grant administrators:F /t
DEL /Q /F %MOU%\Windows\FileManager\FileManager.exe
DEL /Q /F "%MOU%\ProgramData\Microsoft\Windows\Start Menu\FileManager.lnk"
DEL /Q /F %MOU%\Windows\system32\SkyDrive.exe
DEL /Q /F %MOU%\Windows\system32\SkyDriveShell.dll
DEL /Q /F %MOU%\Windows\system32\SkyDriveTelemetry.dll
)
if exist %MOU%\Windows\SysWOW64\OneDriveSetup.exe (
echo.
echo    正在处理 OneDrive 安装包及注册表...
%YCP%TOOL\Tweak.exe /p "%MOU%" /c Microsoft-Windows-OneDrive-Setup /r >nul 2>nul
)
if exist %MOU%\Windows\System32\OneDriveSetup.exe (
echo.
echo    正在处理 OneDrive 安装包及注册表...
%YCP%TOOL\Tweak.exe /p "%MOU%" /c Microsoft-Windows-OneDrive-Setup /r >nul 2>nul
)
echo.
echo    处理注册表中的登录启动项
echo.
%USREG% >nul
reg delete "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Run" /f >nul 2>nul
%UNREG% >nul
%SSREG% >nul
reg delete "HKLM\0\Microsoft\Windows\CurrentVersion\Run" /f >nul 2>nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Run" /f >nul 2>nul
%UNREG% >nul
title  %dqwc% 移除OneDrive或SkyDrive或Win10升级助手 %dqcd%12
echo.
echo   OneDrive或SkyDrive数据数据已移除 程序返回主菜单
echo.
ping -n 5 127.1>nul
cls
goto MENU

:KBRO
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if exist "%MOU%\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" (
title  %dqwz% 卸载 Edge 浏览器 %dqcd%13
echo.
echo   %dqwz% 卸载 Edge 浏览器 %dqcd%13
echo.
echo   开始查询并卸载 Edge 浏览器... 请稍候
echo.
%YCP%TOOL\Tweak.exe /p "%MOU%" /c Microsoft-Windows-Internet-Browser /r >nul 2>nul
title  %dqwc% 卸载 Edge 浏览器 %dqcd%13
echo   Edge 数据已经卸载 程序3秒后返回主菜单
echo.
ping -n 3 127.1 >nul
cls
)
if exist "%MOU%\Windows\SystemApps\Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe" (
cmd.exe /c takeown /f "%MOU%\Windows\SystemApps\Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe" /r /d y && icacls "%MOU%\Windows\SystemApps\Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe" /grant administrators:F /t
RMDIR /S /Q %MOU%\Windows\SystemApps\Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe
)
goto MENU

:KCTA
if %OFFSYS% LSS 9686 goto MENU
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if exist "%MOU%\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy" (
title  %dqwz% 卸载 Cortana 小娜 %dqcd%14
echo.
echo   %dqwz% 卸载 Cortana 小娜 %dqcd%14
echo.
echo   开始查询并卸载  Cortana 小娜... 请稍候
echo.
%YCP%TOOL\Tweak.exe /p "%MOU%" /c Microsoft-Windows-Cortana /r >nul 2>nul
)
if exist "%MOU%\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy" (
cmd.exe /c takeown /f "%MOU%\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy" /r /d y && icacls "%MOU%\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy" /grant administrators:F /t
RMDIR /S /Q %MOU%\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy
)
title  %dqwc% 卸载 Cortana 小娜 %dqcd%14
echo.
echo   卸载 Cortana 小娜操作完成 程序3秒后返回主菜单
echo.
ping -n 3 127.1 >nul
cls
)
goto MENU

:KSPH
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% 移除 Speech 语音包括 TTS 数据 %dqcd%15
echo.
echo   %dqwz% 移除 Speech 语音包括 TTS 数据 %dqcd%15
echo.
echo   程序默认优先采取卸载如不成功将进行强制删除 开始查询并执行操作 请稍候...
echo.
%YCDM% /Image:%MOU% /English /Get-packages >%YCP%packages.txt
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "Speech" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
if exist %MOU%\Windows\Speech (
cmd.exe /c takeown /f "%MOU%\Windows\Speech_OneCore" /r /d y && icacls "%MOU%\Windows\Speech_OneCore" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\Speech_OneCore"
cmd.exe /c takeown /f "%MOU%\Windows\Speech" /r /d y && icacls "%MOU%\Windows\Speech" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\Speech"
cmd.exe /c takeown /f "%MOU%\Windows\System32\Speech" /r /d y && icacls "%MOU%\Windows\System32\Speech" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\Speech"
cmd.exe /c takeown /f "%MOU%\Windows\System32\Speech_OneCore" /r /d y && icacls "%MOU%\Windows\System32\Speech_OneCore" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\Speech_OneCore"
if exist %MOU%\Windows\SysWOW64 if exist %MOU%\Windows\SysWOW64\Speech (
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\Speech_OneCore" /r /d y && icacls "%MOU%\Windows\SysWOW64\Speech_OneCore" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\Speech_OneCore"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\Speech" /r /d y && icacls "%MOU%\Windows\SysWOW64\Speech" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\Speech"
)
)
del /q %YCP%packages.txt
title  %dqwc% 移除 Speech 语音包括 TTS 数据 %dqcd%15
echo.
echo  Speech 语音功能已经卸载或数据已经强制删除 程序3秒后返回主菜单
echo.
ping -n 3 127.1 >nul
cls
goto MENU

:PEFT
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% 精简字体 %dqcd%16 
echo.
echo   %dqwz% 精简字体 %dqcd%16 
echo.
echo   默认采用WINPE字体作为保留样本 经实际测试不影响OFFICE2016正式版安装
echo.
set ftfa=1
set /p ftfa=直接回车执行精简 如不做操作返回请输入0回车：
if "%ftfa%"=="0" goto MENU
echo.
echo   采用WINPE字体作为保留样本 经实际测试不影响OFFICE2016正式版安装
echo.
echo   开始处理权限并精简字体... 请稍候！
echo.
cmd.exe /c takeown /f "%MOU%\Windows\Fonts" /r /d y && icacls "%MOU%\Windows\Fonts" /grant administrators:F /t
attrib -s -r -h -a %MOU%\Windows\Fonts\*.*
ren %MOU%\Windows\Fonts\desktop.ini desktop.bak
del /q /f %MOU%\Windows\Fonts\dokchamp.ttf
del /q /f %MOU%\Windows\Fonts\calibrib.ttf
del /q /f %MOU%\Windows\Fonts\malgunbd.ttf
del /q /f %MOU%\Windows\Fonts\mingliub.ttc
del /q /f %MOU%\Windows\Fonts\msgothic.ttc
del /q /f %MOU%\Windows\Fonts\msyhbd.ttc
del /q /f %MOU%\Windows\Fonts\msjhbd.ttc
del /q /f %MOU%\Windows\Fonts\msjhbl.ttc
del /q /f %MOU%\Windows\Fonts\NirmalaB.ttf
del /q /f %MOU%\Windows\Fonts\YuGothB.ttc
del /q /f %MOU%\Windows\Fonts\gulim.ttc
del /q /f %MOU%\Windows\Fonts\javatext.ttf
del /q /f %MOU%\Windows\Fonts\KhmerUI.ttf
del /q /f %MOU%\Windows\Fonts\KhmerUIb.ttf
del /q /f %MOU%\Windows\Fonts\LeelaUIb.ttf
del /q /f %MOU%\Windows\Fonts\LeelawUI.ttf
del /q /f %MOU%\Windows\Fonts\LeelUIsl.ttf
del /q /f %MOU%\Windows\Fonts\majalla.ttf
del /q /f %MOU%\Windows\Fonts\majallab.ttf
del /q /f %MOU%\Windows\Fonts\malgun.ttf
del /q /f %MOU%\Windows\Fonts\meiryo.ttc
del /q /f %MOU%\Windows\Fonts\mingliu.ttc
del /q /f %MOU%\Windows\Fonts\mmrtextb.ttf
del /q /f %MOU%\Windows\Fonts\monbaiti.ttf
del /q /f %MOU%\Windows\Fonts\msgothic.ttc
del /q /f %MOU%\Windows\Fonts\msjh.ttc
del /q /f %MOU%\Windows\Fonts\msjhl.ttc
del /q /f %MOU%\Windows\Fonts\msyhbd.ttc
del /q /f %MOU%\Windows\Fonts\msyhl.ttc
del /q /f %MOU%\Windows\Fonts\Nirmala.ttf
del /q /f %MOU%\Windows\Fonts\NirmalaB.ttf
del /q /f %MOU%\Windows\Fonts\NirmalaS.ttf
del /q /f %MOU%\Windows\Fonts\seguibl.ttf
del /q /f %MOU%\Windows\Fonts\seguibli.ttf
del /q /f %MOU%\Windows\Fonts\seguiemj.ttf
del /q /f %MOU%\Windows\Fonts\Sitka.ttc
del /q /f %MOU%\Windows\Fonts\SitkaB.ttc
del /q /f %MOU%\Windows\Fonts\SitkaI.ttc
del /q /f %MOU%\Windows\Fonts\SitkaZ.ttc
del /q /f %MOU%\Windows\Fonts\sylfaen.ttf
del /q /f %MOU%\Windows\Fonts\UrdTypeb.ttf
del /q /f %MOU%\Windows\Fonts\yugothib.ttf
del /q /f %MOU%\Windows\Fonts\yugothic.ttf
del /q /f %MOU%\Windows\Fonts\yugothil.ttf
del /q /f %MOU%\Windows\Fonts\yumin.ttf
del /q /f %MOU%\Windows\Fonts\yumindb.ttf
del /q /f %MOU%\Windows\Fonts\yuminl.ttf
del /q /f %MOU%\Windows\Fonts\ahronbd.ttf
del /q /f %MOU%\Windows\Fonts\aldhabi.ttf
del /q /f %MOU%\Windows\Fonts\ALGER.TTF
del /q /f %MOU%\Windows\Fonts\andlso.ttf
del /q /f %MOU%\Windows\Fonts\angsa.ttf
del /q /f %MOU%\Windows\Fonts\angsab.ttf
del /q /f %MOU%\Windows\Fonts\angsai.ttf
del /q /f %MOU%\Windows\Fonts\angsau.ttf
del /q /f %MOU%\Windows\Fonts\angsaub.ttf
del /q /f %MOU%\Windows\Fonts\angsaui.ttf
del /q /f %MOU%\Windows\Fonts\angsauz.ttf
del /q /f %MOU%\Windows\Fonts\angsaz.ttf
del /q /f %MOU%\Windows\Fonts\ANTQUAB.TTF
del /q /f %MOU%\Windows\Fonts\ANTQUABI.TTF
del /q /f %MOU%\Windows\Fonts\ANTQUAI.TTF
del /q /f %MOU%\Windows\Fonts\aparaj.ttf
del /q /f %MOU%\Windows\Fonts\aparajb.ttf
del /q /f %MOU%\Windows\Fonts\aparajbi.ttf
del /q /f %MOU%\Windows\Fonts\aparaji.ttf
del /q /f %MOU%\Windows\Fonts\arabtype.ttf
del /q /f %MOU%\Windows\Fonts\ARIALN.TTF
del /q /f %MOU%\Windows\Fonts\ARIALNB.TTF
del /q /f %MOU%\Windows\Fonts\ARIALNBI.TTF
del /q /f %MOU%\Windows\Fonts\ARIALNI.TTF
del /q /f %MOU%\Windows\Fonts\ARIALUNI.TTF
del /q /f %MOU%\Windows\Fonts\BASKVILL.TTF
del /q /f %MOU%\Windows\Fonts\batang.ttc
del /q /f %MOU%\Windows\Fonts\BAUHS93.TTF
del /q /f %MOU%\Windows\Fonts\BELL.TTF
del /q /f %MOU%\Windows\Fonts\BELLB.TTF
del /q /f %MOU%\Windows\Fonts\BELLI.TTF
del /q /f %MOU%\Windows\Fonts\BERNHC.TTF
del /q /f %MOU%\Windows\Fonts\BKANT.TTF
del /q /f %MOU%\Windows\Fonts\BOD_PSTC.TTF
del /q /f %MOU%\Windows\Fonts\BOOKOS.TTF
del /q /f %MOU%\Windows\Fonts\BOOKOSB.TTF
del /q /f %MOU%\Windows\Fonts\BOOKOSBI.TTF
del /q /f %MOU%\Windows\Fonts\BOOKOSI.TTF
del /q /f %MOU%\Windows\Fonts\BRITANIC.TTF
del /q /f %MOU%\Windows\Fonts\BRLNSB.TTF
del /q /f %MOU%\Windows\Fonts\BRLNSDB.TTF
del /q /f %MOU%\Windows\Fonts\BRLNSR.TTF
del /q /f %MOU%\Windows\Fonts\BROADW.TTF
del /q /f %MOU%\Windows\Fonts\browa.ttf
del /q /f %MOU%\Windows\Fonts\browab.ttf
del /q /f %MOU%\Windows\Fonts\browai.ttf
del /q /f %MOU%\Windows\Fonts\browau.ttf
del /q /f %MOU%\Windows\Fonts\browaub.ttf
del /q /f %MOU%\Windows\Fonts\browaui.ttf
del /q /f %MOU%\Windows\Fonts\browauz.ttf
del /q /f %MOU%\Windows\Fonts\browaz.ttf
del /q /f %MOU%\Windows\Fonts\BRUSHSCI.TTF
del /q /f %MOU%\Windows\Fonts\CALIFB.TTF
del /q /f %MOU%\Windows\Fonts\CALIFI.TTF
del /q /f %MOU%\Windows\Fonts\CALIFR.TTF
del /q /f %MOU%\Windows\Fonts\CENTAUR.TTF
del /q /f %MOU%\Windows\Fonts\CENTURY.TTF
del /q /f %MOU%\Windows\Fonts\CHILLER.TTF
del /q /f %MOU%\Windows\Fonts\COLONNA.TTF
del /q /f %MOU%\Windows\Fonts\COOPBL.TTF
del /q /f %MOU%\Windows\Fonts\cordia.ttf
del /q /f %MOU%\Windows\Fonts\cordiab.ttf
del /q /f %MOU%\Windows\Fonts\cordiai.ttf
del /q /f %MOU%\Windows\Fonts\cordiau.ttf
del /q /f %MOU%\Windows\Fonts\cordiaub.ttf
del /q /f %MOU%\Windows\Fonts\cordiaui.ttf
del /q /f %MOU%\Windows\Fonts\cordiauz.ttf
del /q /f %MOU%\Windows\Fonts\cordiaz.ttf
del /q /f %MOU%\Windows\Fonts\daunpenh.ttf
del /q /f %MOU%\Windows\Fonts\david.ttf
del /q /f %MOU%\Windows\Fonts\davidbd.ttf
del /q /f %MOU%\Windows\Fonts\frank.ttf
del /q /f %MOU%\Windows\Fonts\FREESCPT.TTF
del /q /f %MOU%\Windows\Fonts\FTLTLT.TTF
del /q /f %MOU%\Windows\Fonts\FZSTK.TTF
del /q /f %MOU%\Windows\Fonts\FZYTK.TTF
del /q /f %MOU%\Windows\Fonts\GARA.TTF
del /q /f %MOU%\Windows\Fonts\GARABD.TTF
del /q /f %MOU%\Windows\Fonts\GARAIT.TTF
del /q /f %MOU%\Windows\Fonts\gautami.ttf
del /q /f %MOU%\Windows\Fonts\gautamib.ttf
del /q /f %MOU%\Windows\Fonts\GlobalMonospace.CompositeFont
del /q /f %MOU%\Windows\Fonts\GlobalSansSerif.CompositeFont
del /q /f %MOU%\Windows\Fonts\GlobalSerif.CompositeFont
del /q /f %MOU%\Windows\Fonts\GlobalUserInterface.CompositeFont
del /q /f %MOU%\Windows\Fonts\GOTHIC.TTF
del /q /f %MOU%\Windows\Fonts\GOTHICB.TTF
del /q /f %MOU%\Windows\Fonts\GOTHICBI.TTF
del /q /f %MOU%\Windows\Fonts\GOTHICI.TTF
del /q /f %MOU%\Windows\Fonts\HARLOWSI.TTF
del /q /f %MOU%\Windows\Fonts\HARNGTON.TTF
del /q /f %MOU%\Windows\Fonts\himalaya.ttf
del /q /f %MOU%\Windows\Fonts\HTOWERT.TTF
del /q /f %MOU%\Windows\Fonts\HTOWERTI.TTF
del /q /f %MOU%\Windows\Fonts\INFROMAN.TTF
del /q /f %MOU%\Windows\Fonts\iskpota.ttf
del /q /f %MOU%\Windows\Fonts\iskpotab.ttf
del /q /f %MOU%\Windows\Fonts\ITCKRIST.TTF
del /q /f %MOU%\Windows\Fonts\JOKERMAN.TTF
del /q /f %MOU%\Windows\Fonts\JUICE*.TTF
del /q /f %MOU%\Windows\Fonts\kaiu.ttf
del /q /f %MOU%\Windows\Fonts\kalinga.ttf
del /q /f %MOU%\Windows\Fonts\kalingab.ttf
del /q /f %MOU%\Windows\Fonts\kartika.ttf
del /q /f %MOU%\Windows\Fonts\kartikab.ttf
del /q /f %MOU%\Windows\Fonts\kokila.ttf
del /q /f %MOU%\Windows\Fonts\kokilab.ttf
del /q /f %MOU%\Windows\Fonts\kokilabi.ttf
del /q /f %MOU%\Windows\Fonts\kokilai.ttf
del /q /f %MOU%\Windows\Fonts\KUNSTLER.TTF
del /q /f %MOU%\Windows\Fonts\LaoUI.ttf
del /q /f %MOU%\Windows\Fonts\LaoUIb.ttf
del /q /f %MOU%\Windows\Fonts\latha.ttf
del /q /f %MOU%\Windows\Fonts\lathab.ttf
del /q /f %MOU%\Windows\Fonts\LATINWD.TTF
del /q /f %MOU%\Windows\Fonts\LBRITE.TTF
del /q /f %MOU%\Windows\Fonts\LBRITED.TTF
del /q /f %MOU%\Windows\Fonts\LBRITEDI.TTF
del /q /f %MOU%\Windows\Fonts\LBRITEI.TTF
del /q /f %MOU%\Windows\Fonts\LCALLIG.TTF
del /q /f %MOU%\Windows\Fonts\leelawad.ttf
del /q /f %MOU%\Windows\Fonts\leelawdb.ttf
del /q /f %MOU%\Windows\Fonts\LFAX.TTF
del /q /f %MOU%\Windows\Fonts\LFAXD.TTF
del /q /f %MOU%\Windows\Fonts\LFAXDI.TTF
del /q /f %MOU%\Windows\Fonts\LFAXI.TTF
del /q /f %MOU%\Windows\Fonts\LHANDW.TTF
del /q /f %MOU%\Windows\Fonts\lvnm.ttf
del /q /f %MOU%\Windows\Fonts\lvnmbd.ttf
del /q /f %MOU%\Windows\Fonts\MAGNETOB.TTF
del /q /f %MOU%\Windows\Fonts\malgunbd.ttf
del /q /f %MOU%\Windows\Fonts\mangal.ttf
del /q /f %MOU%\Windows\Fonts\mangalb.ttf
del /q /f %MOU%\Windows\Fonts\MATURASC.TTF
del /q /f %MOU%\Windows\Fonts\meiryob.ttc
del /q /f %MOU%\Windows\Fonts\mingliub.ttc
del /q /f %MOU%\Windows\Fonts\MISTRAL.TTF
del /q /f %MOU%\Windows\Fonts\mmrtext.ttf
del /q /f %MOU%\Windows\Fonts\MOD20.TTF
del /q /f %MOU%\Windows\Fonts\mriam.ttf
del /q /f %MOU%\Windows\Fonts\mriamc.ttf
del /q /f %MOU%\Windows\Fonts\msjhbd.ttc
del /q /f %MOU%\Windows\Fonts\msmincho.ttc
del /q /f %MOU%\Windows\Fonts\msuighub.ttf
del /q /f %MOU%\Windows\Fonts\msuighur.ttf
del /q /f %MOU%\Windows\Fonts\msyi.ttf
del /q /f %MOU%\Windows\Fonts\MTCORSVA.TTF
del /q /f %MOU%\Windows\Fonts\mvboli.ttf
del /q /f %MOU%\Windows\Fonts\NIAGENG.TTF
del /q /f %MOU%\Windows\Fonts\NIAGSOL.TTF
del /q /f %MOU%\Windows\Fonts\nrkis.ttf
del /q /f %MOU%\Windows\Fonts\ntailu.ttf
del /q /f %MOU%\Windows\Fonts\ntailub.ttf
del /q /f %MOU%\Windows\Fonts\nyala.ttf
del /q /f %MOU%\Windows\Fonts\OLDENGL.TTF
del /q /f %MOU%\Windows\Fonts\ONYX.TTF
del /q /f %MOU%\Windows\Fonts\PARCHM.TTF
del /q /f %MOU%\Windows\Fonts\phagspa.ttf
del /q /f %MOU%\Windows\Fonts\phagspab.ttf
del /q /f %MOU%\Windows\Fonts\plantc.ttf
del /q /f %MOU%\Windows\Fonts\PLAYBILL.TTF
del /q /f %MOU%\Windows\Fonts\POORICH.TTF
del /q /f %MOU%\Windows\Fonts\raavi.ttf
del /q /f %MOU%\Windows\Fonts\raavib.ttf
del /q /f %MOU%\Windows\Fonts\RAVIE.TTF
del /q /f %MOU%\Windows\Fonts\REFSAN.TTF
del /q /f %MOU%\Windows\Fonts\rod.ttf
del /q /f %MOU%\Windows\Fonts\Shonar.ttf
del /q /f %MOU%\Windows\Fonts\Shonarb.ttf
del /q /f %MOU%\Windows\Fonts\SHOWG.TTF
del /q /f %MOU%\Windows\Fonts\shruti.ttf
del /q /f %MOU%\Windows\Fonts\shrutib.ttf
del /q /f %MOU%\Windows\Fonts\simfang.ttf
del /q /f %MOU%\Windows\Fonts\simhei.ttf
del /q /f %MOU%\Windows\Fonts\simkai.ttf
del /q /f %MOU%\Windows\Fonts\SIMLI.TTF
del /q /f %MOU%\Windows\Fonts\simpbdo.ttf
del /q /f %MOU%\Windows\Fonts\simpfxo.ttf
del /q /f %MOU%\Windows\Fonts\simpo.ttf
del /q /f %MOU%\Windows\Fonts\simsunb.ttf
del /q /f %MOU%\Windows\Fonts\SIMYOU.TTF
del /q /f %MOU%\Windows\Fonts\SNAP*.TTF
del /q /f %MOU%\Windows\Fonts\STCAIYUN.TTF
del /q /f %MOU%\Windows\Fonts\STENCIL.TTF
del /q /f %MOU%\Windows\Fonts\STFANGSO.TTF
del /q /f %MOU%\Windows\Fonts\STHUPO.TTF
del /q /f %MOU%\Windows\Fonts\STKAITI.TTF
del /q /f %MOU%\Windows\Fonts\STLITI.TTF
del /q /f %MOU%\Windows\Fonts\STSONG.TTF
del /q /f %MOU%\Windows\Fonts\STXIHEI.TTF
del /q /f %MOU%\Windows\Fonts\STXINGKA.TTF
del /q /f %MOU%\Windows\Fonts\STXINWEI.TTF
del /q /f %MOU%\Windows\Fonts\STZHONGS.TTF
del /q /f %MOU%\Windows\Fonts\taile.ttf
del /q /f %MOU%\Windows\Fonts\taileb.ttf
del /q /f %MOU%\Windows\Fonts\TEMPSITC.TTF
del /q /f %MOU%\Windows\Fonts\tradbdo.ttf
del /q /f %MOU%\Windows\Fonts\trado.ttf
del /q /f %MOU%\Windows\Fonts\tunga.ttf
del /q /f %MOU%\Windows\Fonts\tungab.ttf
del /q /f %MOU%\Windows\Fonts\upcdb.ttf
del /q /f %MOU%\Windows\Fonts\upcdbi.ttf
del /q /f %MOU%\Windows\Fonts\upcdi.ttf
del /q /f %MOU%\Windows\Fonts\upcdl.ttf
del /q /f %MOU%\Windows\Fonts\upceb.ttf
del /q /f %MOU%\Windows\Fonts\upcebi.ttf
del /q /f %MOU%\Windows\Fonts\upcei.ttf
del /q /f %MOU%\Windows\Fonts\upcel.ttf
del /q /f %MOU%\Windows\Fonts\upcfb.ttf
del /q /f %MOU%\Windows\Fonts\upcfbi.ttf
del /q /f %MOU%\Windows\Fonts\upcfi.ttf
del /q /f %MOU%\Windows\Fonts\upcfl.ttf
del /q /f %MOU%\Windows\Fonts\upcib.ttf
del /q /f %MOU%\Windows\Fonts\upcibi.ttf
del /q /f %MOU%\Windows\Fonts\upcii.ttf
del /q /f %MOU%\Windows\Fonts\upcil.ttf
del /q /f %MOU%\Windows\Fonts\upcjb.ttf
del /q /f %MOU%\Windows\Fonts\upcjbi.ttf
del /q /f %MOU%\Windows\Fonts\upcji.ttf
del /q /f %MOU%\Windows\Fonts\upcjl.ttf
del /q /f %MOU%\Windows\Fonts\upckb.ttf
del /q /f %MOU%\Windows\Fonts\upckbi.ttf
del /q /f %MOU%\Windows\Fonts\upcki.ttf
del /q /f %MOU%\Windows\Fonts\upckl.ttf
del /q /f %MOU%\Windows\Fonts\upclb.ttf
del /q /f %MOU%\Windows\Fonts\upclbi.ttf
del /q /f %MOU%\Windows\Fonts\upcli.ttf
del /q /f %MOU%\Windows\Fonts\upcll.ttf
del /q /f %MOU%\Windows\Fonts\UrdType.ttf
del /q /f %MOU%\Windows\Fonts\utsaah.ttf
del /q /f %MOU%\Windows\Fonts\utsaahb.ttf
del /q /f %MOU%\Windows\Fonts\utsaahbi.ttf
del /q /f %MOU%\Windows\Fonts\utsaahi.ttf
del /q /f %MOU%\Windows\Fonts\Vani.ttf
del /q /f %MOU%\Windows\Fonts\Vanib.ttf
del /q /f %MOU%\Windows\Fonts\vijaya.ttf
del /q /f %MOU%\Windows\Fonts\vijayab.ttf
del /q /f %MOU%\Windows\Fonts\VINERITC.TTF
del /q /f %MOU%\Windows\Fonts\VIVALDII.TTF
del /q /f %MOU%\Windows\Fonts\VLADIMIR.TTF
del /q /f %MOU%\Windows\Fonts\vrinda.ttf
del /q /f %MOU%\Windows\Fonts\vrindab.ttf
del /q /f %MOU%\Windows\Fonts\WINGDNG2.TTF
del /q /f %MOU%\Windows\Fonts\WINGDNG3.TTF 
del /q /f %MOU%\Windows\Fonts\StaticCache.dat
ren %MOU%\Windows\Fonts\desktop.bak desktop.ini
attrib +s +r +a %MOU%\Windows\Fonts\*.ttf
attrib +s +r +a %MOU%\Windows\Fonts\*.fon
attrib +s +r +h +a %MOU%\Windows\Fonts\*.xml
attrib +h +s %MOU%\Windows\Fonts\desktop.ini
attrib +s +r %MOU%\Windows\Fonts
title  %dqwc% 精简字体 %dqcd%16-1
echo.
echo   字体精简操作完成  5秒后程序返回主菜单
echo.
ping -n 5 127.1 >nul
cls
goto MENU

:KABY
if %OFFSYS% LSS 7600 goto MENU
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% 精简 assembly 部分数据 %dqcd%17
echo.
echo   %dqwz% 精简 assembly 部分数据 %dqcd%17
echo.
if exist "%MOU%\Windows\assembly\NativeImages_v2.0.50727_32" (
cmd.exe /c takeown /f "%MOU%\Windows\assembly\NativeImages_v2.0.50727_32" /r /d y && icacls "%MOU%\Windows\assembly\NativeImages_v2.0.50727_32" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\assembly\NativeImages_v2.0.50727_32"
)
if exist %MOU%\Windows\SysWOW64 if exist "%MOU%\Windows\assembly\NativeImages_v2.0.50727_64" (
cmd.exe /c takeown /f "%MOU%\Windows\assembly\NativeImages_v2.0.50727_64" /r /d y && icacls "%MOU%\Windows\assembly\NativeImages_v2.0.50727_64" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\assembly\NativeImages_v2.0.50727_64"
)
if exist "%MOU%\Windows\assembly\NativeImages_v4.0.30319_32" (
cmd.exe /c takeown /f "%MOU%\Windows\assembly\NativeImages_v4.0.30319_32" /r /d y && icacls "%MOU%\Windows\assembly\NativeImages_v4.0.30319_32" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\assembly\NativeImages_v4.0.30319_32"
)
if exist %MOU%\Windows\SysWOW64 if exist "%MOU%\Windows\assembly\NativeImages_v4.0.30319_64" (
cmd.exe /c takeown /f "%MOU%\Windows\assembly\NativeImages_v4.0.30319_64" /r /d y && icacls "%MOU%\Windows\assembly\NativeImages_v4.0.30319_64" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\assembly\NativeImages_v4.0.30319_64"
)
title  %dqwc% 精简 assembly 部分数据 %dqcd%17
echo.
echo    Assembly 部分数据已经移除 程序3秒后返回主菜单
echo.
ping -n 3 127.1 >nul
cls
goto MENU

:KSAP
if %OFFSYS% LSS 10240 goto MENU
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% 安全精简其它一些强制内置的应用  %dqcd%18
echo.
echo      为Win10以上系统安全精简其它一些强制内置的应用  %dqcd%18
echo.
if exist %YCP%SystemAppslist.txt del /q /f %YCP%SystemAppslist.txt >nul
if exist %MOU%\Windows\HoloShell echo HoloShell>%YCP%SystemAppslist.txt
if exist %MOU%\Windows\SystemApps (dir /b /a "%MOU%\Windows\SystemApps">>%YCP%SystemAppslist.txt)
echo.
echo    ┏┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┓
echo      以下已经列出RS5以前部分强制内置的应用  不包括已经移除的项目 以下为默认保留部分
echo.
echo    ┏┅┳┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┳┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┳┅┓
echo    ┋01┋        系  统  云  主  机        ┋   Windows Cloud Experience Host  ┋●┋
echo    ┣┅╋┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┫
echo    ┋02┋        家   长   控   制         ┋     Parental       Controls      ┋●┋
echo    ┣┅╋┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┫
echo    ┋03┋        外   壳   主   机         ┋      Shell  Experience  Host     ┋●┋
echo    ┣┅╋┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┫
echo    ┋04┋        Edge     浏 览 器         ┋     Microsoft           Edge     ┋◎┋
echo    ┣┅╋┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┫
echo    ┋05┋        Cortana 小娜 语音         ┋     Windows          Cortana     ┋◎┋
echo    ┣┅╋┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┫
echo    ┋06┋        Metro 锁 屏 管 理         ┋     Content Delivery Manager     ┋◎┋
echo    ┗┅┻┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┻┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┻┅┛
echo.
echo               确认精简请直接回车                     不精简请按N回车返回
echo    ┗┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┛
echo.
set ksya=Y
set /p ksya=请确定你的选择并回车：
if /i "%ksya%"=="N" if exist %YCP%SystemAppslist.txt del /q /f %YCP%SystemAppslist.txt >nul &&GOTO MENU 
echo.
echo      开始按默认安全方案进行精简强制内置的应用...    请稍候
echo.
if exist %MOU%\Windows\HoloShell (
cmd.exe /c takeown /f "%MOU%\Windows\HoloShell" /r /d y && icacls "%MOU%\Windows\HoloShell" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\HoloShell"
)
set yc=%MOU%\Windows\SystemApps
findstr /i /V /C:".CloudExperienceHost_" "%YCP%SystemAppslist.txt"|findstr /i /V /C:"ParentalControls_" >"%YCP%Appslist.txt"
del /f /q %YCP%SystemAppslist.txt && Ren "%YCP%Appslist.txt" SystemAppslist.txt
findstr /i /V /C:"ShellExperienceHost_" "%YCP%SystemAppslist.txt"|findstr /i /V /C:".MicrosoftEdge_" >"%YCP%Appslist.txt"
del /f /q %YCP%SystemAppslist.txt && Ren "%YCP%Appslist.txt" SystemAppslist.txt
findstr /i /V /C:".Cortana_" "%YCP%SystemAppslist.txt"|findstr /i /V /C:".ContentDeliveryManager_" >"%YCP%Appslist.txt"
del /f /q %YCP%SystemAppslist.txt && Ren "%YCP%Appslist.txt" SystemAppslist.txt
for /f "delims=" %%i in (%YCP%SystemAppslist.txt) do (cmd.exe /c takeown /f "%YC%\%%i" /r /d y & icacls "%YC%\%%i" /grant administrators:F /t & RD /s/q "%YC%\%%i")
if exist %YCP%SystemAppslist.txt del /f /q %YCP%SystemAppslist.txt
echo.
title  %dqwc% 安全精简其它一些强制内置的应用  %dqcd%18
echo.
echo      已经为RS5以前系统安全精简了已知可以精简的强制内置部分应用
echo.
ping -n 5 127.1 >nul
cls
goto MENU

:NWMP
if %OFFSYS% LSS 9651 goto MENU
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% 为 Win10 N版系统添加 Windows Media Player 功能  %dqcd%30
echo.
echo   %dqwz% 为 Win10 N版系统添加 Windows Media Player 功能  %dqcd%30
echo.
if not exist "%MOU%\Program Files\Windows Media Player\wmplayer.exe" %YCDM% /image:%MOU% /add-package /packagepath:%YCP%PCAB\%SSYS%WMP%Mbt%.CAB
if !errorlevel!==0 (
title  %dqwc% 为 Win10 N版系统添加 Windows Media Player 功能
echo.
echo   成功添加 Windows Media Player 功能                    程序返回主菜单
echo.
) ELSE (
echo.
echo   操作有误或程序包损坏 未能成功添加 Windows Media Player 功能 程序返回
echo.
)
ping -n 3 127.1 >nul
cls
goto MENU

:YCQD
if not exist %YCP%YCMOU md %YCP%YCMOU
if not exist %MOU%\Windows\Setup\Scripts md %MOU%\Windows\Setup\Scripts
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% 自助安装绿色驱动或整合驱动 %dqcd%20
echo.
echo   %dqwz% 自助安装绿色驱动或整合驱动 %dqcd%20
echo   ======================================================================
echo.
echo   程序默认提供万能驱动 主板驱动 和 网卡驱动
echo.
echo.
echo                1    整合 主板网卡驱动
echo.
echo                2    安装 已知绿色驱动
echo.
echo   ======================================================================
set /p qdxz=  请输入相应序号数字回车执行相应操作 输入0回车直接返回主菜单：
if /i "%qdxz%"=="0" GOTO :MENU
if /i "%qdxz%"=="1" GOTO :WNQD
if /i "%qdxz%"=="2" GOTO :MYQD
echo.
echo    输入错误  程序自动返回主菜单
echo.
ping -n 3 127.1>nul
cls
goto MENU

:WNQD
title  %dqwz% 整合万能驱动6^[主板芯片+网卡^]部分 %dqcd%20-1
echo.
echo   %dqwz% 为不能自动在线安装驱动的目标硬件添加或集成驱动
echo.
echo     1    推荐并默认整合 万能驱动6^[主板和网卡驱动^]部分
echo.
if not exist %MOU%\Windows\Setup\Scripts md %MOU%\Windows\Setup\Scripts
if exist %YCP%ADXX\%FSYS%%Mbt% Xcopy /y /s %YCP%ADXX\%FSYS%%Mbt% %MOU%\Windows\Setup\Scripts\
if not exist %MOU%\Windows\Setup\Scripts\SetupComplete.cmd  Xcopy /y /s %YCP%MY\Setup\Scripts\SetupComplete.cmd  %MOU%\Windows\Setup\Scripts\
title  %dqwc% 整合万能 主板芯片+网卡驱动 %dqcd%20-1
echo.
echo   整合 主板驱动+网卡驱动完成 程序返回主菜单
echo.
ping -n 6 127.1>nul
cls
goto MENU

:MYQD
title  %dqwz% 安装指定绿色驱动 %dqcd%20-2
if not exist %YCP%MyQD\%FSYS%%Mbt% md %YCP%MyQD\%FSYS%%Mbt%
echo.
echo   为特定或自用电脑硬件安装绿色驱动      通常为inf扩展的驱动文件完整目录
echo   ======================================================================
echo   将要安装的绿色不同驱动目录复制到%YCP%MyQD\%FSYS%%Mbt%目录中回车执行
echo.
pause >nul 2>nul
echo   如果驱动数据无误 程序开始逐个完成添加到映像中 请稍候...
echo.
if not exist "%YCP%MyQD\%FSYS%%Mbt%\*" (
echo.
echo   驱动数据没有准备就绪 请确认后重新执行安装操作 程序返回主菜单
echo.
rd %YCP%MyQD\%FSYS%%Mbt%
ping -n 6 127.1>nul
cls
goto MENU
)
%YCDM% /Image:%MOU% /Add-Driver /Driver:%YCP%MyQD\%FSYS%%Mbt% /Recurse /Forceunsigned
title  安装指定绿色驱动完成
echo.
title  %dqwc% 安装指定绿色驱动 %dqcd%20-2
ping -n 5 127.1>nul
cls
goto MENU

:SOFT
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% 整合绿色软件 %dqcd%26
echo.
echo   %dqwz% 整合绿色软件 %dqcd%26
echo.
echo  简单说明，只为追求纯净的朋友添加有限绿色静默小程序，过多会影响安装速度：
echo  ======================================================================================
echo      YCDISM宗旨为纯净安全，强烈禁止利用本程序加入存在安全隐患的程序整合到映像中！在加入
echo.
echo  绿色软件前需要您须知该软件或自解压包的静默执行参数，否则在无人值守安装部署时将停留在需
echo.
echo  要点击下一步或勾选同意协议类似的互动安装界面而导致无人值守安装部署的效率，程序推荐在整
echo.
echo  合前将绿色软件的名称进行简化和规范，名称推荐用简洁无空格字母或者英文命名以适应所有语言
echo.
echo  x86架构程序请放在%YCP%MY\SOFT\x86目录中 x64架构程序请放在%YCP%MY\SOFT\x64目录中
echo.
echo                               执行此操作前请完成无人值守操作
echo  ======================================================================================
echo.
if not exist %MOU%\Windows\Setup\Scripts\SetupComplete.cmd goto WRZS
if not exist %YCP%MY\SOFT\%Mbt%\*.exe (
echo.
echo  没有发现%YCP%MY\SOFT\%Mbt%目录下存在EXE程序数据     请确认数据准备就绪后重新执行整合操作
echo.
ping -n 10 127.1>nul
cls
goto MENU
)
if exist %YCP%MY\SOFT\%Mbt%\*.exe (
cd /d %YCP%MY\SOFT\%Mbt% &&for %%i in (*.exe) do (echo if exist %%i start /wait %%i>>exelist.txt)
cd /d %YCP%
)
if exist %YCP%MY\SOFT\%Mbt%\exelist.txt (
if exist %YCP%MY\SOFT\%Mbt%\SetupComplete.txt del /q /f %YCP%MY\SOFT\%Mbt%\SetupComplete.txt
Copy /y %YCP%MY\SOFT\%Mbt%\SetupComplete.bak %YCP%MY\SOFT\%Mbt%\SetupComplete.txt
Type %YCP%MY\SOFT\%Mbt%\exelist.txt>>%YCP%MY\SOFT\%Mbt%\SetupComplete.txt
start %YCP%MY\SOFT\%Mbt%\SetupComplete.txt
)
echo.
echo      请在打开的文本下面每行最后加上该程序静默参数 注意大小写比如：/S
echo.
echo      确认已按要求正确操作完毕请保存并关闭文本         按回车加入调用
echo.
pause>nul
echo del %%0 >>%YCP%MY\SOFT\%Mbt%\SetupComplete.txt
echo exit /q>>%YCP%MY\SOFT\%Mbt%\SetupComplete.txt
if exist %YCP%MY\SOFT\%Mbt%\SetupComplete.cmd del /q /f %YCP%MY\SOFT\%Mbt%\SetupComplete.cmd
if exist %YCP%MY\SOFT\%Mbt%\SetupComplete.txt Ren %YCP%MY\SOFT\%Mbt%\SetupComplete.txt SetupComplete.cmd
if exist %YCP%MY\SOFT\%Mbt%\exelist.txt del /q /f %YCP%MY\SOFT\%Mbt%\exelist.txt
if exist %YCP%MY\SOFT\%Mbt%\*.exe Xcopy /y %YCP%MY\SOFT\%Mbt%\*.exe %MOU%\Windows\Setup\Scripts\
if exist %YCP%MY\SOFT\%Mbt%\SetupComplete.cmd Copy /y %YCP%MY\SOFT\%Mbt%\SetupComplete.cmd %MOU%\Windows\Setup\Scripts\SetupComplete.cmd
if exist %YCP%MY\SOFT\%Mbt%\SetupComplete.cmd del /q /f %YCP%MY\SOFT\%Mbt%\SetupComplete.cmd
title  %dqwc% 整合绿色软件 %dqcd%50
echo.
echo      整合绿色软件到映像操作完成                    程序返回主菜单 
echo.
ping -n 6 127.1>nul
cls
goto MENU

:ADVC
title  %dqwz% 整合 VC Flash %dqcd%21
echo.
echo   %dqwz% 整合 VC Flash %dqcd%21
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
Xcopy /d %YCP%MY\Setup\Scripts\SetupComplete.cmd  %MOU%\Windows\Setup\Scripts\
echo.
echo   VC+++2005\08\10\12\13\15...
if exist %YCP%ADXX\MSVBC%Mbt%.exe Copy /y %YCP%ADXX\MSVBC%Mbt%.exe %MOU%\Windows\Setup\Scripts\MSVBC.exe
if %OFFSYS% LEQ 9200 (
echo.
echo   添加FLASH...
Xcopy /y %YCP%ADXX\FLASH.exe %MOU%\Windows\Setup\Scripts\
)
title  %dqwc% 添加 VC Flash 离线安装程序 %dqcd%21
echo.
echo   VC Flash 离线安装程序已添加完成 程序返回主菜单
echo.
ping -n 6 127.1>nul
cls
goto MENU

:MWEB
title  %dqwz% 替换映像Web目录所有图片 %dqcd%22
echo.
echo   %dqwz% 替换映像Web目录所有图片 %dqcd%22
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   如果存在自DIY的LOGO文件 程序将替换到目标系统中
echo.
cmd.exe /c takeown /f "%MOU%\Windows\Branding\Shellbrd" /r /d y && icacls "%MOU%\Windows\Branding\Shellbrd" /grant administrators:F /t
if exist %YCP%MY\%FSYS%Shellbrd.dll Copy /y %YCP%MY\%FSYS%Shellbrd.dll %MOU%\Windows\Branding\Shellbrd\Shellbrd.dll
if %OFFSYS% GEQ 14295 (
if exist %YCP%MY\RSShellbrd.dll Copy /y %YCP%MY\%YCP%MY\RSShellbrd.dll %MOU%\Windows\Branding\Shellbrd\Shellbrd.dll
)
echo.
echo   获取主题相关数据的权限并替换为%YCP%MY中的数据...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\Resources\Themes" /r /d y && icacls "%MOU%\Windows\Resources\Themes" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\Resources\Themes\aero" /r /d y && icacls "%MOU%\Windows\Resources\Themes\aero" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\Web" /r /d y && icacls "%MOU%\Windows\Web" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\Web\Wallpaper\Theme1" /r /d y && icacls "%MOU%\Windows\Web\Wallpaper\Theme1" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\Web\Wallpaper\Theme2" /r /d y && icacls "%MOU%\Windows\Web\Wallpaper\Theme2" /grant administrators:F /t
Xcopy /y /u %YCP%MY\IMG %MOU%\Windows\Web\Wallpaper\Windows\
if exist %MOU%\Windows\Web\Wallpaper\Architecture Xcopy /y /u %YCP%MY\IMG %MOU%\Windows\Web\Wallpaper\Architecture\
if exist %MOU%\Windows\Web\Wallpaper\Characters Xcopy /y /u %YCP%MY\IMG %MOU%\Windows\Web\Wallpaper\Characters\
if exist %MOU%\Windows\Web\Wallpaper\Landscapes Xcopy /y /u %YCP%MY\IMG %MOU%\Windows\Web\Wallpaper\Landscapes\
if exist %MOU%\Windows\Web\Wallpaper\Nature Xcopy /y /u %YCP%MY\IMG %MOU%\Windows\Web\Wallpaper\Nature\
if exist %MOU%\Windows\Web\Wallpaper\Scenes Xcopy /y /u %YCP%MY\IMG %MOU%\Windows\Web\Wallpaper\Scenes\
if exist %MOU%\Windows\Web\Screen Xcopy /y /h /s /u %YCP%MY\IMG %MOU%\Windows\Web\Screen\
if exist %MOU%\Windows\Web\Wallpaper\Theme1 (
Xcopy /s /y /u %YCP%MY\IMG %MOU%\Windows\Web\Wallpaper\Theme1\
)
if exist %MOU%\Windows\Web\Wallpaper\Theme2 (
Xcopy /s /y /u %YCP%MY\IMG %MOU%\Windows\Web\Wallpaper\Theme2\
)
if exist %MOU%\Windows\Web\4K\Wallpaper\Windows if exist %YCP%MY\IMG\4K Xcopy /s /y /u %YCP%MY\IMG\4K %MOU%\Windows\Web\4K\Wallpaper\Windows\
title  %dqwc% 替换映像Web目录所有图片 %dqcd%22
echo.
echo   替换映像Web目录所有图片已完成 √
echo.
ping -n 5 127.1>nul
cls
goto MENU

:BBZH
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if %OFFSYS% LSS 10240 GOTO MENU
CALL :MMZB
title  %dqwz% Windows 10 版本转换 %dqcd%32
echo.
echo.
echo.
echo      雨晨 DISM 目前只提供 Windows 10 部分版本转换 当前版本为 %MEID% 
echo    ======================================================================================
echo      请尽量采用主菜单中的 48 升级操作获得较高的版本 如果没有想要的版本时使用本项转换操作
echo.
if %OFFSYS% GEQ 17133 echo               0 转成 Windows 10 远程服务器 版
if %OFFSYS% GEQ 17133 echo.
echo               1 转成 Windows 10 家庭中文 版
echo.
echo               2 转成 Windows 10 家庭 版
echo.
echo               3 转成 Windows 10 专业 版
echo.
echo               4 转成 Windows 10 专业工作站 版
echo.
echo               5 转成 Windows 10 专业教育 版
echo.
echo               6 转成 Windows 10 企业 版
echo.
echo               7 转成 Windows 10 企业 G 版
echo.
echo               8 转成 Windows 10 教育 版
echo.
echo               9 转成 Windows 10 企业版 2016 长期服务方案 版 (SKU是1607 14393.0数据)
echo.
echo      注意  将低版本转换成高版本后 再转回某些低版本时可能会出现不能正常转换完成的异常情况
echo.
echo      SKU数据主要采用的是RS3(16299.15)和RS4(17134.1)请尽量在 RS3 RS4基础映像上执行相应操作
echo    ======================================================================================
set ZHSZ=B
set /p ZHSZ=请输入要转换成的版本序号数字回车执行操作 返回输入B回车:
if "%ZHSZ%"=="B" GOTO :MENU
if "%ZHSZ%"=="0" Set MBBB=ServerRdsh
if "%ZHSZ%"=="1" Set MBBB=CoreCountrySpecific
if "%ZHSZ%"=="2" Set MBBB=Core
if "%ZHSZ%"=="3" Set MBBB=Professional
if "%ZHSZ%"=="4" Set MBBB=ProfessionalWorkstation
if "%ZHSZ%"=="5" Set MBBB=ProfessionalEducation
if "%ZHSZ%"=="6" Set MBBB=Enterprise
if "%ZHSZ%"=="7" Set MBBB=EnterpriseG
if "%ZHSZ%"=="8" Set MBBB=Education
if "%ZHSZ%"=="9" Set MBBB=EnterpriseS
if %ZHSZ% gtr 9 GOTO :MENU
cls
echo.
echo   如果存在相应SKU数据 程序开始尝试将 %MEID% 转制成 %MBBB% ... 请稍候
echo.
call :set%MBBB%
%YCDM% /Image:%MOU% /Set-ProductKey:%KEY%
if not exist %YCP%PCAB\%OFFSYS%\%MBBB%%Mbt% (
echo.
echo   没有发现%OFFSYS%的%MBBB%%Mbt%SKU数据而无法继续操作  自动返回主菜单
echo.
ping -n 6 127.1>nul
cls
goto :MENU
)
%YCDM% /image:%MOU% /add-package /packagepath:%YCP%PCAB\%OFFSYS%\%MBBB%%Mbt%
title   %dqwc% 将 Win10 %MEID% 转成 %MBBB% %dqcd%32
echo.
echo   %dqwc% 将 Win10 %MEID% 转成 %MBBB%  程序返回
echo.
ping -n 3 127.1>nul
%SSREG% >nul
CALL :GetNow
%UNREG% >nul
CALL :BBXM
ping -n 3 127.1>nul
goto MENU

:WRZS
title  %dqwz% 无人值守及通用化设置 %dqcd%24
echo.
echo   %dqwz% 无人值守及通用化设置 %dqcd%24
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if %OFFSYS% LEQ 7601 (
echo.
echo   智能为Win7sp1以下系统添加激活程序 Windows loader...
echo.
Xcopy /y %YCP%MY\TOAC.exe %MOU%\Windows\Setup\Scripts\
Xcopy /y %YCP%MY\Keys.ini %MOU%\Windows\Setup\Scripts\
Xcopy /y %YCP%ADXX\FLASH.exe %MOU%\Windows\Setup\Scripts\
)
if not exist %YCP%MY\System32\logo.bmp if exist %YCP%MY\logo.bmp Xcopy /y %YCP%MY\logo.bmp %YCP%MY\System32\
Xcopy /y %YCP%MY\System32 %MOU%\Windows\System32\
if not exist %MOU%\Windows\Panther md %MOU%\Windows\Panther
%SSREG% >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\RunOnce" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\Setup\State\RunOnce.cmd" /f >nul
%UNREG% >nul
Xcopy /y %YCP%MY\RunOnce.cmd %MOU%\Windows\Setup\State\ >nul
if %SSYS% EQU %OFFSYS%S Copy /y %YCP%MY\SSRunOnce.cmd %MOU%\Windows\Setup\State\RunOnce.cmd >nul
echo.
echo   选择无人值守安装用户组及名称:Win7以下默认内置管理员帐户
echo   =============================================================================
echo   1 采用内置管理员帐户 名称为 Administrator 无密码 Win10_15063 后不影响使用Apps
echo.
echo   2 采用 Users 组帐户 名称为 MyPC 无密码 主要针对Win8-Win10(14393)使用App的限制
echo.
echo     如需更改请稍后用记事本打开并编辑 %MOU%\Windows\Panther\unattend.xml
echo.
echo   3 跳过 保持原版安装过程
echo   =============================================================================
echo.
choice /C:123 /N /M "输入 1 使用内置管理员帐户      输入 2 使用Users组帐户MyPC : "
if errorlevel 3 goto :YCSZ1
if errorlevel 2 (
Copy /y %YCP%Panther\%FSYS%%Mbt%Otherunattend.xml %MOU%\Windows\Panther\unattend.xml >nul 2>nul
if %SSYS% EQU %OFFSYS%S Copy /y %YCP%Panther\SS%FSYS%%Mbt%Otherunattend.xml %MOU%\Windows\Panther\unattend.xml >nul 2>nul
)
if errorlevel 1 (
Copy /y %YCP%Panther\%FSYS%%Mbt%Adminunattend.xml %MOU%\Windows\Panther\unattend.xml >nul 2>nul
if %SSYS% EQU %OFFSYS%S Copy /y %YCP%Panther\SS%FSYS%%Mbt%Adminunattend.xml %MOU%\Windows\Panther\unattend.xml >nul 2>nul
)
Xcopy /y /s %YCP%MY\Setup %MOU%\Windows\Setup\
if %OFFSYS% LEQ 7601 (
Copy /y %YCP%Panther\W7YH.reg %MOU%\Windows\Setup\YCYH.reg >nul
) else (
Xcopy /y %YCP%Panther\YCYH.reg %MOU%\Windows\Setup\
)

:YCSZ1
%SSREG% >nul
echo.
echo   去掉资源管理器中的快速访问
echo.
set ObName=HKEY_LOCAL_MACHINE\0\Classes\CLSID\{679f85cb-0220-4080-b29b-5540cc05aab6}\ShellFolder
set ObType=reg
Call :SetACLADMIN
reg add "HKLM\0\Classes\CLSID\{679f85cb-0220-4080-b29b-5540cc05aab6}\ShellFolder" /v "Attributes" /t REG_DWORD /d 4294967295 /f >nul
reg add "HKLM\0\Classes\CLSID\{679f85cb-0220-4080-b29b-5540cc05aab6}\ShellFolder" /v "FolderValueFlags" /t REG_DWORD /d 1 /f >nul
echo.
echo   去掉资源管理器中的库...
echo.
set ObName=HKEY_LOCAL_MACHINE\0\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder
Call :SetACLADMIN
reg add "HKLM\0\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder" /v "Attributes" /t REG_DWORD /d 2962227469 /f >nul
reg add "HKLM\0\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder" /v "FolderValueFlags" /t REG_DWORD /d 270880 /f >nul
Call :SetACLSYSTEM
echo.
echo   去掉资源管理器中的收藏...
echo.
set ObName=HKEY_LOCAL_MACHINE\0\Classes\CLSID\{323CA680-C24D-4099-B94D-446DD2D7249E}\ShellFolder
call :SetACLADMIN
reg add "HKLM\0\Classes\CLSID\{323CA680-C24D-4099-B94D-446DD2D7249E}\ShellFolder" /v "Attributes" /t REG_DWORD /d 2696937728 /f >nul
reg add "HKLM\0\Classes\CLSID\{323CA680-C24D-4099-B94D-446DD2D7249E}\ShellFolder" /v "FolderValueFlags" /t REG_DWORD  /d 1 /f >nul
call :SetACLSYSTEM
echo.
echo   去掉资源管理器中的家庭组...
echo.
set ObName=HKEY_LOCAL_MACHINE\0\Classes\CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}\ShellFolder
call :SetACLADMIN
reg add "HKLM\0\Classes\CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}\ShellFolder" /v "Attributes" /t REG_DWORD /d 2961441036 /f >nul
reg add "HKLM\0\Classes\CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}\ShellFolder" /v "FolderValueFlags" /t REG_DWORD /d 270880 /f >nul
call :SetACLSYSTEM
echo.
echo   去掉资源管理器中的可移动设备...
echo.
set ObName=HKEY_LOCAL_MACHINE\0\Classes\CLSID\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}\ShellFolder
call :SetACLADMIN
reg add "HKLM\0\Classes\CLSID\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}\ShellFolder" /v "Attributes" /t REG_DWORD /d 2952790016 /f >nul
reg add "HKLM\0\Classes\CLSID\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}\ShellFolder" /v "FolderValueFlags" /t REG_DWORD /d 1040 /f >nul
call :SetACLSYSTEM
echo.
echo   去掉资源管理器中的网络...
echo.
set ObName=HKEY_LOCAL_MACHINE\0\Classes\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder
call :SetACLADMIN
reg add "HKLM\0\Classes\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "Attributes" /t REG_DWORD /d 2953052260 /f >nul
reg add "HKLM\0\Classes\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "FolderValueFlags" /t REG_DWORD /d 1057344 /f >nul
call :SetACLSYSTEM
%UNREG% >nul
echo.
echo   在桌面显示 我的电脑 回收站 用户文件夹 图标...
echo.
set IEOF=Y
choice /C:12 /N /M "输入1 桌面添加IE   输入2 桌面不加IE 并跳过IE主页设置 : "
if errorlevel 2 set IEOF=N
if errorlevel 1 set IEOF=Y
%SSREG% >nul
reg delete "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons" /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{031E4825-7B94-4dc3-B131-E946B44C8DD5}" /t REG_DWORD /d 1 /f >nul
if /i %IEOF% NEQ N reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{00000000-0000-0000-0000-100000000001}" /t REG_DWORD /d 0 /f >nul
echo.
echo   隐藏我的电脑和导航中的六文件夹...
echo.
set ObName=HKEY_LOCAL_MACHINE\0\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
Call :SetACLADMIN
reg delete "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace" /f >nul 2>nul
Call :SetACLSYSTEM
if /i %IEOF% NEQ N (
echo.
echo   增加设置在桌面显示 Internet Explorer 图标...
echo.
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{00000000-0000-0000-0000-100000000001}" /ve /t REG_SZ /d "Internet Explorer" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}" /ve /t REG_SZ /d "Internet Explorer" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\DefaultIcon" /ve /t REG_SZ /d "ieframe.dll,-190" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell" /ve /t REG_SZ /d "" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell\NoAddOns" /ve /t REG_SZ /d "无加载项(&N)" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell\NoAddOns\Command" /ve /t REG_SZ /d "iexplore.exe -extoff" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell\Open" /ve /t REG_SZ /d "打开主页(&H)" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell\Open\Command" /ve /t REG_SZ /d "iexplore.exe" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell\Set" /ve /t REG_SZ /d "属性(&R)" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell\Set\Command" /ve /t REG_SZ /d "rundll32.exe shell32.dll,Control_RunDLL inetcpl.cpl" /f >nul
)
%UNREG% >nul
ping -n 6 127.1>nul
if /i %IEOF% EQU N GOTO :TGIE

:CSHP
echo.
echo   设置 Internet Explorer 首页...
echo.
set "hp=https://www.2345.com/?k371057592"
echo.
echo   请粘贴你的IE首页网址到本程序窗口后回车 否则默认为雨晨2345导航
echo.
set /p hp=请输入或直接粘贴你自己要设置的IE主页网址  回车后将应用到映像中
echo.
echo   你设置的主页为 %hp% 确认无误请直接回车
echo.
set hpqr=
set /p hpqr=输入 N 回车重新修改IE主页网址
if /i "%hpqr%"=="N" GOTO CSHP
echo.
echo   将%hp%设置为映像默认的IE主页

:TGIE
%USREG% >nul
echo.
echo   退出IE浏览器时自动清理历史记录...
echo.
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Privacy" /v "ClearBrowsingHistoryOnExit" /t REG_DWORD /d 1 /f >nul
echo.
echo   右键添加显示或隐藏文件或扩展名...
echo.
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d 0 /f >nul
%UNREG% >nul
%SSREG% >nul
reg add "HKLM\0\Classes\Directory\background\shell\SuperHidden" /ve /t REG_SZ /d "显示或隐藏文件及扩展名" /f >nul
reg add "HKLM\0\Classes\Directory\background\shell\SuperHidden\Command" /ve /t REG_EXPAND_SZ /d "WScript.exe %%Windir%%\System32\SuperHidden.vbs" /f >nul
%UNREG% >nul
Xcopy /y %YCP%MY\System32\SuperHidden.vbs %MOU%\Windows\System32\ >nul
echo.
echo   部分通用优化 推迟升级 加快运行和响应速度等...
echo.
%SSREG% >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "AlwaysUnloadDll" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "DesktopProcess" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "RequireAdmin" /f >nul
reg add "HKLM\0\Microsoft\Internet Explorer\Main" /v "DisableFirstRunCustomize" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Internet Explorer\Main" /v "RunOnceHasShown" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Internet Explorer\Main" /v "RunOnceComplete" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "NoAutoUpdate" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "AUOptions" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "ConfigVer" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Internet Explorer\Security" /v "BlockXBM" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Policies\Microsoft\Internet Explorer\Infodelivery\Restrictions" /v "NoJITSetup" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgrade" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Internet Explorer\Main" /v "Enable AutoImageResize" /t REG_SZ /d "yes" /f >nul
reg add "HKLM\0\Microsoft\Internet Explorer\Main" /v "NotifyDownloadComplete" /t REG_SZ /d "no" /f >nul
reg add "HKLM\0\Microsoft\Internet Explorer\Main" /v "DisableScriptDebuggerIE" /t REG_SZ /d "yes" /f  >nul
reg add "HKLM\0\Microsoft\Internet Explorer\Main" /v "Friendly http errors" /t REG_SZ /d "no" /f >nul
reg add "HKLM\0\Microsoft\Internet Explorer\Main" /v "Error Dlg Displayed On Every Error" /t REG_SZ /d "no" /f >nul
%UNREG% >nul
%USREG% >nul
reg add "HKLM\0\Console" /v "ScreenColors" /t REG_DWORD /d 31 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1609" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgrade" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "Enable AutoImageResize" /t REG_SZ /d "yes" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "RunOnceHasShown" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "RunOnceComplete" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "NotifyDownloadComplete" /t REG_SZ /d "no" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "DisableScriptDebuggerIE" /t REG_SZ /d "yes" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "Friendly http errors" /t REG_SZ /d "no" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "Error Dlg Displayed On Every Error" /t REG_SZ /d "no" /f >nul
%UNREG% >nul
echo.
echo   关闭应用自动备份功能 ...
echo.
%SSREG% >nul
reg add "HKLM\0\Policies\Microsoft\Windows\SettingSync" /v "EnableBackupForWin8Apps" /t REG_DWORD /d 0 /f >nul
echo.
echo   关闭账户控制 ...
echo.
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0 /f >nul
echo.
echo   将图片预览背景设置为黑色 ...
echo.
reg add "HKLM\0\Microsoft\Windows Photo Viewer\Viewer" /v "BackGroundColor" /t REG_DWORD /d "4278255873" /f >nul
%UNREG% >nul
%USREG% >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows Photo Viewer\Viewer" /v "BackGroundColor" /t REG_DWORD /d "4278255873" /f >nul
echo.
echo   资源管理显示完整路径 ...
echo.
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v "FullPath" /t REG_DWORD /d 1 /f >nul
%UNREG% >nul 
echo.
echo   添加桌面右键快捷菜单 ...
echo.
%SSREG% >nul
reg add "HKLM\0\Classes\*\shell\Notepad" /ve /t REG_SZ /d "用记事本打开该文件" /f >nul
reg add "HKLM\0\Classes\*\shell\Notepad\Command" /ve /t REG_SZ /d "notepad %%1" /f >nul
reg add "HKLM\0\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\cleanmgr" /ve /t REG_SZ /d "清理工具" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\cleanmgr" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\cleanmgr.exe" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\cleanmgr\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\cleanmgr.exe" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\msconfig" /ve /t REG_SZ /d "系统配置" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\msconfig" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\msconfig.exe" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\msconfig\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\msconfig.exe" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\SnippingTool" /ve /t REG_SZ /d "截图工具" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\SnippingTool" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\SnippingTool.exe" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\SnippingTool\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\SnippingTool.exe" /f >nul
if %OFFSYS% LEQ 7601 if exist %MOU%\Windows\system32\calc.exe (
reg add "HKLM\0\Classes\DesktopBackground\Shell\win32calc" /ve /t REG_SZ /d "计算器" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\win32calc" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\calc.exe" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\win32calc\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\calc.exe" /f >nul
)
if %OFFSYS% GTR 7601 if not exist %MOU%\Windows\system32\win32calc.exe (
echo   桌面右键添加计算器 ...
echo.
Xcopy /y /s %YCP%TOOL\calc "%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\win32calc\" >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\win32calc" /ve /t REG_SZ /d "计算器" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\win32calc" /v "Icon" /t REG_EXPAND_SZ /d "%%ProgramData%%\Microsoft\Windows\Start Menu\Programs\win32calc\win32calc.exe" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\win32calc\command" /ve /t REG_EXPAND_SZ /d "%%ProgramData%%\Microsoft\Windows\Start Menu\Programs\win32calc\win32calc.exe" /f >nul
) ELSE (
echo   桌面右键添加计算器 ...
echo.
reg add "HKLM\0\Classes\DesktopBackground\Shell\win32calc" /ve /t REG_SZ /d "计算器" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\win32calc" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\win32calc.exe" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\win32calc\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\win32calc.exe" /f >nul
)
%UNREG% >nul
echo.
echo   我的电脑右键加入常用工具菜单...
echo.
%SSREG% >nul
set ObName=HKEY_LOCAL_MACHINE\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell
set ObType=reg
call :SetACLADMIN
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\control" /f >nul
set ObName=HKEY_LOCAL_MACHINE\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\control
call :SetACLADMIN
echo.
echo   我的电脑右键添加“控制面板”...
echo.
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\control" /ve /t REG_SZ /d "控制面板(&C)" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\control" /v "SuppressionPolicy" /t REG_DWORD /d 1073741884 /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\control" /v "Icon" /t REG_SZ /d "shell32.dll,207" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\control\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe shell32.dll,Control_RunDLL" /f >nul
echo.
echo   我的电脑右键添加“设备管理器”...
echo.
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DevMgr" /f >nul
set ObName=HKEY_LOCAL_MACHINE\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DevMgr
call :SetACLADMIN
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DevMgr" /ve /t REG_SZ /d "设备管理器" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DevMgr" /v "SuppressionPolicy" /t REG_DWORD /d 1073741884 /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DevMgr\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\mmc.exe /s %%SystemRoot%%\system32\devmgmt.msc" /f >nul
echo.
echo   我的电脑右键添加“添加或删除程序”...
echo.
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Dezinstall" /f >nul
set ObName=HKEY_LOCAL_MACHINE\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Dezinstall
call :SetACLADMIN
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Dezinstall" /ve /t REG_SZ /d "添加或删除程序" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Dezinstall" /v "SuppressionPolicy" /t REG_DWORD /d 1073741884 /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Dezinstall\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe shell32.dll,Control_RunDLL appwiz.cpl" /f >nul
if exist %MOU%\Windows\System32\gpedit.msc (
echo.
echo   我的电脑右键添加“组策略”...
echo.
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\NGpEdit" /f >nul
set ObName=HKEY_LOCAL_MACHINE\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\NGpEdit
call :SetACLADMIN
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\NGpEdit" /ve /t REG_SZ /d "组策略" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\NGpEdit" /v "SuppressionPolicy" /t REG_DWORD /d 1073741884 /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\NGpEdit\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\mmc.exe /s %%SystemRoot%%\system32\gpedit.msc" /f >nul
)
echo.
echo   我的电脑右键添加“注册表编辑器”...
echo.
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Regedit" /f >nul
set ObName=HKEY_LOCAL_MACHINE\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Regedit
call :SetACLADMIN
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Regedit" /ve /t REG_SZ /d "注册表编辑器" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Regedit" /v "SuppressionPolicy" /t REG_DWORD /d 1073741884 /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Regedit" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\regedit.exe" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Regedit\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\regedit.exe" /f >nul
echo.
echo   我的电脑右键添加“服务”...
echo.
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\services" /f >nul
set ObName=HKEY_LOCAL_MACHINE\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\services
call :SetACLADMIN
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\services" /ve /t REG_SZ /d "服务(&V)" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\services" /v "SuppressionPolicy" /t REG_DWORD /d 1073741884 /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\services\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\mmc.exe %%SystemRoot%%\system32\services.msc" /f >nul
echo.
echo   右键添加获取管理员权限...
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
echo.
echo   右键添加“复制文件或复制目录路径”...
echo.
reg add "HKLM\0\Classes\*\shell\copypath" /ve /t REG_SZ /d "复制文件路径" /f >nul
reg add "HKLM\0\Classes\*\shell\copypath\command" /ve /t REG_SZ /d "mshta vbscript:clipboarddata.setdata(\"text\",\"%%1\")(close)" /f >nul
reg add "HKLM\0\Classes\Directory\shell\copypath" /ve /t REG_SZ /d "复制目录路径" /f >nul
reg add "HKLM\0\Classes\Directory\shell\copypath\command" /ve /t REG_SZ /d "mshta vbscript:clipboarddata.setdata(\"text\",\"%%1\")(close)" /f >nul
echo.
echo   去快捷方式箭头及快捷方式字样等设置... 
echo.
reg add "HKLM\0\Policies\Microsoft\WindowsMediaPlayer" /v "GroupPrivacyAcceptance" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t REG_BINARY /d "00000000" /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "DesktopProcess" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v "29" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\imageres.dll,197" /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v "77" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\imageres.dll,197" /f >nul
%UNREG% >nul
%USREG% >nul
reg add "HKLM\0\Software\Microsoft\NotePad" /v "StatusBar" /t REG_DWORD /d 1 /f >nul
%UNREG% >nul
echo.
echo   系统优化相关设置 ...
echo.
%SSREG% >nul
reg add "HKLM\0\Microsoft\Command Processor" /v "CompletionChar" /t REG_DWORD /d 64 /f >nul
reg add "HKLM\0\Microsoft\Windows\Windows Error Reporting\Assert Filtering Policy" /v "ReportAndContinue" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\Windows Error Reporting\Assert Filtering Policy" /v "AlwaysUnloadDll" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\Windows Error Reporting\Assert Filtering Policy" /v "Max Cached Icons" /t REG_SZ /d "7500" /f >nul
echo.
echo   关闭系统自动还原 ...
echo.
reg add "HKLM\0\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "DisableSR" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "CreateFirstRunRp" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Dfrg\BootOptimizeFunction" /v "Enable" /t REG_SZ /d "Y" /f >nul
echo.
echo   禁止一些弹窗提醒 ...
echo.
reg add "HKLM\0\Microsoft\Security Center" /v "UACDisableNotify" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Security Center" /v "AntiVirusDisableNotify" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Security Center" /v "FirewallDisableNotify" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Security Center" /v "UpdatesDisableNotify" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\OptimalLayout" /v "EnableAutoLayout" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "ColorPrevalence" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SpecialColor" /t REG_DWORD /d "2716620" /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAHealth" /t REG_DWORD /d 1 /f >nul
if %OFFSYS% GTR 7601 (
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartMenuMFUprogramsList" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ClearRecentDocsOnExit" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInstrumentation" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoCDBurning" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AlwaysShowClassicMenu" /t REG_DWORD /d 1 /f >nul
) ELSE (
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ForceActiveDesktopOn" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoActiveDesktop" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoActiveDesktopChanges" /t REG_DWORD /d 1 /f >nul
)
%UNREG% >nul
%USREG% >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Toolbar" /v "LinksFolderName" /t REG_SZ /d "" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Toolbar" /v "Locked" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Toolbar" /v "ShowDiscussionButton" /t REG_SZ /d "Yes" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Connection Wizard" /v "Completed" /t REG_BINARY /d "01000000" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Connection Wizard" /v "DesktopChanged" /t REG_DWORD /d 1 /f >nul
echo.
echo   使用经典的开始菜单及允许更改主题等 ...
echo.
if %OFFSYS% GTR 7601 (
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartMenuMFUprogramsList" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAHealth" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ClearRecentDocsOnExit" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInstrumentation" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoCDBurning" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AlwaysShowClassicMenu" /t REG_DWORD /d 1 /f >nul
) ELSE (
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ForceActiveDesktopOn" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoActiveDesktop" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoActiveDesktopChanges" /t REG_DWORD /d 1 /f >nul
)
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "ColorPrevalence" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SpecialColor" /t REG_DWORD /d "2716620" /f >nul
echo.
echo   开始菜单显示电源选项等 ...
echo.
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Network\NetworkLocationWizard" /v "HideWizard" /t REG_DWORD /d 1 /f >nul
echo.
echo   加快网络速度 ...
echo.
reg add "HKLM\0\SYSTEM\CurrentControlSet\Services\atapi\Parameters" /v "EnableBigLba" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" /v "EnableConnectionRateLimiting" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d 80 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Lsa" /v "limitblankpassworduse" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Lsa" /v "forceguest" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Lsa" /v "Restrictanonymous" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Lsa" /v "Restrictanonymoussam" /t REG_DWORD /d 0 /f >nul
echo.
echo   优化系统预读加快运行 ...
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
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f >nul
reg add "HKLM\0\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f >nul
reg add "HKLM\0\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "1000" /f >nul
reg add "HKLM\0\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul
echo.
echo   去快速启动栏(或桌面) MediaPlayer 图标 ...
echo.
reg add "HKLM\0\Software\Microsoft\MediaPlayer\Setup\UserOptions" /v "DesktopShortcut" /t REG_SZ /d "no" /f >nul
reg add "HKLM\0\Software\Microsoft\MediaPlayer\Setup\UserOptions" /v "QuickLaunchShortcut" /t REG_SZ /d "no" /f >nul
%UNREG% >nul
title  %dqwc% 无人值守及通用化设置 %dqcd%24
echo.
echo   无人值守及通用化设置完成  继续针对性操作...
echo.
ping -n 5 127.1>nul
if %OFFSYS% GEQ 9200 (goto BLUE) ELSE (goto YCSZ)
cls

:BLUE
echo.
echo   针对Win8以上系统 窗口标题栏设置美化...
echo.
%USREG% >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "AutoShareServer" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "AutoShareWks" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "Composition" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationColor" /t REG_DWORD /d 3289414672 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationColorBalance" /t REG_DWORD /d 89 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationAfterglow" /t REG_DWORD /d 3289414672 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationAfterglowBalance" /t REG_DWORD /d 10 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationBlurBalance" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "EnableWindowColorization" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationGlassAttribute" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "AccentColor" /t REG_DWORD /d 4292311040 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "ColorPrevalence" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /t REG_DWORD /d 0 /f >nul
%UNREG% >nul
echo.
echo   针对Win8.1以下系统操作完成 完成所有操作后自动返回...
echo.
ping -n 3 127.1>nul
if %OFFSYS% GEQ 10240 (goto NRTM) ELSE (goto YCSZ)
cls

:NRTM
echo.
echo   针对Win10以上系统 禁用客户体验改善计划及透明任务栏 ...
echo.
%SSREG% >nul
echo.
echo   Edge和IE共用收藏夹 ...
echo.
reg add "HKLM\0\Microsoft\PolicyManager\current\device\Browser" /v "SyncFavoritesBetweenIEAndMicrosoftEdge" /t REG_DWORD /d 1 /f >nul 2>nul
if not exist "%MOU%\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy" (
echo.
echo   卸载后隐藏 Cortana 小娜 任务栏图标 ...
echo.
reg add "HKLM\0\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul
)
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseOLEDTaskbarTransparency" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f
echo.
echo   关闭打开方式从应用商店选择其它应用 ...
echo.
reg add "HKLM\0\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d 1 /f >nul
%UNREG% >nul
%USREG% >nul
echo.
echo   恢复开始右键菜单中的命令提示符 ...
echo.
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DontUsePowerShellOnWinX" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Xaml" /v "AllowFailFastOnAnyFailureF" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\BrowserEmulation" /v "MSCompatibilityMode" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\BrowserEmulation" /v "IntranetCompatibilityMode" /t REG_DWORD /d 0 /f >nul
%UNREG% >nul 
echo.
echo   Win10 Internet Explorer 兼容相关设置完成 ...
echo.
if exist "%MOU%\Windows\System32\zh-CN\windows.storage.dll.mui" if exist %YCP%MY\MUI\%OFFSYS%windows.storage.dll.mui (
echo.
echo   将此电脑改成我的电脑 ...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\System32\zh-CN\windows.storage.dll.mui" && icacls "%MOU%\Windows\System32\zh-CN\windows.storage.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\windows.storage.dll.mui "%MOU%\Windows\System32\zh-CN\"
cmd.exe /c takeown /f "%MOU%\Windows\System32\zh-CN\shell32.dll.mui" && icacls "%MOU%\Windows\System32\zh-CN\shell32.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\shell32.dll.mui "%MOU%\Windows\System32\zh-CN\"
)
if exist "%MOU%\Windows\SysWOW64\zh-CN\windows.storage.dll.mui" if exist %YCP%MY\MUI\%OFFSYS%windows.storage.dll.mui (
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\zh-CN\windows.storage.dll.mui" && icacls "%MOU%\Windows\SysWOW64\zh-CN\windows.storage.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\windows.storage.dll.mui "%MOU%\Windows\SysWOW64\zh-CN\"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\zh-CN\shell32.dll.mui" && icacls "%MOU%\Windows\SysWOW64\zh-CN\shell32.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\shell32.dll.mui "%MOU%\Windows\SysWOW64\zh-CN\"
)
if %OFFSYS% GEQ 14393 if exist "%MOU%\Windows\System32\zh-CN\windows.storage.dll.mui" (
echo.
echo   将此电脑改成我的电脑 ...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\System32\zh-CN\windows.storage.dll.mui" && icacls "%MOU%\Windows\System32\zh-CN\windows.storage.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\windows.storage.dll.mui "%MOU%\Windows\System32\zh-CN\"
cmd.exe /c takeown /f "%MOU%\Windows\System32\zh-CN\shell32.dll.mui" && icacls "%MOU%\Windows\System32\zh-CN\shell32.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\shell32.dll.mui "%MOU%\Windows\System32\zh-CN\" >nul
)
if %OFFSYS% GEQ 14393 if exist "%MOU%\Windows\SysWOW64\zh-CN\windows.storage.dll.mui" (
echo.
echo   将此电脑改成我的电脑 ...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\zh-CN\windows.storage.dll.mui" && icacls "%MOU%\Windows\SysWOW64\zh-CN\windows.storage.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\windows.storage.dll.mui "%MOU%\Windows\SysWOW64\zh-CN\"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\zh-CN\shell32.dll.mui" && icacls "%MOU%\Windows\SysWOW64\zh-CN\shell32.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\shell32.dll.mui "%MOU%\Windows\SysWOW64\zh-CN\" >nul
)
ping -n 3 127.1>nul
echo.
echo   图片格式右键关联图片查看器...
echo.
%SSREG% >nul
reg add "HKLM\0\Classes\.jpg" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul
reg add "HKLM\0\Classes\.png" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul
reg add "HKLM\0\Classes\.jpeg" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul
reg add "HKLM\0\Classes\.bmp" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul
reg add "HKLM\0\Classes\.jfif" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul
reg add "HKLM\0\Classes\.jpe" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul
reg add "HKLM\0\Classes\.dib" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul
reg add "HKLM\0\Classes\.ico" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul
reg add "HKLM\0\Classes\.tga" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul
reg add "HKLM\0\Classes\.gif" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul
%UNREG% >nul
echo.
echo   图片格式右键关联图片查看器完成 √
echo.
if %OFFSYS% GEQ 14295 (goto RSTO) ELSE (goto YCSZ)
cls

:RSTO
echo.
echo   针对Win10 RS1以上系统去开机运行健康检查...
echo.
%SSREG% >nul
reg delete "HKLM\0\Microsoft\Windows\CurrentVersion\Run" /f >nul 2>nul
ping -n 1 127.1>nul
%UNREG% >nul
echo.
echo   不使用桌面语言栏及不在开始菜单显示建议及关闭游戏录制 ...
echo.
%USREG% >nul
reg add "HKLM\0\Software\Microsoft\CTF\MSUTB" /v "Top" /t REG_DWORD /d 706 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "KGLRevision" /t REG_DWORD /d 1301 /f >nul
reg add "HKLM\0\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "FeatureManagementEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContentEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\InputMethod\Settings\CHS" /v "Enable Cloud Candidate" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\InputMethod\Settings\CHS" /v "Enable Fuzzy Input" /t REG_DWORD /d 1 /f >nul
if %MMD% GTR 16184 (
echo.
echo   隐藏托盘人脉图标及通讯程序面板 ...
echo.
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /v "PeopleBand" /t REG_DWORD /d 0 /f >nul
reg delete "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People\ContactPanel" /f >nul 2>nul
)
%UNREG% >nul 
echo.
echo   不使用桌面语言栏及不在开始菜单显示建议及关闭游戏录制 √
echo.
ping -n 3 127.1>nul

:YCSZ
echo   针对Win10 RS1以上系统的优化设置及针对Win10 RS5以下系统的纠错
echo.
echo   开始菜单等多项设置并启用最佳性能...
echo.
%SSREG% >nul
reg add "HKLM\0\Microsoft\Internet Explorer\Main" /v "Start Page" /t REG_SZ /d "%hp%" /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\RunOnce" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\Setup\State\RunOnce.cmd" /f >nul
reg add "HKLM\0\Microsoft\StigRegKey\typing\TaskbarAvoidanceEnabled" /v "Enabled" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v "UseActionCenterExperience" /t REG_DWORD /d 0 /f >nul
if %OFFSYS% LEQ 15063 (
reg add "HKLM\0\Microsoft\TabletTip\1.7" /v "TipbandDesiredVisibility" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\TabletTip\1.7" /v "EnableEmbeddedInkControl" /t REG_DWORD /d 1 /f >nul
)
%UNREG% >nul
%USREG% >nul
if %OFFSYS% GTR 15063 (
echo.
echo   修正RS3以上系统桌面图标可能出现的重叠问题
echo.
reg add "HKLM\0\Control Panel\Desktop\WindowMetrics" /v "IconSpacing" /t REG_SZ /d "-1125" /f >nul
reg add "HKLM\0\Control Panel\Desktop\WindowMetrics" /v "IconVerticalSpacing" /t REG_SZ /d "-1125" /f >nul
echo   针对RS3以上系统运行YCDISM使用旧版控制台
echo.
reg add "HKLM\0\Console" /v "CurrentPage" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Console" /v "ForceV2" /t REG_DWORD /d 0 /f >nul
echo   恢复旧版CMD窗口颜色显示
echo.
reg add "HKLM\0\Console" /v "ColorTable00" /t REG_DWORD /d 789516 /f >nul
reg add "HKLM\0\Console" /v "ColorTable01" /t REG_DWORD /d 14300928 /f >nul
reg add "HKLM\0\Console" /v "ColorTable02" /t REG_DWORD /d 958739 /f >nul
reg add "HKLM\0\Console" /v "ColorTable03" /t REG_DWORD /d 14521914 /f >nul
reg add "HKLM\0\Console" /v "ColorTable04" /t REG_DWORD /d 2035653 /f >nul
reg add "HKLM\0\Console" /v "ColorTable05" /t REG_DWORD /d 9967496 /f >nul
reg add "HKLM\0\Console" /v "ColorTable06" /t REG_DWORD /d 40129 /f >nul
reg add "HKLM\0\Console" /v "ColorTable07" /t REG_DWORD /d 13421772 /f >nul
reg add "HKLM\0\Console" /v "ColorTable08" /t REG_DWORD /d 7763574 /f >nul
reg add "HKLM\0\Console" /v "ColorTable09" /t REG_DWORD /d 16742459 /f >nul
reg add "HKLM\0\Console" /v "ColorTable10" /t REG_DWORD /d 837142 /f >nul
reg add "HKLM\0\Console" /v "ColorTable11" /t REG_DWORD /d 14079585 /f >nul
reg add "HKLM\0\Console" /v "ColorTable12" /t REG_DWORD /d 5654759 /f >nul
reg add "HKLM\0\Console" /v "ColorTable13" /t REG_DWORD /d 10354868 /f >nul
reg add "HKLM\0\Console" /v "ColorTable14" /t REG_DWORD /d 10875385 /f >nul
reg add "HKLM\0\Console" /v "ColorTable15" /t REG_DWORD /d 15921906 /f >nul
) ELSE (
reg add "HKLM\0\Microsoft\TabletTip\1.7" /v "TipbandDesiredVisibility" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\TabletTip\1.7" /v "EnableEmbeddedInkControl" /t REG_DWORD /d 1 /f >nul
)
echo.
echo   启用数字小键盘...
reg add "HKLM\0\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_SZ /d "2" /f >nul
reg add "HKLM\0\Control Panel\Keyboard" /v "KeyboardDelay" /t REG_SZ /d "1" /f >nul
reg add "HKLM\0\Control Panel\Keyboard" /v "KeyboardSpeed" /t REG_SZ /d "31" /f >nul
if %OFFSYS% GEQ 9600 (
if %OFFSYS% GEQ 15021 (
reg add "HKLM\0\Console" /v "FaceName" /t REG_SZ /d "新宋体" /f >nul
reg add "HKLM\0\Console\%%SystemRoot%%_System32_cmd.exe" /v "FaceName" /t REG_SZ /d "新宋体" /f >nul
reg add "HKLM\0\Console\%%SystemRoot%%_System32_WindowsPowerShell_v1.0_powershell.exe" /v "FaceName" /t REG_SZ /d "新宋体" /f >nul
if %Mbt% EQU x64 reg add "HKLM\0\Console\%%SystemRoot%%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" /v "FaceName" /t REG_SZ /d "新宋体" /f >nul
)
reg add "HKLM\0\Console" /v "ScreenBufferSize" /t REG_DWORD /d 2752632 /f >nul
reg add "HKLM\0\Console" /v "ScreenColors" /t REG_DWORD /d 31 /f >nul
reg add "HKLM\0\Console" /v "WindowAlpha" /t REG_DWORD /d 206 /f >nul
reg add "HKLM\0\Console" /v "WindowPosition" /t REG_DWORD /d 1966280 /f >nul
reg add "HKLM\0\Console" /v "WindowSize" /t REG_DWORD /d 1966200 /f >nul
reg add "HKLM\0\Console\%%SystemRoot%%_System32_cmd.exe" /v "ScreenBufferSize" /t REG_DWORD /d 2752632 /f >nul
reg add "HKLM\0\Console\%%SystemRoot%%_System32_cmd.exe" /v "ScreenColors" /t REG_DWORD /d 31 /f >nul
reg add "HKLM\0\Console\%%SystemRoot%%_System32_cmd.exe" /v "WindowAlpha" /t REG_DWORD /d 206 /f >nul
reg add "HKLM\0\Console\%%SystemRoot%%_System32_cmd.exe" /v "WindowPosition" /t REG_DWORD /d 1966280 /f >nul
reg add "HKLM\0\Console\%%SystemRoot%%_System32_cmd.exe" /v "WindowSize" /t REG_DWORD /d 1966200 /f >nul
reg add "HKLM\0\Keyboard Layout\Preload" /v "1" /t REG_SZ /d "00000409" /f >nul
reg add "HKLM\0\Keyboard Layout\Preload" /v "2" /t REG_SZ /d "00000804" /f >nul
reg add "HKLM\0\Keyboard Layout\Toggle" /v "Hotkey" /t REG_SZ /d "2" /f >nul
reg add "HKLM\0\Keyboard Layout\Toggle" /v "Language Hotkey" /t REG_SZ /d "2" /f >nul
reg add "HKLM\0\Keyboard Layout\Toggle" /v "Layout Hotkey" /t REG_SZ /d "3" /f >nul
reg add "HKLM\0\Control Panel\International\User Profile" /v "Languages" /t REG_MULTI_SZ /d "en-US zh-Hans-CN" /f >nul
reg add "HKLM\0\Control Panel\International\User Profile\en-US" /v "0409:00000409" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Control Panel\International\User Profile\zh-Hans-CN" /v "0804:00000804" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Control Panel\International\User Profile System Backup" /v "Languages" /t REG_MULTI_SZ /d "en-US zh-Hans-CN" /f >nul
reg add "HKLM\0\Control Panel\International\User Profile System Backup\en-US" /v "0409:00000409" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Control Panel\International\User Profile System Backup\zh-Hans-CN" /v "0804:00000804" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\CTF\Assemblies\0x00000409\{34745C63-B2F0-4784-8B67-5E12C8701A31}" /v "Default" /t REG_SZ /d "{00000000-0000-0000-0000-000000000000}" /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\CTF\Assemblies\0x00000409\{34745C63-B2F0-4784-8B67-5E12C8701A31}" /v "KeyboardLayout" /t REG_DWORD /d "67699721" /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\CTF\Assemblies\0x00000409\{34745C63-B2F0-4784-8B67-5E12C8701A31}" /v "Profile" /t REG_SZ /d "{00000000-0000-0000-0000-000000000000}" /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\CTF\Assemblies\0x00000804\{34745C63-B2F0-4784-8B67-5E12C8701A31}" /v "Default" /t REG_SZ /d "{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}" /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\CTF\Assemblies\0x00000804\{34745C63-B2F0-4784-8B67-5E12C8701A31}" /v "KeyboardLayout" /t REG_DWORD /d "134481924" /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\CTF\Assemblies\0x00000804\{34745C63-B2F0-4784-8B67-5E12C8701A31}" /v "Profile" /t REG_SZ /d "{FA550B04-5AD7-411F-A5AC-CA038EC515D7}" /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\CTF\LangBar" /v "ExtraIconsOnMinimized" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\CTF\LangBar" /v "Label" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\CTF\LangBar" /v "ShowStatus" /t REG_DWORD /d 4 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\CTF\LangBar" /v "Transparency" /t REG_DWORD /d 255 /f >nul
reg add "HKLM\0\Software\Microsoft\CTF\SortOrder\AssemblyItem\0x00000409\{34745C63-B2F0-4784-8B67-5E12C8701A31}\00000000" /v "CLSID" /t REG_SZ /d "{00000000-0000-0000-0000-000000000000}" /f >nul
reg add "HKLM\0\Software\Microsoft\CTF\SortOrder\AssemblyItem\0x00000409\{34745C63-B2F0-4784-8B67-5E12C8701A31}\00000000" /v "KeyboardLayout" /t REG_DWORD /d 67699721 /f >nul
reg add "HKLM\0\Software\Microsoft\CTF\SortOrder\AssemblyItem\0x00000409\{34745C63-B2F0-4784-8B67-5E12C8701A31}\00000000" /v "Profile" /t REG_SZ /d "{00000000-0000-0000-0000-000000000000}" /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\CTF\SortOrder\AssemblyItem\0x00000804\{34745C63-B2F0-4784-8B67-5E12C8701A31}\00000000" /v "CLSID" /t REG_SZ /d "{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}" /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\CTF\SortOrder\AssemblyItem\0x00000804\{34745C63-B2F0-4784-8B67-5E12C8701A31}\00000000" /v "KeyboardLayout" /t REG_DWORD /d 134481924 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\CTF\SortOrder\AssemblyItem\0x00000804\{34745C63-B2F0-4784-8B67-5E12C8701A31}\00000000" /v "Profile" /t REG_SZ /d "{FA550B04-5AD7-411F-A5AC-CA038EC515D7}" /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\CTF\SortOrder\Language" /v "00000000" /t REG_SZ /d "00000409" /f >nul
reg add "HKLM\0\Software\Microsoft\CTF\TIP\{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}\LanguageProfile\0x00000804\{FA550B04-5AD7-411F-A5AC-CA038EC515D7}" /v "Enable" /t REG_DWORD /d 1 /f >nul
)
if %OFFSYS% GTR 7601 (
reg add "HKLM\0\Software\Microsoft\Internet Explorer\MINIE" /v "ShowTabsBelowAddressBar" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "AlwaysShowMenu" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "AutoCheckSelect" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DontPrettyPath" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisablePreviewDesktop" /t REG_DWORD /d 0 /f >nul
if %OFFSYS% GEQ 10240 reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DontUsePowerShellOnWinX" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Filter" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 2 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideIcons" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "IconsOnly" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "MapNetDrvBtn" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SeparateProcess" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ServerAdminUI" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_SearchFiles" /t REG_DWORD /d 2 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCompColor" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowInfoTip" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowStatusBar" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTypeOverlay" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_NotifyNewApps" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StartMenuInit" /t REG_DWORD /d 4 /f >nul
if %OFFSYS% GEQ 10240 reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StoreAppsOnTaskbar" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_ShowRun" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_AdminToolsRoot" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StartMenuAdminTools" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_LargeMFUIcons" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_MinMFU" /t REG_DWORD /d 10 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_JumpListItems" /t REG_DWORD /d 10 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_PowerButtonAction" /t REG_DWORD /d 2 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSizeMove" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSmallIcons" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarGlomLevel" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "WebView" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSecondsInSystemClock" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "DesktopProcess" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ExplorerStartupTraceRecorded" /t REG_DWORD /d 1 /f >nul
)
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t REG_BINARY /d "00000000" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "Start Page" /t REG_SZ /d "%hp%" /f >nul
if %OFFSYS% GEQ 10240 reg add "HKLM\0\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" /v "HomeButtonPage" /t REG_SZ /d "%hp%" /f >nul
if %OFFSYS% GEQ 10240 reg add "HKLM\0\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" /v "HomeButtonEnabled" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "Default_Page_URL" /t REG_SZ /d "%hp%" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "UseClearType" /t REG_SZ /d "yes" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "DisableFirstRunCustomize" /t REG_DWORD /d 1 /f >nul
echo.
echo   为 Internet Explorer 添加并启用CSS样式屏蔽常见广告...
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Styles" /v "User Stylesheet" /t REG_EXPAND_SZ /d "%%windir%%\Setup\ad.css" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Styles" /v "Use My Stylesheet" /t REG_DWORD /d 1 /f >nul
%UNREG% >nul
Xcopy /y %YCP%MY\ad.css %MOU%\Windows\Setup\ >nul
echo.
echo   无人值守及所有通用化设置完成固化       程序返回主菜单
echo.
ping -n 6 127.1>nul
cls
goto MENU

:SDJJ
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% 完美适度精简 %dqcd%23
echo.
echo   %dqwz% 完美适度精简 %dqcd%23
echo.
echo  00  移除WinSxS中产生的临时数据...
echo.
if exist "%MOU%\Windows\System32\en-US\Licenses\_Default\%MEID%\license.rtf" Xcopy /y "%MOU%\Windows\System32\en-US\Licenses\_Default\%MEID%\license.rtf" %MOU%\Windows\System32\
if exist "%MOU%\Windows\System32\en-US\Licenses\Volume\%MEID%\license.rtf" Xcopy /y "%MOU%\Windows\System32\en-US\Licenses\Volume\%MEID%\license.rtf" %MOU%\Windows\System32\
if exist "%MOU%\Windows\System32\zh-CN\Licenses\_Default\%MEID%\license.rtf" (
Xcopy /y "%MOU%\Windows\System32\zh-CN\Licenses\_Default\%MEID%\license.rtf" %MOU%\Windows\System32\
) ELSE (
Xcopy /y "%MOU%\Windows\System32\zh-CN\Licenses\Volume\%MEID%\license.rtf" %MOU%\Windows\System32\
)
if exist "%MOU%\Windows\System32\zh-TW\Licenses\_Default\%MEID%\license.rtf" (
Xcopy /y "%MOU%\Windows\System32\zh-TW\Licenses\_Default\%MEID%\license.rtf" %MOU%\Windows\System32\
) ELSE (
Xcopy /y "%MOU%\Windows\System32\zh-TW\Licenses\Volume\%MEID%\license.rtf" %MOU%\Windows\System32\
)
if exist "%MOU%\Windows\System32\zh-HK\Licenses\_Default\%MEID%\license.rtf" (
Xcopy /y "%MOU%\Windows\System32\zh-HK\Licenses\_Default\%MEID%\license.rtf" %MOU%\Windows\System32\
) ELSE (
Xcopy /y "%MOU%\Windows\System32\zh-HK\Licenses\Volume\%MEID%\license.rtf" %MOU%\Windows\System32\
)
if exist "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell" (
cmd.exe /c takeown /f "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell" /r /d y && icacls "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell"
)
if exist "%MOU%\ProgramData\Microsoft\Windows Live" (
cmd.exe /c takeown /f "%MOU%\ProgramData\Microsoft\Windows Live" /r /d y && icacls "%MOU%\ProgramData\Microsoft\Windows Live" /grant administrators:F /t
RMDIR /S /Q "%MOU%\ProgramData\Microsoft\Windows Live"
)
if exist "%MOU%\Logs" (
cmd.exe /c takeown /f "%MOU%\Logs" /r /d y && icacls "%MOU%\Logs" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Logs"
)
if exist %MOU%\Windows\WinSxS\ManifestCache (
cmd.exe /c takeown /f "%MOU%\Windows\WinSxS\ManifestCache" /r /d y && icacls "%MOU%\Windows\WinSxS\ManifestCache" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\WinSxS\ManifestCache"
)
if exist %MOU%\Users\Administrator\Favorites (
cmd.exe /c takeown /f "%MOU%\Users\Administrator\Favorites" /r /d y && icacls "%MOU%\Users\Administrator\Favorites" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Users\Administrator\Favorites"
Rd /S /Q "%MOU%\Users\Administrator\Favorites"
cmd.exe /c takeown /f "%MOU%\Users\Public\Recorded TV\Sample Media" /r /d y && icacls "%MOU%\Users\Public\Recorded TV\Sample Media" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Users\Public\Recorded TV\Sample Media"
cmd.exe /c takeown /f "%MOU%\Users\Public\Videos\Sample Videos" /r /d y && icacls "%MOU%\Users\Public\Videos\Sample Videos" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Users\Public\Videos\Sample Videos"
cmd.exe /c takeown /f "%MOU%\Users\Public\Music\Sample Music" /r /d y && icacls "%MOU%\Users\Public\Music\Sample Music" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Users\Public\Music\Sample Music"
cmd.exe /c takeown /f "%MOU%\Users\Public\Pictures" /r /d y && icacls "%MOU%\Users\Public\Pictures" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Users\Public\Pictures"
)
echo.
echo  01  移除BACKUP数据...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\WinSxS\Backup" /r /d y && icacls "%MOU%\Windows\WinSxS\Backup" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\WinSxS\Backup"
if exist "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Windows Defender.lnk" del /q /f "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Windows Defender.lnk"
if exist "%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\System Tools\Windows Defender.lnk" del /q /f "%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\System Tools\Windows Defender.lnk"
if exist "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\SendTo\Compressed (zipped) Folder.ZFSendToTarget" del /q /f "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\SendTo\Compressed (zipped) Folder.ZFSendToTarget"
cmd.exe /c takeown /f "%MOU%\Windows\Setup" /r /d y && icacls "%MOU%\Windows\Setup" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\Branding\Shellbrd" /r /d y && icacls "%MOU%\Windows\Branding\Shellbrd" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\PerfLogs" /r /d y && icacls "%MOU%\PerfLogs" /grant administrators:F /t
RD /Q /S "%MOU%\PerfLogs"
RMDIR /S /Q "%MOU%\Users\Default\Links"
del /q /f "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Help.lnk"
del /q /f "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Windows.Defender.lnk"
echo.
echo  02  移除英文简中以外自然语言及多余输入法数据...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\IME" /r /d y && icacls "%MOU%\Windows\IME" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\IME\IMEJP" /r /d y && icacls "%MOU%\Windows\IME\IMEJP" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\IME\IMEKR" /r /d y && icacls "%MOU%\Windows\IME\IMEKR" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\IME\IMETC" /r /d y && icacls "%MOU%\Windows\IME\IMETC" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\IME\IMEJP"
RMDIR /S /Q "%MOU%\Windows\IME\IMEKR"
RMDIR /S /Q "%MOU%\Windows\IME\IMETC"
cmd.exe /c takeown /f "%MOU%\Windows\System32\IME" /r /d y && icacls "%MOU%\Windows\System32\IME" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\System32\IME\IMEJP" /r /d y && icacls "%MOU%\Windows\System32\IME\IMEJP" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\System32\IME\IMEKR" /r /d y && icacls "%MOU%\Windows\System32\IME\IMEKR" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\System32\IME\IMETC" /r /d y && icacls "%MOU%\Windows\System32\IME\IMETC" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\IME\IMEJP"
RMDIR /S /Q "%MOU%\Windows\System32\IME\IMEKR"
RMDIR /S /Q "%MOU%\Windows\System32\IME\IMETC"
if %OFFSYS% LEQ 7601 (
RMDIR /S /Q "%MOU%\Windows\System32\IME\IMEJP10"
RMDIR /S /Q "%MOU%\Windows\System32\IME\imekr8"
RMDIR /S /Q "%MOU%\Windows\System32\IME\IMETC10"
RMDIR /S /Q "%MOU%\Windows\IME\IMEJP10"
RMDIR /S /Q "%MOU%\Windows\IME\imekr8"
RMDIR /S /Q "%MOU%\Windows\IME\IMETC10"
)
cmd.exe /c takeown /f "%MOU%\Windows\InputMethod" /r /d y && icacls "%MOU%\Windows\InputMethod" /grant administrators:F /t
if exist "%MOU%\Windows\zh-CN" RMDIR /S /Q "%MOU%\Windows\InputMethod\CHT"
RMDIR /S /Q "%MOU%\Windows\InputMethod\JPN"
RMDIR /S /Q "%MOU%\Windows\InputMethod\KOR"
cmd.exe /c takeown /f "%MOU%\Windows\System32\InputMethod" /r /d y && icacls "%MOU%\Windows\System32\InputMethod" /grant administrators:F /t
if exist "%MOU%\Windows\zh-CN" RMDIR /S /Q "%MOU%\Windows\System32\InputMethod\CHT"
RMDIR /S /Q "%MOU%\Windows\System32\InputMethod\JPN"
RMDIR /S /Q "%MOU%\Windows\System32\InputMethod\KOR"
sif exist %MOU%\Windows\SysWOW64 (
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\IME" /r /d y && icacls "%MOU%\Windows\SysWOW64\IME" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\IME\IMEJP"
RMDIR /S /Q "%MOU%\Windows\SysWOW64\IME\IMEKR"
RMDIR /S /Q "%MOU%\Windows\SysWOW64\IME\IMETC"
RMDIR /S /Q "%MOU%\Windows\SysWOW64\IME\IMEJP10"
RMDIR /S /Q "%MOU%\Windows\SysWOW64\IME\imekr8"
RMDIR /S /Q "%MOU%\Windows\SysWOW64\IME\IMETC10"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\InputMethod" /r /d y && icacls "%MOU%\Windows\SysWOW64\InputMethod" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\InputMethod\JPN"
for /f %%i in ('dir /ad /b %MOU%\Windows\SysWOW64\*-*') do echo %%i |findstr /i "en-US zh-CN zh-HANS" || (cmd.exe /c takeown /f %MOU%\Windows\SysWOW64\%%i /r /d y & icacls %MOU%\Windows\SysWOW64\%%i /grant administrators:f /t & rd %MOU%\Windows\SysWOW64\%%i /s /q)
)
cmd.exe /c takeown /f "%MOU%\Program Files\Common Files\microsoft shared\ink" /r /d y && icacls "%MOU%\Program Files\Common Files\microsoft shared\ink" /grant administrators:F /t
del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\mshwchsr.dll"
del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\mraut.dll"
del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\chslm.wdic2.bin"
del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\hwrusash.dat"
del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\hwrusalm.dat"
del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\hwruksh.dat"
del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\micaut.dll"
del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\hwruklm.dat"
del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\FlickAnimation.avi"
del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\hwrusash.dat"
for /f %%i in ('dir /ad /b "%MOU%\Program Files\Common Files\microsoft shared\ink\*-*"') do echo %%i |findstr /i "en-US zh-CN" || (cmd.exe /c takeown /f "%MOU%\Program Files\Common Files\microsoft shared\ink\%%i" /r /d y & icacls "%MOU%\Program Files\Common Files\microsoft shared\ink\%%i" /grant administrators:f /t & rd "%MOU%\Program Files\Common Files\microsoft shared\ink\%%i" /s /q)
for /f %%i in ('dir /ad /b %MOU%\Windows\System32\*-*') do echo %%i |findstr /i "en-US zh-CN zh-HANS" || (cmd.exe /c takeown /f %MOU%\Windows\System32\%%i /r /d y & icacls %MOU%\Windows\System32\%%i /grant administrators:f /t & rd %MOU%\Windows\System32\%%i /s /q)
echo.
echo  04 性能体验相关...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\Performance\WinSAT" /r /d y && icacls "%MOU%\Windows\Performance\WinSAT" /grant administrators:F /t
del /q /f %MOU%\Windows\Performance\WinSAT\*.mpg
del /q /f %MOU%\Windows\Performance\WinSAT\*.wmv
del /q /f %MOU%\Windows\Performance\WinSAT\*.mp4
echo.
echo  05 删除高对比度主题及4K...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\ReSources" /r /d y && icacls "%MOU%\Windows\ReSources" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\Resources\Themes" /r /d y && icacls "%MOU%\Windows\Resources\Themes" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\Resources\Maps" /r /d y && icacls "%MOU%\Windows\Resources\Maps" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\Resources\Maps"
cmd.exe /c takeown /f "%MOU%\Windows\Resources\Ease of Access Themes" /r /d y && icacls "%MOU%\Windows\Resources\Ease of Access Themes" /grant administrators:F /t
IF exist "%MOU%\Windows\Resources\Ease of Access Themes\hc1.theme" del /q /f "%MOU%\Windows\Resources\Ease of Access Themes\hc1.theme"
IF exist "%MOU%\Windows\Resources\Ease of Access Themes\hc2.theme" del /q /f "%MOU%\Windows\Resources\Ease of Access Themes\hc2.theme"
IF exist "%MOU%\Windows\Resources\Ease of Access Themes\hcblack.theme" del /q /f "%MOU%\Windows\Resources\Ease of Access Themes\hcblack.theme"
IF exist "%MOU%\Windows\Resources\Ease of Access Themes\hcwhite.theme" del /q /f "%MOU%\Windows\Resources\Ease of Access Themes\hcwhite.theme"
IF not exist "%MOU%\Windows\Resources\Ease of Access Themes\*.theme" RD /S /Q "%MOU%\Windows\Resources\Ease of Access Themes"
cmd.exe /c takeown /f "%MOU%\Windows\Web" /r /d y && icacls "%MOU%\Windows\Web" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\Web\4K" /r /d y && icacls "%MOU%\Windows\Web\4K" /grant administrators:F /t
echo.
echo  06 删除多余的屏保...
echo.
del /q /f %MOU%\Windows\Web\Screen\img101.png
del /q /f %MOU%\Windows\Web\Screen\img102.jpg
del /q /f %MOU%\Windows\Web\Screen\img103.png
del /q /f %MOU%\Windows\Web\Screen\img104.jpg
del /q /f %MOU%\Windows\Web\Screen\img105.jpg
if exist %MOU%\Users\Administrator\AppData\Roaming\Microsoft\Windows\Themes\TranscodedWallpaper.jpg (
cmd.exe /c takeown /f MOU%\Users\Administrator\AppData\Roaming\Microsoft\Windows\Themes\TranscodedWallpaper.jpg && icacls %MOU%\Users\Administrator\AppData\Roaming\Microsoft\Windows\Themes\TranscodedWallpaper.jpg /grant administrators:F /t
copy /y %YCP%MY\IMG\img0.jpg %MOU%\Users\Administrator\AppData\Roaming\Microsoft\Windows\Themes\TranscodedWallpaper.jpg
)
echo.
echo  07 移除多余的设备锁数据...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\BitLockerDiscoveryVolumeContents" /r /d y && icacls "%MOU%\Windows\BitLockerDiscoveryVolumeContents" /grant administrators:F /t
if not exist %YCP%BTG md %YCP%BTG
Xcopy /y /h %MOU%\Windows\BitLockerDiscoveryVolumeContents\autorun.inf %YCP%BTG
Xcopy /y /h %MOU%\Windows\BitLockerDiscoveryVolumeContents\BitLockerToGo.exe %YCP%BTG
Xcopy /y /h %MOU%\Windows\BitLockerDiscoveryVolumeContents\en-US_BitLockerToGo.exe.mui %YCP%BTG
Xcopy /y /h "%MOU%\Windows\BitLockerDiscoveryVolumeContents\Read Me.url" %YCP%BTG
Xcopy /y /h %MOU%\Windows\BitLockerDiscoveryVolumeContents\zh-CN_BitLockerToGo.exe.mui %YCP%BTG
RMDIR /S /Q "%MOU%\Windows\BitLockerDiscoveryVolumeContents"
del /q /f %MOU%\Windows\BitLockerDiscoveryVolumeContents\*.*
if not exist %MOU%\Windows\BitLockerDiscoveryVolumeContents md %MOU%\Windows\BitLockerDiscoveryVolumeContents
Xcopy /y /h "%YCP%BTG\*.*" %MOU%\Windows\BitLockerDiscoveryVolumeContents\ &&attrib +s +h %MOU%\Windows\BitLockerDiscoveryVolumeContents
RMDIR /S /Q "%YCP%BTG"
if exist %MOU%\Windows\Globalization (
echo.
echo   08 移除自带中国壁纸主题...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\Globalization\MCT\MCT-CN" /r /d y && icacls "%MOU%\Windows\Globalization\MCT\MCT-CN" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\Globalization\MCT\MCT-CN"
)
if exist "%MOU%\Program Files\Microsoft Games" (
echo.
echo   09 移除游戏数据...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\Globalization\MCT\MCT-CN" /r /d y && icacls "%MOU%\Windows\Globalization\MCT\MCT-CN" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\Globalization\MCT\MCT-CN"
for /f %%i in ('dir /ad /b "%MOU%\Program Files\Microsoft Games\*"') do echo %%i |findstr /i "Solitaire" || (cmd.exe /c takeown /f "%MOU%\Program Files\Microsoft Games\%%i" /r /d y & icacls "%MOU%\Program Files\Microsoft Games\%%i" /grant administrators:f /t & rd "%MOU%\Program Files\Microsoft Games\%%i" /s /q)
)
if exist "%MOU%\Program Files\DVD Maker" (
echo.
echo   10 移除DVD Maker中的数据...
echo.
cmd.exe /c takeown /f "%MOU%\Program Files\DVD Maker" /r /d y && icacls "%MOU%\Program Files\DVD Maker" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Program Files\DVD Maker"
)
echo.
echo   11 删除无用的屏保...
echo.
cmd.exe /c takeown /f %MOU%\Windows\System32\Mystify.scr && icacls %MOU%\Windows\System32\Mystify.scr /grant administrators:F /t 2>nul
cmd.exe /c takeown /f %MOU%\Windows\System32\Ribbons.scr && icacls %MOU%\Windows\System32\Ribbons.scr /grant administrators:F /t 2>nul
cmd.exe /c takeown /f %MOU%\Windows\System32\ssText3d.scr && icacls %MOU%\Windows\System32\ssText3d.scr /grant administrators:F /t 2>nul
cmd.exe /c takeown /f %MOU%\Windows\System32\scrnsave.scr && icacls %MOU%\Windows\System32\scrnsave.scr /grant administrators:F /t 2>nul
cmd.exe /c takeown /f %MOU%\Windows\System32\Bubbles.scr && icacls %MOU%\Windows\System32\Bubbles.scr /grant administrators:F /t 2>nul
for /r %MOU%\Windows\System32 %%i in (Mystify.scr Ribbons.scr ssText3d.scr scrnsave.scr Bubbles.scr) do (if exist %%i del "%%i" /q /f )
if exist %MOU%\Windows\SysWOW64 (
cmd.exe /c takeown /f %MOU%\Windows\SysWOW64\Mystify.scr && icacls %MOU%\Windows\SysWOW64\Mystify.scr /grant administrators:F /t 2>nul
cmd.exe /c takeown /f %MOU%\Windows\SysWOW64\Ribbons.scr && icacls %MOU%\Windows\SysWOW64\Ribbons.scr /grant administrators:F /t 2>nul
cmd.exe /c takeown /f %MOU%\Windows\SysWOW64\ssText3d.scr && icacls %MOU%\Windows\SysWOW64\ssText3d.scr /grant administrators:F /t 2>nul
cmd.exe /c takeown /f %MOU%\Windows\SysWOW64\scrnsave.scr && icacls %MOU%\Windows\SysWOW64\scrnsave.scr /grant administrators:F /t 2>nul
cmd.exe /c takeown /f %MOU%\Windows\SysWOW64\Bubbles.scr && icacls %MOU%\Windows\SysWOW64\Bubbles.scr /grant administrators:F /t 2>nul
for /r %MOU%\Windows\SysWOW64 %%i in (Mystify.scr Ribbons.scr ssText3d.scr scrnsave.scr Bubbles.scr) do (if exist %%i del "%%i" /q /f )
)
if exist %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\ExpandedDefaultLayouts.xml (
echo.
echo   12 去开始屏推广...
echo.
cmd.exe /c takeown /f %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\ExpandedDefaultLayouts.xml && icacls %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\ExpandedDefaultLayouts.xml /grant administrators:F /t
del /f /q %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\ExpandedDefaultLayouts.xml
Xcopy /y %YCP%MY\DefaultLayouts.xml %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\ExpandedDefaultLayouts.xml
)
if exist %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml (
cmd.exe /c takeown /f %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml && icacls %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml /grant administrators:F /t
del /f /q %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml
Copy /y %YCP%MY\DefaultLayouts.xml %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\
)
if exist %MOU%\Windows\SystemApps\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\Experiences\LockScreen\asset.jpg (
echo.
echo   13 替换默认APP锁屏壁纸...
echo.
cmd.exe /c takeown /f %MOU%\Windows\SystemApps\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\Experiences\LockScreen\asset.jpg && icacls %MOU%\Windows\SystemApps\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\Experiences\LockScreen\asset.jpg /grant administrators:F /t
Copy /y %YCP%MY\IMG\asset.jpg %MOU%\Windows\SystemApps\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\Experiences\LockScreen\
)
echo.
echo   14 清理一些无用的启动显示字体...
echo.
set File=%MOU%\Windows\Boot\Fonts
cmd.exe /c takeown /f "%MOU%\Windows\Boot\Fonts" /r /d y && icacls "%MOU%\Windows\Boot\Fonts" /grant administrators:F /t
for /f %%i in ('dir /a-d /b %File%\*_*.ttf') do echo %%i |findstr /i "chs_boot cht_boot msjh_boot msjhn_boot wgl4_boot msyh seg" || (cmd.exe /c takeown /f %File%\%%i /r /d y & icacls %File%\%%i /grant administrators:f /t & del %File%\%%i /f /q)
set File=%MOU%\Windows\Boot\PCAT
cmd.exe /c takeown /f "%MOU%\Windows\Boot\PCAT" /r /d y && icacls "%MOU%\Windows\Boot\PCAT" /grant administrators:F /t
for /f %%i in ('dir /ad /b %File%\*-*') do echo %%i |findstr /i "en-US zh-CN" || (cmd.exe /c takeown /f %File%\%%i /r /d y & icacls %File%\%%i /grant administrators:f /t & rd %File%\%%i /s /q)
set File=%MOU%\Windows\Boot\EFI
cmd.exe /c takeown /f "%MOU%\Windows\Boot\EFI" /r /d y && icacls "%MOU%\Windows\Boot\EFI" /grant administrators:F /t
for /f %%i in ('dir /ad /b %File%\*-*') do echo %%i |findstr /i "en-US zh-CN" || (cmd.exe /c takeown /f %File%\%%i /r /d y & icacls %File%\%%i /grant administrators:f /t & rd %File%\%%i /s /q)
set File=%MOU%\Windows\Boot\PXE
cmd.exe /c takeown /f "%MOU%\Windows\Boot\PXE" /r /d y && icacls "%MOU%\Windows\Boot\PXE" /grant administrators:F /t
for /f %%i in ('dir /ad /b %File%\*-*') do echo %%i |findstr /i "en-US zh-CN" || (cmd.exe /c takeown /f %File%\%%i /r /d y & icacls %File%\%%i /grant administrators:f /t & rd %File%\%%i /s /q)
set File=%MOU%\Windows\Boot\Resources
cmd.exe /c takeown /f "%MOU%\Windows\Boot\Resources" /r /d y && icacls "%MOU%\Windows\Boot\Resources" /grant administrators:F /t
for /f %%i in ('dir /ad /b %File%\*-*') do echo %%i |findstr /i "en-US zh-CN" || (cmd.exe /c takeown /f %File%\%%i /r /d y & icacls %File%\%%i /grant administrators:f /t & rd %File%\%%i /s /q)
if exist %MOU%\Windows\Help (
echo.
echo   15 精简帮助 HELP 数据...
echo.
cmd.exe /c takeown /f %MOU%\Windows\HelpPane.exe && icacls %MOU%\Windows\HelpPane.exe /grant administrators:F /t
del /f /q %MOU%\Windows\HelpPane.exe
cmd.exe /c takeown /f "%MOU%\Windows\Help" /r /d y && icacls "%MOU%\Windows\Help" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\Help"
)
if %OFFSYS% GEQ 14393 (
echo.
echo   16 为1703以上补充清理部分数据...
echo.
cmd.exe /c takeown /f "%MOU%\Program Files\Windows Security" /r /d y && icacls "%MOU%\Program Files\Windows Security" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Program Files\Windows Security"
cmd.exe /c takeown /f "%MOU%\ProgramData\WindowsHolographicDevices" /r /d y && icacls "%MOU%\ProgramData\WindowsHolographicDevices" /grant administrators:F /t
RMDIR /S /Q "%MOU%\ProgramData\WindowsHolographicDevices"
cmd.exe /c takeown /f "%MOU%\ProgramData\Microsoft\Storage Health" /r /d y && icacls "%MOU%\ProgramData\Microsoft\Storage Health" /grant administrators:F /t
RMDIR /S /Q "%MOU%\ProgramData\Microsoft\Storage Health"
)
if exist %MOU%\Windows\UpdateAssistantV2\Windows10Upgrade.exe (
echo.
echo   去掉集成累积更新后加入的跨版本升级程序
echo.
RMDIR /S /Q "%MOU%\Windows\UpdateAssistantV2"
)
title  %dqwc% 完美适度精简 %dqcd%23
echo.
echo        通用的适度完美精简已完成                   程序返回主菜单
echo.
ping -n 5 127.1 >nul
cls
goto MENU

:ZDJJ
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% 正式版系统进行驱动+虚链接极限精简 %dqcd%28 
echo.
echo  %dqwz% 正式版系统进行驱动+虚链接极限精简 %dqcd%28  
echo.
echo   1  精简稀用驱动及虚链数据以减小体积 基本不影响驱动安装  处理时间较长请耐心等待
echo.
echo        收集数据过程CPU和内存占用较大  如无必要请勿做其它工作 开始收集相关数据...
echo.
echo   2 主要采用MS原生ISO中 boot.wim 中的驱动替换  影响桌面体验 只推荐做极限精简测试  
echo.
echo        确认要执行操作并且所需条件满足       请回车开始执行终极安全极限驱动精简
echo.
echo  *** 需要注意的是：装载ISO状态直接执行否则请提取ISO\Sources\boot.wim 到 %YCP% ***
echo.
set frfa=1
set /p frfa=请选择你要使用的驱动精简方案1或2 直接默认1方案返回请按0回车：
if "%frfa%"=="2" goto BTFR
if "%frfa%"=="1" goto SFFR
if "%frfa%"=="0" goto MENU

:SFFR
title  %dqwz% 正式版系统进行驱动极限精简 %dqcd%28-1
cls
echo.
echo   1  精简稀用驱动及虚链数据以减小体积 基本不影响驱动安装  处理时间较长请耐心等待
echo.
echo        收集数据过程CPU和内存占用较大  如无必要请勿做其它工作 开始收集相关数据...
echo.
echo   第一阶段  收集精简稀用驱动后的保留数据
echo.
if exist %YCP%FileRepository (RMDIR /S /Q "%YCP%FileRepository") ELSE (md %YCP%FileRepository )
if not exist %YCP%FileRepository md %YCP%FileRepository
dir /b /ad "%MOU%\Windows\System32\DriverStore\FileRepository">%YCP%tmp.txt
set yd=%MOU%\Windows\System32\DriverStore\FileRepository
findstr /i /V /C:"1394." "%YCP%tmp.txt"|findstr /i /V /C:"61883."|findstr /i /V /C:"acpi"|findstr /i /V /C:"adp"|findstr /i /V /C:"af9035bda." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"agp." "%YCP%tmp.txt"|findstr /i /V /C:"amds"|findstr /i /V /C:"angel"|findstr /i /V /C:"arc"|findstr /i /V /C:"ati" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"avc." "%YCP%tmp.txt"|findstr /i /V /C:"aver"|findstr /i /V /C:"avmx64c."|findstr /i /V /C:"battery."|findstr /i /V /C:"bda." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"blbdrive." "%YCP%tmp.txt"|findstr /i /V /C:"brmf"|findstr /i /V /C:"bth"|findstr /i /V /C:"cdrom."|findstr /i /V /C:"circlass." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"compositebus." "%YCP%tmp.txt"|findstr /i /V /C:"cpu."|findstr /i /V /C:"crcdisk."|findstr /i /V /C:"cxfa"|findstr /i /V /C:"dc21x4vm." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"digitalmediadevice." "%YCP%tmp.txt"|findstr /i /V /C:"disk."|findstr /i /V /C:"display."|findstr /i /V /C:"divac"|findstr /i /V /C:"dot4" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"eaphost." "%YCP%tmp.txt"|findstr /i /V /C:"ehstor"|findstr /i /V /C:"elxstor."|findstr /i /V /C:"faxc"|findstr /i /V /C:"fdc." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"flpydisk." "%YCP%tmp.txt"|findstr /i /V /C:"gameport."|findstr /i /V /C:"hal."|findstr /i /V /C:"hcw"|findstr /i /V /C:"hdaud" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"hid" "%YCP%tmp.txt"|findstr /i /V /C:"hpoa1"|findstr /i /V /C:"hpsamd."|findstr /i /V /C:"iastorv."|findstr /i /V /C:"igdlh." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"iirsp." "%YCP%tmp.txt"|findstr /i /V /C:"iirsp2."|findstr /i /V /C:"image."|findstr /i /V /C:"input."|findstr /i /V /C:"ipmidrv." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"iscsi." "%YCP%tmp.txt"|findstr /i /V /C:"keyboard."|findstr /i /V /C:"ks."|findstr /i /V /C:"kscaptur."|findstr /i /V /C:"ksfilter." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"lsi_" "%YCP%tmp.txt"|findstr /i /V /C:"machine."|findstr /i /V /C:"mchgr."|findstr /i /V /C:"mcx2."|findstr /i /V /C:"mdmbtmdm." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"megasas" "%YCP%tmp.txt"|findstr /i /V /C:"megasr."|findstr /i /V /C:"memory."|findstr /i /V /C:"mf."|findstr /i /V /C:"modemcsa." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"monitor." "%YCP%tmp.txt"|findstr /i /V /C:"mpio."|findstr /i /V /C:"msclmd."|findstr /i /V /C:"msdri."|findstr /i /V /C:"msdsm." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"msdv." "%YCP%tmp.txt"|findstr /i /V /C:"mshdc."|findstr /i /V /C:"msmouse."|findstr /i /V /C:"msports."|findstr /i /V /C:"mstape." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"mtconfig." "%YCP%tmp.txt"|findstr /i /V /C:"multiprt."|findstr /i /V /C:"net"|findstr /i /V /C:"nfrd960."|findstr /i /V /C:"ntprint." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"nulhpopr." "%YCP%tmp.txt"|findstr /i /V /C:"nvraid."|findstr /i /V /C:"nv_"|findstr /i /V /C:"pcmcia."|findstr /i /V /C:"prnep" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"qd3" "%YCP%tmp.txt"|findstr /i /V /C:"ql"|findstr /i /V /C:"ramdisk."|findstr /i /V /C:"rawsilo."|findstr /i /V /C:"rdlsbuscbs." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"rdpbus." "%YCP%tmp.txt"|findstr /i /V /C:"rdvgwddm."|findstr /i /V /C:"ricoh."|findstr /i /V /C:"rndiscmp."|findstr /i /V /C:"sbp2." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"scrawpdo." "%YCP%tmp.txt"|findstr /i /V /C:"scsidev."|findstr /i /V /C:"sdbus."|findstr /i /V /C:"sensorsalsdriver."|findstr /i /V /C:"sffdisk." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"sisraid" "%YCP%tmp.txt"|findstr /i /V /C:"smartcrd."|findstr /i /V /C:"stexstor."|findstr /i /V /C:"sti."|findstr /i /V /C:"synth3dvsc." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"tape." "%YCP%tmp.txt"|findstr /i /V /C:"tdibth."|findstr /i /V /C:"term"|findstr /i /V /C:"tpm."|findstr /i /V /C:"transfercable." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"tsgenericusbdriver." "%YCP%tmp.txt"|findstr /i /V /C:"tsprint."|findstr /i /V /C:"tsusbhub"|findstr /i /V /C:"ts_generic."|findstr /i /V /C:"ts_wpdmtp." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"umbus." "%YCP%tmp.txt"|findstr /i /V /C:"umpass."|findstr /i /V /C:"unknown."|findstr /i /V /C:"usb"|findstr /i /V /C:"vhdmp." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"volsnap." "%YCP%tmp.txt"|findstr /i /V /C:"volume."|findstr /i /V /C:"vsmraid."|findstr /i /V /C:"v_mscdsc."|findstr /i /V /C:"wave." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"wceisvista." "%YCP%tmp.txt"|findstr /i /V /C:"wd."|findstr /i /V /C:"wdm"|findstr /i /V /C:"windowssideshowenhanceddriver."|findstr /i /V /C:"wnetvsc."|findstr /i /V /C:"prnms00" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"wpd" "%YCP%tmp.txt"|findstr /i /V /C:"ws"|findstr /i /V /C:"bus"|findstr /i /V /C:"wvmic."|findstr /i /V /C:"xcbdav."|findstr /i /V /C:"xnacc." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
echo.
echo   精简驱动收集完成 获取权限开始处理稀用的驱动数据 请稍候...
echo.
ping -n 3 127.1>nul
for /f "delims=" %%i in (%YCP%tmp.txt) do (cmd.exe /c takeown /f "%yd%\%%i" /r /d y & icacls "%yd%\%%i" /grant administrators:F /t & RD "%yd%\%%i" /s /q)
if exist "%YCP%tmp.txt" del /f/q "%YCP%tmp.txt"
title    %dqwc% 正式版系统进行驱动极限精简 %dqcd%28-1
echo.
echo   稀用驱动精简完成 为防止程序操作延迟 延迟3秒以保无误
echo.
ping -n 3 127.1 >nul
cls
goto ABLY

:BTFR
title  %dqwz% 正式版系统进行驱动极限精简 %dqcd%28-2
cls
echo.
echo   2 主要采用MS原生ISO中 boot.wim 中的驱动替换  影响桌面体验 只推荐做极限精简测试  
echo.
echo        确认要执行操作并且所需条件满足       请回车开始执行终极安全极限驱动精简
echo.
echo   *** 需要注意的是：装载ISO状态直接执行否则请提取ISO\Sources\boot.wim 到 %YCP% ***
echo.
echo   开始处理权限并执行终极安全极限字体精简操作... 请稍候！！！
echo.
if not exist %SOUR%boot.wim (
echo.
echo   数据错误或没有发现 %SOUR%boot.wim 请确认无误后重新执行  程序返回
echo.
ping -n 5 127.1 >nul
cls
goto MENU
)
echo.
echo   补充桌面体验显卡声卡原始驱动...
echo.
if not exist %YCP%FileRepositoryB md %YCP%FileRepositoryB
dir /b /ad "%MOU%\Windows\System32\DriverStore\FileRepository">>%YCP%Adfile.txt
set yc=%MOU%\Windows\System32\DriverStore\FileRepository
for /f "delims=" %%a in (%YCP%Adfile.txt) do (echo "%%a"|find /i "hdaudbus.inf_" &&Xcopy /y /e /k /h %yc%\%%a %YCP%FileRepositoryB\%%a\)
for /f "delims=" %%a in (%YCP%Adfile.txt) do (echo "%%a"|find /i "hdaudio.inf_" &&Xcopy /y /e /k /h %yc%\%%a %YCP%FileRepositoryB\%%a\)
for /f "delims=" %%a in (%YCP%Adfile.txt) do (echo "%%a"|find /i "hdaudss.inf_" &&Xcopy /y /e /k /h %yc%\%%a %YCP%FileRepositoryB\%%a\)
for /f "delims=" %%a in (%YCP%Adfile.txt) do (echo "%%a"|find /i "display.inf_" &&Xcopy /y /e /k /h %yc%\%%a %YCP%FileRepositoryB\%%a\)
for /f "delims=" %%a in (%YCP%Adfile.txt) do (echo "%%a"|find /i "displayoverride.inf_" &&Xcopy /y /e /k /h %yc%\%%a %YCP%FileRepositoryB\%%a\)
cmd.exe /c takeown /f "%MOU%\Windows\System32\DriverStore\FileRepository" /r /d y && icacls "%MOU%\Windows\System32\DriverStore\FileRepository" /grant administrators:F /t
cmd.exe /c takeown /f "%YCP%1\Windows\System32\DriverStore\FileRepository" /r /d y && icacls "%YCP%1\Windows\System32\DriverStore\FileRepository" /grant administrators:F /t
%YCP%TOOL\7z\7z x %SOUR%boot.wim -o.\ 1\Windows\System32\DriverStore\FileRepository>nul
if exist %YCP%1\Windows\System32\DriverStore\FileRepository XCOPY /y /S %YCP%1\Windows\System32\DriverStore\FileRepository\* FileRepository\
Xcopy /y /s %YCP%FileRepositoryB FileRepository\
rd /q /s %YCP%1
rd /q /s %YCP%FileRepositoryB
cmd.exe /c takeown /f "%MOU%\Windows\System32\DriverStore\FileRepository" /r /d y && icacls "%MOU%\Windows\System32\DriverStore\FileRepository" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\DriverStore\FileRepository"
cmd.exe /c takeown /f "%MOU%\Windows\System32\DriverStore" /r /d y && icacls "%MOU%\Windows\System32\DriverStore" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\DriverStore\FileRepository"
move /y %YCP%FileRepository %MOU%\Windows\System32\DriverStore\
del /q /f %YCP%Adfile.txt
title  %dqwc% 正式版系统进行驱动极限精简 %dqcd%28-2
echo.
echo   驱动处理操作成功完成 为防止程序操作延迟 延迟3秒以保无误
echo.
ping -n 3 127.1>nul
cls
goto ABLY

:ABLY
cls
title  %dqwz% 正式版系统进行虚链接精简 %dqcd%28-3
echo.
echo   第二阶段  开始安全处理部分虚链接数据不影响所有补丁安装 请稍候...
echo.
echo   解除目录读写限制 并开始处理虚链数据 请稍候...
echo.
if exist "%MOU%\Windows\assembly\NativeImages_v2.0.50727_32" (
cmd.exe /c takeown /f "%MOU%\Windows\assembly\NativeImages_v2.0.50727_32" /r /d y && icacls "%MOU%\Windows\assembly\NativeImages_v2.0.50727_32" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\assembly\NativeImages_v2.0.50727_32"
)
if exist %MOU%\Windows\SysWOW64 if exist "%MOU%\Windows\assembly\NativeImages_v2.0.50727_64" (
cmd.exe /c takeown /f "%MOU%\Windows\assembly\NativeImages_v2.0.50727_64" /r /d y && icacls "%MOU%\Windows\assembly\NativeImages_v2.0.50727_64" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\assembly\NativeImages_v2.0.50727_64"
)
if exist "%MOU%\Windows\assembly\NativeImages_v4.0.30319_32" (
cmd.exe /c takeown /f "%MOU%\Windows\assembly\NativeImages_v4.0.30319_32" /r /d y && icacls "%MOU%\Windows\assembly\NativeImages_v4.0.30319_32" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\assembly\NativeImages_v4.0.30319_32"
)
if exist %MOU%\Windows\SysWOW64 if exist "%MOU%\Windows\assembly\NativeImages_v4.0.30319_64" (
cmd.exe /c takeown /f "%MOU%\Windows\assembly\NativeImages_v4.0.30319_64" /r /d y && icacls "%MOU%\Windows\assembly\NativeImages_v4.0.30319_64" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\assembly\NativeImages_v4.0.30319_64"
)
title  清理驱动预编译残留 请稍候...
cls
echo.
echo   第三阶段 清理驱动预编译残留 请稍候...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\inf" /r /d y && icacls "%MOU%\Windows\inf" /grant administrators:F /t
del /q /f %MOU%\Windows\inf\*.PNF
for /r %MOU%\Windows\inf %%i in (*.pnf) do (if exist %%i del "%%i" /q /f )
cls
title  %dqwc% 正式版系统驱动和虚链接极限精简 %dqcd%28-3
echo.
echo   ======================= 警 ==================== 告 =============================
echo.
echo    本操作至此为止均为安全精简底限 此时返回主菜单增量保存可保证能正常更新所有补丁
echo.
echo    继续进行最后的WinSxS极限精简后将损失大部分组件   不能正常启禁用功能及完美更新
echo.
echo    确认继续进行组件WinSxS极限精简直接回车 按0回车将返回主菜单 并推荐进行增量保存
echo.
set /p mqr=请认真考虑并确认将如何操作 0 返回菜单 确认继续进行组件WinSxS极限精简直接回车：
if "%mqr%"=="0" goto MENU

:LITE
cls
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% WinSxS极限精简 %dqcd%29
echo.
echo   %dqwz% WinSxS极限精简 %dqcd%29
echo.
echo   正在进行WinSxS极限精简数据收集... 
echo.
echo   本方案已经过全系统测试通过 基本不会影响到所有驱动安装 处理时间较长请耐心等待程序完成
echo.
echo   收集数据过程CPU和内存占用较大  如无必要请勿做其它工作 开始收集相关数据...  请稍候！！！
echo.
dir /b /ad "%MOU%\Windows\WinSxS">%YCP%tmp.txt
set yc=%MOU%\Windows\WinSxS
if %OFFSYS% GTR 7601 goto LIT2

:LIT1
echo.
echo   为 Windows 7 以下系统保留独有数据... 请稍候
echo.
findstr /i /V /C:"_acpi.inf_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-cmiadapter_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-cmitrustinfoinstallers_1122334455667788_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-f..allconfig-installer_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-g..decacheclean-canada_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-i..-setieinstalleddate_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-i..eoptionalcomponents_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-i..rnational-timezones_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-i..rnational-timezones_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-ie-gc-registeriepkeys_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-ie-iecleanup_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-ie-pdm-configuration_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-ie-pdm_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-ie-pdm_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-msmpeg2adec_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-msmpeg2enc.resources_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-msmpeg2enc_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-msmpeg2vdec_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-r..s-regkeys-component_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-security-spp-installer_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-wmi-cmiplugin_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-wmpnss-api.resources_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-wmpnss-api_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-wmpnss-publicapi_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-wmpnss-service_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-wmpnss-ux.resources_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-wmpnss-ux_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-wmpnssui.resources_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-wmpnssui_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_windowssearchcomponent_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft.windows.s...smart_card_library_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft.windows.s..rt_driver.resources_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft.windows.s..se.scsi_port_driver_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft.windows.s..se.scsi_port_driver_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt

:LIT2
echo.
echo   保留 Windows 7 以上系统通用数据... 请稍候
echo.
findstr /i /V /C:"_microsoft.vc80." "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft.vc90." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-com-dtc-runtime_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-cmisetup_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-cmisetup_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-cmi_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-dynamicvolumemanager_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-desktoptileresources_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-deltacompressionengine_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-deltapackageexpander_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-drvstore_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-d..t-services-unattend_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-anytime-upgrade_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft.windows.gdiplus.systemcopy_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-help-datalayer_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-i..ntrolpanel.appxmain_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-luainstaller_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-msxml60_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-setup-unattend_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-shell32_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-m..tion-isolationlayer_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-naturallanguage6-base_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-p..ncetoolscommandline_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-naturallanguage6-base_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-packagemanager_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-pantherengine_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-security-spp-installer_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-servicingstack_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-t..platform-comruntime_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft.windows.c..ration.online.setup_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft.windows.c..-controls.resources_6595b64144ccf1df_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft.windows.common-controls_6595b64144ccf1df_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft.windows.gdiplus_6595b64144ccf1df_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft.windows.i..utomation.proxystub_6595b64144ccf1df_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft.windows.isolationautomation_6595b64144ccf1df_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-oobe-firstlogonanim_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-oobe-firstlogonanimexe_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft.windows.s..ation.badcomponents_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-s..cingstack.resources_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-s..icing-adm.resources_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-s..stack-msg.resources_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-shell32_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-smi-engine_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-store-licensemanager_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-uiribbon_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-uiribbon.resources_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-wmi-core-fastprox-dll_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-wmi-core-repdrvfs-dll_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-wmi-core-wbemcomn-dll_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-wmi-core-wbemcore-dll_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-wmi-core_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-wmi-mofinstaller_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-xmllite_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_system.runtime.seri..ion.formatters.soap_b03f5f7f11d50a3a_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_wcf-m_sm_cfg_ins_exe_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_wcf-m_sm_cfg_ins_exe_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"Catalogs" "%YCP%tmp.txt"|findstr /i /V /C:"FileMaps" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"ManifestCache" "%YCP%tmp.txt"|findstr /i /V /C:"Manifests"|findstr /i /V /C:"InstallTemp" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
for /f "delims=" %%i in (%YCP%tmp.txt) do (cmd.exe /c takeown /f "%yc%\%%i" /r /d y & icacls "%yc%\%%i" /grant administrators:F /t & RD /s/q "%yc%\%%i")
if exist "%YCP%tmp.txt" del /f/q "%YCP%tmp.txt"
dir /b /a-d "%MOU%\Windows\WinSxS">%YCP%tmp.txt
findstr /i /V /C:"migration.xml" "%YCP%tmp.txt"|findstr /i /V /C:"reboot.xml"|findstr /i /V /C:"poqexec.log" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
for /f "delims=" %%i in (%YCP%tmp.txt) do (cmd.exe /c takeown /f "%yc%\%%i" /r /d y & icacls "%yc%\%%i" /grant administrators:F /t & del /f/q "%yc%\%%i")
if exist "%YCP%tmp.txt" del /f/q "%YCP%tmp.txt"
ping -n 5 127.1 >nul
echo.
echo       请选择是否关闭虚拟内存
echo.
echo   关闭输入1回车   不关闭直接回车即可
echo.
set xnlc=0
set /p xnlc=请输入您的选择回车执行：
if /i "%xnlc%"=="1" (
%SYREG% >nul
reg add "HKLM\0\ControlSet001\Control\Session Manager\Memory Management" /v "PagingFiles" /t REG_MULTI_SZ /d "" /f
%UNREG% >nul
)
echo.
echo  %dqwc% WinSxS极限精简           请检查调用脚本是否有遗漏
echo.
ping -n 3 127.1 >nul
Start notepad.exe %MOU%\Windows\Setup\Scripts\SetupComplete.cmd
echo.
title   %dqwc% WinSxS极限精简 请检查调用脚本是否有遗漏
echo.
echo  WinSxS极限精简已完成  6秒后自动返回主菜单推荐增量保存映像
echo.
ping -n 6 127.1 >nul
cls
goto MENU

:SCPY
title  %dqwz% 卸载或移除Win10拼音辅助数据 %dqcd%19
echo.
echo   %dqwz% 卸载或移除Win10拼音辅助数据 %dqcd%19
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   开始卸载或移除Win10拼音输入法...
echo.
%YCP%TOOL\Tweak.exe /p "%MOU%" /c Microsoft-Windows-IME-SimplifiedChinese-PinyinDSDomain /r >nul 2>nul
%YCP%TOOL\Tweak.exe /p "%MOU%" /c Microsoft-Windows-IME-SimplifiedChinese-PinyinDSExtra /r >nul 2>nul
echo.
title  %dqwc% 卸载或移除Win10拼音辅助数据 %dqcd%19
echo.
echo   样操作完成  5秒后程序返回主菜单
echo.
ping -n 5 127.1>nul
cls
goto MENU

:GTZN
title  %dqwz% 获取适用汉化数据 %dqcd%41
echo.
echo   %dqwz% 获取适用汉化数据 %dqcd%41
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if exist %MOU%\Windows\zh-CN (
echo.
echo   挂载中的系统好像已经是中文版无需汉化  程序返回
echo.
ping -n 6 127.1>nul
cls
goto MENU
)
echo.
echo   请输入汉化数据来源分区盘符  可以是当前系统分区也可以是VHD系统分区
echo.
echo   数据来源系统位数必须为%Mbt%并且接近挂载系统的版本否则可能损坏映像
echo.
echo   也可从挂载目录或多级目录获取比如D:\MYZNCN\XXX  注意路径不得有空格
echo.
echo   D:\MYZNCN\XXX目录中必须是含有完整系统语言目录结构  并保证数据有效
echo.
set SJF=C:
set /p SJF=直接回车默认数据来源为C分区系统 不做操作请按0回车返回主菜单:
If "%SJF%"=="0" Goto MENU
if not exist "%SJF%\Windows\zh-CN" (
echo.
echo  %SJF%好像不是系统分区或不是中文系统哟 请重新输入吧
echo.
ping -n 5 127.1>nul
cls
GOTO :GTZN
)
if exist %YCP%TOOL\%FSYS%ZNCN.WIM (
if not exist %YCP%ZNCN\%Mbt% md %YCP%ZNCN\%Mbt%
echo.
echo  开始根据映像架构释放%Mbt%的汉化数据样本... 请稍候
echo.
if %Mbt% equ x86 %YCDM% /Apply-Image /ImageFile:%YCP%TOOL\%FSYS%ZNCN.WIM /Index:1 /ApplyDir:%YCP%ZNCN\%Mbt%
if %Mbt% equ x64 %YCDM% /Apply-Image /ImageFile:%YCP%TOOL\%FSYS%ZNCN.WIM /Index:2 /ApplyDir:%YCP%ZNCN\%Mbt%
)
if not exist "%YCP%ZNCN\%Mbt%\Windows\zh-CN" (
echo.
echo  没有样本数据 请从雨晨DISM分享中下载 %FSYS%ZNCN.WIM 放入%YCP%TOOL目录中重新操作
echo.
ping -n 5 127.1>nul
cls
GOTO :GTZN
)
echo.
echo  开始从你输入的系统分区更新汉化数据...
echo.
xcopy /y /h /s /u %SJF% ZNCN\%Mbt%\
title  %dqwc% 获取适用汉化数据 %dqcd%41
echo.
echo   最新的数据为 %Mbt% 只能用于汉化 %Mbt% 的系统
echo.
ping -n 6 127.1>nul
cls
goto MENU

:ADZN
title  %dqwz% 汉化当前挂载系统 %dqcd%42
echo.
echo   %dqwz% 汉化当前挂载系统 %dqcd%42
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if exist %MOU%\Windows\zh-CN (
echo.
echo   挂载中的系统好像已经是中文版无需汉化或已经加入汉化数据  程序返回
echo.
ping -n 5 127.1>nul
cls
goto MENU
) 
if not exist TOOL\%FSYS%ZNCN.WIM (
echo.
echo   没有找到%FSYS%ZNCN.WIM请在实战群共享链接中下载并放在%YCP%TOOL下
echo.
ping -n 5 127.1>nul
cls
goto MENU
)
echo.
echo   开始应用汉化数据... 汉化方法为数据替换操作不可逆除非放弃保存重来
echo.
echo   如 汉化18300请用RS5 CN17632数据  如 汉化17030 请用RS  17025 数据
echo.
echo   请尽最大可能采用分支相同且版本最接近的官方原版数据以保汉化后正常
echo       ＝＝＝＝    ＝＝＝＝  ＝＝＝＝＝  ＝＝＝＝＝＝ 
ping -n 6 127.1>nul
echo.
echo   应用汉化数据...
echo.
if %Mbt% equ x86 %YCDM% /Apply-Image /ImageFile:%YCP%TOOL\%FSYS%ZNCN.WIM /Index:1 /ApplyDir:%MOU%
if %Mbt% equ x64 %YCDM% /Apply-Image /ImageFile:%YCP%TOOL\%FSYS%ZNCN.WIM /Index:2 /ApplyDir:%MOU%
echo.
echo   安全加入汉化设置...
echo.
xcopy MY\ZNCN.reg %MOU%\Windows\Setup\Scripts\
title  %dqwc% 汉化当前挂载系统 %dqcd%42
echo.
echo   汉化数据已加入并已应用设置  建议增量保存以保修正后再试 程序返回
echo.
ping -n 6 127.1>nul
cls
goto MENU

:GTQD
title  %dqwz% 提取当前系统外加驱动 %dqcd%43 
echo.
echo   %dqwz% 提取当前系统外加驱动 %dqcd%43 
echo.
echo      驱动获取到%YCP%%TheOS%%Obt%QD下 以便为相同硬件相同架构的系统执行集成操作
if not exist %TheOS%%Obt%QD md %YCP%%TheOS%%Obt%QD
set AZFQ=C
dism /online /export-driver /destination:%YCP%%TheOS%%Obt%QD\
echo.
echo      默认获取C分区驱动  其它分区请输其分区盘符字母如果不是%TheOS%%Obt%请改相应名称
echo.
set /p AZFQ=请输入要提取外加驱动的系统分区盘符字母无需冒号默认为C:
if /i "%AZFQ%"=="C" goto :MENU
echo.
echo      要提取的系统分区为 %AZFQ%
echo.
set AZRQ=N
set /p AZRQ=请输入要提取外加驱动的系统安装时间  格式为 月月-日日-年年年年 直接回车返回:
if /i "%AZRQ%"=="N" goto :MENU
echo.
echo      您输入的安装日期为 %AZRQ%
echo.
echo      如果分区或数据存在则开始提取
echo.
xcopy /y /S /D:%AZRQ% %AZFQ%:\Windows\System32\DriverStore\FileRepository %YCP%%TheOS%%Obt%QD\
title  %dqwc% 提取当前系统外加驱动 %dqcd%43 
echo.
echo           %AZFQ% 中外加驱动提取完成 适用于 %Obt% 架构的系统
echo.
echo      如无意外驱动已经获取到%YCP%%TheOS%%Obt%QD 程序5秒后自动返回主菜单后继续
echo.
ping -n 5 127.1>nul
cls
goto MENU

:GTPL
title  %dqwz% 获取装载映像所有封包列表  %dqcd%39
echo.
echo   %dqwz% 获取装载映像所有封包列表  %dqcd%39
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   开始查询映像所有内置封包并生成列表...
del /q %temp%\tmp.txt  >nul 2>nul
del /q %temp%\packages.txt >nul 2>nul
del /q %temp%\Plist.txt >nul 2>nul
del /q %temp%\unplist.txt >nul 2>nul
dir /b /a "%MOU%\Windows\servicing\Packages" >%YCP%packages.txt
set n=0
for /f "delims=" %%i in (%YCP%packages.txt) do set /a n+=1
for /l %%i in (1,2,%n%) do (
findstr /n "." %YCP%packages.txt|findstr /r "^%%i:">>%YCP%tmp.txt
)
for /f "tokens=1* delims=:" %%i in (%YCP%tmp.txt) do echo %%j>>%YCP%Plist.txt
for /f "tokens=1,2,3,4 delims=." %%i in (%YCP%Plist.txt) do echo %%i^.%%j^.%%k^.%%l>>%YCP%Unplist.txt
del /q %YCP%tmp.txt
del /q %YCP%packages.txt
del /q %YCP%Plist.txt
start %YCP%unplist.txt
echo.
title  %dqwc% 获取装载映像所有封包列表  %dqcd%39
echo.
echo   如果你较专业可以执行菜单 40 进行移除操作 自动进入自选操作
echo.
ping -n 3 127.1>nul
cls

:KPKB
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% 自选强制删除封包  %dqcd%40
echo.
echo   %dqwz% 自选强制删除封包  %dqcd%40
echo.
if not exist %YCP%Unplist.txt CALL :GTPL
echo   警告：如你不专业并随意删除核心封包将会报废映像  
echo.
set TKP=N
set /p TKP=请复制打开的文本中你要删除封包的一行粘贴到本窗口回车执行操作 或直接回车返回主菜单：
if /i "%TKP%"=="N" del /q %YCP%Unplist.txt &&Goto :MENU
echo.
echo   尝试删除%TKP% 可能需要较长时间  请稍候...
echo %YCP%TOOL\Tweak.exe /p %MOU% /c "%TKP%" /r ^>nul 2^>nul >%YCP%KPKB.cmd &&CALL %YCP%KPKB.cmd
if exist %YCP%KPKB.cmd del /q /f %YCP%KPKB.cmd
set OSKI=Y
set /p OSKI=如果操作无误已经删除该封包 继续执行直接回车 返回主菜单请输入N回车：
title  %dqwc% 自选强制删除封包  %dqcd%40
if /i "%OSKI%"=="N" del /q %YCP%Unplist.txt &&Goto :MENU
if /i "%OSKI%"=="Y" CALL :KPKB
echo.
echo   输入有误  程序返回主菜单
echo.
ping -n 3 127.1>nul
cls
goto :MENU

:ADMI
title  %dqwz% 开启内置用户使用APPS批准模式 %dqcd%35
echo.
echo   %dqwz% 开启内置Administrator用户使用APPS %dqcd%35
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
%SSREG% >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d 5 /f
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d 1 /f
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\System" /v "FilterAdministratorToken" /t REG_DWORD /d 1 /f
%UNREG% >nul
title  %dqwc% 开启内置用户使用APPS批准模式 %dqcd%35
echo.
echo   内置Administrator用户使用APPS功能已启用经完成 程序返回主菜单
echo.
ping -n 6 127.1>nul
cls
goto MENU

:YKMS
title  %dqwz% 添加联网KMS激活批处理程序 for Win10系统 %dqcd%37
echo.
echo   %dqwz% 添加联网KMS激活批处理程序 for Win10系统 %dqcd%37
echo.
echo   程序将把联网激活的批处理程序放到用户桌面   用户自行决定是否使用
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
Xcopy /y %YCP%MY\联网KMS.cmd %MOU%\Users\Public\Desktop\ >nul
echo.
echo   联网KMS激活批处理程序已经放到用户桌面   用户自行决定是否使用
echo.
ping -n 6 127.1>nul
cls
goto MENU

:ADTG
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
cls
title  %dqwz% 加入自己软件合集 %dqcd%38
echo.
echo   %dqwz% 加入自己软件合集 %dqcd%38
echo.
echo   加 入 软 件 合 集 说 明：
echo  ≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡
echo         请勿必保证程序安全，不得有后门、木马、广告、恶意链接等诟病，否则将承担法律
echo.
echo         责任，特此警告！！！         (TGDY.CMD为通用调用及清理程序 请勿删除或改名)
echo.
echo         须知以上条款后请将要推广的程序包及配置放到 %YCP%MY\TuiGuang\    按回车开始
echo  ≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡
pause >nul
set xz=1
if not exist %YCP%MY\TuiGuang\*.exe if not exist %YCP%MY\TuiGuang\TGDY.CMD (
echo.
echo   %YCP%MY\TuiGuang没有EXE数据 请检查后回车重新执行加入推广操作 按0回车返回主菜单
echo.
set /p xz=请选择怎样继续：
)
if %xz% NEQ 1 goto :MENU
if not exist %YCP%MY\TuiGuang goto :MENU
if exist %YCP%MY\TuiGuang\*.* if not exist %MOU%\TuiGuang md %MOU%\Windows\TuiGuang
Xcopy /y %YCP%MY\TuiGuang\*.* %MOU%\Windows\TuiGuang\
echo.
echo   开始加入推广程序包有效安装接口注册表项...
echo.
%USREG% >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "@tg" /t REG_EXPAND_SZ /d "%%SystemRoot%%\TuiGuang\TGDY.CMD" /f >nul
%UNREG% >nul
title  %dqwc% 加入自己的推广程序包 %dqcd%38
echo.
echo   加入推广程序包有效安装接口注册表项完成 程序返回主菜单
echo.
ping -n 5 127.1>nul
cls
goto MENU

:OFFC
title   %dqwz% 加入 Office2016 或 Office2007 绿色精简3合1数据 %dqcd%34
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   %dqwz% 加入 Office2016 或 Office2007 绿色精简3合1数据 %dqcd%39
echo.
echo   Office2016需要在Win7SP1以上系统方可使用并要求相应的运行库支持
echo.
echo   程序当前提供两种集成选择           请根据自己实际情况选定集成
echo.
echo   1  集成Office2007精简3合1           2  集成Office2016精简3合1
echo.
set OFXZ=0
set /p OFXZ=请选择并输入你要操作序号数字 按3回车返回 直接回车智能添加整合：
if "%OFXZ%"=="3" GOTO MENU
if "%OFXZ%"=="2" GOTO OF16
if "%OFXZ%"=="1" GOTO OF07
if "%OFXZ%"=="0" GOTO AUTO
echo.
echo                 输入错误请重新输入
echo.
ping -n 6 127.1>nul
cls
goto OFFC

:AUTO
if %OFFSYS% LSS 7601 (goto OF07) ELSE (goto OF16)

:OF07
title   %dqwz% 集成Office2007精简3合1
echo.
echo    为装载中的映像集成Office2007精简3合1 程序开始添加数据...
echo.
if /i %Mbt% EQU x64 (
if exist "%MOU%\Program Files (x86)\Office2007" (
echo.
echo    已经集成过Office2007了    请不要重复集成
echo.
title   %dqwc% 集成Office2007精简3合1 %dqcd%34-1
ping -n 3 127.1>nul
cls
goto :MENU
)
%YCP%TOOL\7z\7z.exe x %YCP%ADXX\Office2007.7z -o"%MOU%\Program Files (x86)\Office2007\" >nul
echo cd /d "%%ProgramFiles(x86)%%\Office2007" ^&^&start Setup.exe >"%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\0green.cmd"
echo del %%0 >>"%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\0green.cmd"
) ELSE (
if exist "%MOU%\Program Files\Office2007" (
echo.
echo    已经集成过Office2007了     请不要重复集成
echo.
title   %dqwc% 集成Office2007精简3合1 %dqcd%34-1
ping -n 3 127.1>nul
cls
goto :MENU
)
%YCP%TOOL\7z\7z.exe x %YCP%ADXX\Office2007.7z -o"%MOU%\Program Files\Office2007\" >nul
echo cd /d "%%ProgramFiles%%\Office2007" ^&^&start Setup.exe >"%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\0green.cmd"
echo del %%0 >>"%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\0green.cmd"
)
echo.
echo   关闭账户控制防止绿化程序绿化失败 ...
echo.
%SSREG% >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0 /f
%UNREG% >nul
echo.
title 加入Office2007 绿色精简3合1数据完成 %dqcd%34-1
echo.
echo   绿色精简 Office2007 3合1 数据加入完成 程序返回主菜单
echo.
ping -n 6 127.1>nul
cls
goto MENU

:OF16
title   %dqwz% 集成Office2016精简3合1 %dqcd%34-2
echo.
echo    为装载中的映像集成Office2016精简3合1 程序开始添加数据...
echo.
if /i %Mbt% EQU x64 (
if exist "%MOU%\Program Files (x86)\Office2016" (
echo.
echo    已经集成过Office2016了     请不要重复集成
echo.
title   %dqwc% 集成Office2016精简3合1 %dqcd%34-2
ping -n 3 127.1>nul
cls
goto :MENU
)
%YCP%TOOL\7z\7z.exe x %YCP%ADXX\Office2016.7z -o"%MOU%\Program Files (x86)\Office2016\" >nul
echo cd /d "%%ProgramFiles(x86)%%\Office2016" ^&^&start Setup.cmd >"%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\0green.cmd"
echo del %%0 >>"%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\0green.cmd"
) ELSE (
if exist "%MOU%\Program Files\Office2016" (
echo.
echo    已经集成过Office2016了     请不要重复集成
echo.
title   %dqwc% 集成Office2016精简3合1 %dqcd%34-2
ping -n 3 127.1>nul
cls
goto :MENU
)
%YCP%TOOL\7z\7z.exe x %YCP%ADXX\Office2016.7z -o"%MOU%\Program Files\Office2016\" >nul
echo cd /d "%%ProgramFiles%%\Office2016" ^&^&start Setup.cmd >"%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\0green.cmd"
echo del %%0 >>"%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\0green.cmd"
)
echo   关闭账户控制防止绿化程序绿化失败 √
echo.
%SSREG% >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0 /f
%UNREG% >nul
echo.
title  加入Office2016 绿色精简3合1数据完成 %dqcd%34-2
echo.
echo    Office2016 3合1 数据加入完成 程序返回主菜单
echo.
ping -n 6 127.1>nul
cls
goto MENU

:YJYX
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz%卸载所有非内置驱动 %dqcd%44
echo.
echo   %dqwz% 一键卸载所有非内置驱动 %dqcd%44
echo.
SET Q=0
if exist %MOU%\Windows\inf\OEM%Q%.inf (
echo.
echo   发现映像中疑似外加驱动信息 如果数据完整开始将其卸载...
echo.
)
if exist %MOU%\Windows\inf\OEM%Q%.inf %YCDM% /Image:%MOU% /Remove-Driver /Driver:OEM%Q%.inf

:QT
set /a Q=%Q%+1
if exist %MOU%\Windows\inf\OEM%Q%.inf %YCDM% /Image:%MOU% /Remove-Driver /Driver:OEM%Q%.inf &GOTO QT
title   %dqwc%卸载所有非内置驱动 %dqcd%44
echo.
echo   如果映像完整所有外加驱动已经全部卸载或没有驱动 应该可以用于异机部署
echo.
echo   要自定义卸载请在主菜单输入47回车      程序6秒后自动返回主菜单后继续
echo.
ping -n 5 127.1>nul
cls
goto MENU

:YCYY
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz% 自定义卸载部分可选功能 %dqcd%45
echo.
echo   %dqwz% %dqwz% 自定义卸载部分可选功能 %dqcd%45
echo.
echo   正在查询功能包...请勿干扰或中断程序运行        操作完成自动提示下一步操作
echo.
%YCDM% /Image:%MOU% /Get-packages>%YCP%packages.txt
start %YCP%packages.txt
:JXSC
echo.
echo   请复制打开的文本中[程序包标识符: 复制的内容 ]纯英文部分粘贴到本程窗口回车
echo                                    ˉˉˉˉˉ
echo   警告：如果你不了解删除后的影响请尽量不要随意执行删除操作，正常情况下集成了
echo.
echo   中文语言包可安全删除英文和其它Language Pack性质的语言OnDemand Pack的en-us
echo.
echo   属于基础语言，请谨慎删除 其它日、韩包括输入法以及手写语言等均可以安全删除
echo.
set scyy=0
set /p scyy=粘贴要删除的程序标识符到本窗口回车执行删除 直接回车不做任何操作并返回主菜单:
if "%scyy%"=="0" (
del %YCP%packages.txt
cls
goto MENU
)
echo.
%YCDM% /image:%MOU% /Remove-Package /PackageName:%scyy%
echo.
set jx=1
set /p jx=继续执行删除操作请直接回车 返回请输入0回车
if "%jx%"=="0" (
title   %dqwc% 自定义卸载部分可选功能 %dqcd%45
del /q /f %YCP%packages.txt
cls
goto MENU
)
cls
goto JXSC

:SJBB
title   %dqwz% 提升映像版本 %dqcd%31
echo.
echo   %dqwz% 提升映像版本 %dqcd%31
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
CALL :MMZB
:CXSJBB
echo.
echo      程序开始查询并列出当前%MEID%可转换版本列表...
echo.
if exist %temp%OSBliuld.txt del /f %temp%OSBliuld.txt
set m=
set n=
set OSBliuld= 
set OSBliuldM= 
for /f "skip=7 tokens=1,2,3,4 delims= " %%a in ('%YCDM% /english /Image:%MOU% /Get-TargetEditions') do (
 set /a n+=1
 set OSBliuldM=%%d
if "%%a"=="Target" call :output
)
if exist %temp%OSBliuld.txt (
TYPE %temp%OSBliuld.txt
) else (
echo.
echo      当前装载的%MEID%版本已经不能通过正常提升转换成其它版本映像！
echo.
echo      原因可能是通过菜单32转换过或者官方限制提升  程序6秒后返回主菜单
echo.
ping -n 6 127.1 >nul
cls
goto MENU
)
echo.
set /p "m=请选择并输入要转换成的版本前的序号数字回车执行 或按“B”回车返回主菜单： "
if /i %m% equ B goto MENU
for /f "tokens=1,2 delims=:" %%a in (%temp%OSBliuld.txt) do if %m%==%%a set "OSBliuldM=%%b"
echo.
echo      程序开始将%MEID%转换成%OSBliuldM%请稍候...
echo.
%YCDM% /Image:%MOU% /Set-Edition:%OSBliuldM% &&echo.&&goto :SCBY
echo.
echo              输入有误请重新正确输入  程序3秒后自动返回主菜单...
echo.
ping -n 3 127.1 >nul
cls
goto ZDSJ

:SCBY
cls
echo.
echo    为后续重命名做备用和从低版本提升后增加启用打印和UWF功能工作 完成后自动返回
echo.
set bcxz=
set /p bcxz=比如从家庭或家庭中文版提升到专业或企业版请按“Z” 返回请直接回车：
if /i "%bcxz%"=="Z" CALL:SJGNBC
%SSREG% >nul
CALL :GetNow
%UNREG% >nul
CALL :BBXM
goto MENU

:CLEA
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %YCP%Features.txt del /q /f %YCP%Features.txt
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz% 映像清理并固化更新 %dqcd%6
echo.
echo   %dqwz% 映像清理并固化更新 %dqcd%6
echo.
%YCDM% /image:%MOU% /Cleanup-Image /StartComponentCleanup &&%YCDM% /image:%MOU% /Cleanup-Image /StartComponentCleanup /ResetBase
title   %dqwc% 映像清理并固化更新操作 %dqcd%6
echo.
echo   如果提示清理异常或存在挂启状态  均可忽略继续其它操作  程序3秒后返回
echo.
ping -n 3 127.1 >nul
cls
GOTO MENU

:NOPG
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz% 关闭系统虚拟内存减少系统分区硬盘占用空间 %dqcd%33
echo.
echo    %dqwz% 关闭系统虚拟内存减少系统分区硬盘占用空间 %dqcd%33
echo.
echo   程序目前只提供关闭操作后续将提供更多可选方案 按回车执行
echo.
pause>nul
%SYREG% >nul
reg add "HKLM\0\ControlSet001\Control\Session Manager\Memory Management" /v "PagingFiles" /t REG_MULTI_SZ /d "" /f
%UNREG% >nul
echo.
title   %dqwc% 关闭系统虚拟内存减少系统分区硬盘占用空间 %dqcd%33
echo.
echo   如果没有意外程序已经为您关闭了虚拟内存 程序返回主菜单
echo.
ping -n 5 127.1 >nul
cls
GOTO MENU

:SAVE
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz% 保存映像... %dqcd%46
echo.
echo   %dqwz% 保存映像 %dqcd%46
echo.
%YCDM% /Commit-Image /MountDir:%MOU%
ping -n 3 127.1 >nul
title   %dqwc% 保存映像
cls
GOTO MENU

:ZLBC
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz% 增量保存... %dqcd%47
echo.
echo   %dqwz% 增量保存 %dqcd%47 
echo.
%YCDM% /Commit-Image /MountDir:%MOU% /Append
set /a INDEX=%INDEX%+1
echo set INDEX=!INDEX!>INDEXset.cmd
title   %dqwc% 增量保存
ping -n 3 127.1 >nul
cls
GOTO MENU

:UNMO
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %YCP%Features.txt del /q /f %YCP%Features.txt
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz% 卸载映像... %dqcd%48
echo.
echo   %dqwz% 卸载映像 %dqcd%48
echo.
Set s=1
Set /p s=输入0回车将不保存直接卸载   直接回车将保存后卸载
If "%s%"=="0" ( %YCDM% /Unmount-Image /MountDir:%MOU% /discard ) ELSE (%YCDM% /Unmount-Image /MountDir:%MOU% /commit)
cmd.exe /c takeown /f "%YCP%YCMOU" /r /d y && icacls "%YCP%YCMOU" /grant administrators:F /t
if exist %YCP%Default.reg (
attrib -r %YCP%Default.reg
if exist %YCP%Default.reg del /q %YCP%Default.reg
)
if exist INDEXset.cmd del /f /q INDEXset.cmd
if exist %YCP%SOFTWAREBKP del /f /q %YCP%SOFTWAREBKP
if exist %YCP%YCMOU RMDIR /Q /S "%YCP%YCMOU" >nul 2>nul
if exist %YCP%sxs RMDIR /Q /S "%YCP%sxs" >nul 2>nul
title   %dqwc% 卸载映像
echo.
if exist %YCP%YCMOU (
echo   挂载目录不能完全卸载 卸载注册表HKEY_LOCAL_MACHINE下多出项 再删除YCMOU
echo.
echo   如果您想继续编辑其它映像请按J回车返回主菜单  直接回车将进入输出纯净映
echo.
)
set fh=S
set /p fh=直接回车将输出纯净映或进行重命名操作    按 J 回车返回主菜单继续进行其它操作
if exist %YCP%Features.txt del /q /f %YCP%Features.txt
if exist %YCP%废弃装载中的映像.cmd del /q /f %YCP%废弃装载中的映像.cmd
if not exist %YCP%废弃装载中的映像.cmd del /q /f %YCP%异常中断后重新启用已装载映像.cmd
cls
if /i "%fh%"=="J" GOTO MENU

:SHCH
cls
if "%INDEX%"=="" (set n=1) else (set n=%INDEX%)

:SHX
cls
title   %dqwz% 输出纯净映或进行重命名操作 %dqcd%49
echo.
echo   %dqwz% 输出纯净映或进行重命名操作 %dqcd%49
echo.
for /f "tokens=3 delims= " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM ^| find /i "index"') do set ZS=%%a
%YCDM% /Get-Wiminfo /WimFile:%YCP%YCSINS.WIM
set /a SY=%ZS%-%n%
if %SY% equ 0 (set yxm=1) else (set yxm=1至%ZS%) 
echo.
echo   如果有增量保存或提升版本操作请对映像进行重命名   否则不能输出到同文件名映像中
echo.
echo   当前%YCP%YCSINS.WIM共%ZS%个子映像  如有两次以上直接保存操作推荐输出纯净映像
echo.
echo   此操作可清理映像中残余数据   主要是经反复操作而产生的除存在挂启状态的多余数据
echo.
echo   最终纯净映像文件为%YCP%install.wim 可直接替换原始 ISO\Sources 中另存即可
echo.
set /p n=输入要重命名子映像索引数字 映像总数%yxm% 直接回车默认%ZS% 退出按T 输出按E 回车：
if /i %n% equ T Goto :TUIC
if /i %n% equ E Goto :ERSC
if %SY% LSS 0 (
echo.
echo   %YCP%install.wim 中不存在第%n%个子映像 请重新输入！！！
echo.
ping -n 3 127.1 >nul
GOTO :SHX
)
for /f "delims=" %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM /index:%n% ^| find /i "Name"') do set MOS=%%a
set MOS=%MOS:~7%
for /f "tokens=3 delims=." %%b in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM /index:%n% ^| find /i "Version"') do set DmVer=%%b
for /f "delims=" %%b in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM /index:%n% ^| find /i "Edition"') do set MEID=%%b
set MEID=%MEID:~10%
for /f "tokens=1,2" %%i in ('echo %MOS%') do (set MTNT=%%i %%j)
set "MOS=%MTNT% %MEID%"
for /f "tokens=3 delims= " %%c in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM /index:%n% ^| find /i "Architecture"') do set Mbt=%%c
if exist %MEID%ZL.cmd call %MEID%ZL.cmd
echo. 
echo   开始为第%n%子个映像 进行重命名和描述  
echo.
echo   默认名称为^: %MOS%
echo.
set /p MOS=请输入映像名称（中文需要制粘进本窗口）后按回车继续：
echo.
set ABT=%MOS% %Mbt% %DmVer%
echo.
echo   默认描述为^: %ABT%
echo.
set /p ABT=请输入描述内容（中文需要制粘进本窗口）后按回车继续：
echo.

:NOIEXE
if not exist %YCP%TOOL\14393\%Obt%\Dism\imagex.exe (
echo.
echo   没找到 TOOL\14393\%Obt%\Dism\imagex.exe 命名程序 请确认后重新开始
echo.
pause >nul
GOTO :NOIEXE
)
echo   开始重命名第 %n% 个子映像   请稍候...
echo.
%YCP%TOOL\16299\%Obt%\Dism\imagex /info %YCP%YCSINS.WIM %n% "%MOS%" "%ABT%"
echo.
echo   为第%n%个子映像进行重命名和描述操作完成 直接回车继续命名 输出请按 E 
echo.
if exist %MEID%ZL.cmd del /f /q %MEID%ZL.cmd
set YE=Y
set SCXM=0
set /p YE=请选择你要的操作 继续命名 或 开始输出
if /i %YE% EQU Y Goto SHX

:ERSC
echo.
echo   可以自定义输出存在的子映像  默认为第%ZS%个
echo.
set n=%ZS%
set /p n=请输入要输出的子映像序号数字 默认是第%ZS%个
echo.
echo   开始输出第 %n% 个子映像的纯净映像   请稍候...
%YCDM% /Export-Image /SourceImageFile:%YCP%YCSINS.WIM /SourceIndex:%n% /DestinationImageFile:%YCP%install.wim
set /a SCXM=%SCXM%+1
set /a pds=%ZS%-%SCXM%
title   输出第%n%个子映像的纯净映像
set ag=0
echo.
echo   继续输出请按1 回车 直接回车扫尾返回 返回命名请按 R
echo.
set /p ag=直接回车 执行扫尾工作       按 1 回车继续输出：
if /i %ag% equ R Goto SHX
if %ag% equ 0 Goto SAOW
if %pds% equ 0 (
echo   %dqwc% 输出纯净映或进行重命名操作 %dqcd%49
echo.
echo   当前映像总数为%ZS% 已经输出%SCXM%次 程序默认进入扫尾工作
echo.
ping -n 3 127.1 >nul
cls
Goto SAOW
)
Goto ERSC

:SAOW
title   %dqwz% 输出纯净映像完成 扫尾中...
if not exist %YCP%install.wim goto ER1
if exist %YCP%install.wim REN %YCP%YCSINS.WIM YCSINS.OLD
if exist %YCP%sxs RMDIR /Q /S "%YCP%sxs" >nul 2>nul
echo.
echo   考虑到导出过程可能存在异常   所以没有默认删除旧文件 %YCP%YCSINS.OLD
echo.
echo   %YCP%install.wim输出完成 %YCP%YCSINS.OLD自定是否删除 3秒后返回主菜单
echo.
title   %dqwc% 重命名并输出纯净映像 扫尾工作完成 返回主菜单
ping -n 3 127.1 >nul
cls
goto MENU

:ER1
CLS
ECHO.
ECHO  输出纯净映像没有成功完成 确认程序操作没中断或异常 3秒后将再次尝试输出纯净映像 
echo.
ping -n 3 127.1 >nul
goto ERSC

:ER2
cd..
CLS 
ECHO.
ECHO  你提供的IE程序本程序不能识别或损坏请检查后重新执行集成操作
ECHO.
PAUSE>NUL
GOTO MENU

:ER3
CLS
ECHO.
ECHO  未知错误  请按回车返回主菜单
echo.
PAUSE>NUL
GOTO MENU

:CheckWE
CLS
echo.
echo  温馨提醒：
echo.
echo  没有发现%SOUR%install.wim^(或esd^)或YCSINS.WIM 映像文件  请确认后 按回车重新运行程序
echo.
echo  可直接将 WIM或ESD^(无加密)格式的映像 复制到%SOUR%目录 重新命名为 YCSINS.WIM 即可使用
echo.
PAUSE>NUL
cls
call %0

:ER4
CLS
ECHO.
ECHO    没找到程序预设的无人值守文件 请确认你没有误删、移动或改名 操作失败请检查后重新运行
echo.
pause>nul
goto MENU

:IEER
CLS
ECHO.
ECHO     此操作只适用于Win7系统  按任意键返回主菜单
echo.
pause>nul
goto MENU

:BBER
CLS
ECHO.
ECHO     此操作只适用于Win81和Win10系统 按任意键返回主菜单 
echo.
pause>nul
goto MENU

:DMER
echo.
echo     请下载雨晨提供原始YCDISM\TOOL目录数据并放到 %YCP%TOOL下按任意键继续
echo.
pause>nul
cls
call %0
exit /q

:ERR
CLS
ECHO.
ECHO     没有发现提供必须的核心文件 确定没有被误删除或做任何更改 程序3秒后自动退出
echo.
ping -n 3 127.1 >nul
exit /q

:ERQX
CLS
ECHO.
ECHO     警告 当前用户可能没有继续操作权限或 %~dp0 位置不可写 程序3秒后自动退出
echo.
ping -n 3 127.1 >nul
exit /q

:TUIC
if exist %YCP%YCMOU if not exist %YCP%YCMOU\Windows\system32\config\SOFTWARE (
cmd.exe /c takeown /f "%YCP%YCMOU" /r /d y && icacls "%YCP%YCMOU" /grant administrators:F /t
if exist %YCP%SOFTWAREBKP del /f /q %YCP%SOFTWAREBKP
RMDIR /Q /S "%YCP%YCMOU" >nul 2>nul
)
if exist %YCP%sxs RMDIR /Q /S "%YCP%sxs" >nul 2>nul
echo.
echo   %dqwz% 退出并关闭程序 欢迎再次使用，再见！！！%dqcd%0
echo.
ping -n 3 127.1 >nul
exit /q

:QDSY
title   %dqwz% 为预览版进行去除水印 %dqcd%36
echo.
echo   %dqwz% 为预览版进行去除水印 %dqcd%36
echo.
%SSREG% >nul
Copy /y %YCP%MY\shellbrd\RemoveWatermark%Mbt%.dll %MOU%\Windows\System32\RemoveWatermark.dll 2>nul
set ObName=HKEY_LOCAL_MACHINE\0\Classes\CLSID\{ab0b37ec-56f6-4a0e-a8fd-7a8bf7c2da96}\InProcServer32
set ObType=reg
call :SetACLADMIN
reg add "HKLM\0\Classes\CLSID\{ab0b37ec-56f6-4a0e-a8fd-7a8bf7c2da96}\InProcServer32" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\RemoveWatermark.dll" /f >nul
call :SetACLSYSTEM
if /i "%Mbt%"=="x64" (
set ObName=HKEY_LOCAL_MACHINE\0\Classes\WOW6432Node\CLSID\{ab0b37ec-56f6-4a0e-a8fd-7a8bf7c2da96}\InProcServer32
set ObType=reg
call :SetACLADMIN
reg add "HKLM\0\Classes\WOW6432Node\CLSID\{ab0b37ec-56f6-4a0e-a8fd-7a8bf7c2da96}\InProcServer32" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\RemoveWatermark.dll" /f >nul
call :SetACLSYSTEM
)
)
%UNREG% >nul
title   %dqwc% 为预览版进行去除水印 %dqcd%36
echo.
echo   为预览版进行去除水印操作完成   程序自动返回主菜单
echo.
ping -n 3 127.1>nul
goto MENU

:SetACLADMIN
%SetACL% -on %ObName% -ot %ObType% -actn setowner -ownr "n:administrators;s:y" >NUL
%SetACL% -on %ObName% -ot %ObType% -actn ace -ace "n:administrators;s:y;p:full" >NUL
goto :eof

:SetACLSYSTEM
%SetACL% -on %ObName% -ot %ObType% -actn setowner -ownr "n:TrustedInstaller;s:y" >NUL
%SetACL% -on %ObName% -ot %ObType% -actn ace -ace "n:TrustedInstaller;s:y;p:full" >NUL
goto :eof

:GetNow
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild"') do set MMD=%%a
set MMD=%MMD:~30%
for /f "tokens=1,2*" %%i in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "ProductName"') do set MOS=%%k
for /f "tokens=1,2,3" %%a in ('echo "%MOS%"') do set MNTver=%%a %%b
set MNTver=%MNTver:~1%
if /i "%MNTver%"=="Windows (TM)" SET MEID=WindowsPE &&goto :eof
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "EditionID"') do set MEID=%%a
set MEID=%MEID:~27%
if %MMD% GTR 16299 set MPDPRO=%MEID:~0,3%
if /i "%MPDPRO%"=="" set MOS=%MOS%&&goto :eof
if /i "%MEID%"=="Professional" set MEID=Pro%MEID:~12%&&set MOS=%MNTver% %MEID%
if /i "%MPDPRO%"=="Pro" set MEID=%MEID%&&set MOS=%MNTver% %MEID%
if %MMD% GTR 16299 set MOS=%MNTver% %MEID%
goto :eof

:setEnterpriseNEval
set KEY=MNXKQ-WY2CT-JWBJ2-T68TQ-YBH2V
goto :eof

:setProfessionalSingleLanguage
set KEY=G3KNM-CHG6T-R36X3-9QDG6-8M8K9
goto :eof

:setCoreSingleLanguage
set KEY=BT79Q-G7N6G-PGBYW-4YWX6-6F4BT
goto :eof

:setPro
:setProfessional
set KEY=VK7JG-NPHTM-C97JM-9MPGT-3V66T
goto :eof

:setServerStorageStandard
set KEY=VN8D3-PR82H-DB6BJ-J9P4M-92F6J
goto :eof

:setEnterpriseSEval
set KEY=JBGN9-T2MH3-2YV7W-WBWHM-FGFCG
goto :eof

:setServerStorageWorkgroup
set KEY=48TQX-NVK3R-D8QR3-GTHHM-8FHXC
goto :eof

:setServerRdshCore
set KEY=NJCF7-PW8QT-3324D-688JX-2YV66
goto :eof

:setServerRdsh
set KEY=NJCF7-PW8QT-3324D-688JX-2YV66
goto :eof

:setEnterpriseGN
set KEY=FW7NV-4T673-HF4VX-9X4MM-B4H4T
goto :eof

:setProfessionalWorkstationN
if %MMD% EQU 15063 (set KEY=H7XNC-JYM86-7B27X-8MJ9W-TKFX9) else (set KEY=WYPNQ-8C467-V2W6J-TX4WX-WT2RQ)
goto :eof

:setProfessionalCountrySpecific
set KEY=HNGCC-Y38KG-QVK8D-WMWRK-X86VK
goto :eof

:setCoreN
set KEY=4CPRK-NM3K3-X6XXQ-RXX86-WXCHW
goto :eof

:setServerDatacenterCorCore
set KEY=WH32N-PKDPK-FW7FB-GR8G4-MWTBC
goto :eof

:setProfessionalWorkstation
if %MMD% EQU 15063 (set KEY=RGT4M-CYNRC-2JMPJ-GRVWC-7YMDX) else (set KEY=DXG7C-N36C4-C4HTG-X4T3X-2YV77)
goto :eof

:setEnterpriseSN
set KEY=RW7WN-FMT44-KRGBK-G44WK-QV7YK
goto :eof

:setProfessionalEducation
set KEY=8PTT6-RNW4C-6V7J2-C2D3X-MHBPB
goto :eof

:setCloudN
set KEY=NH9J3-68WK7-6FB93-4K3DF-DJ4F6
goto :eof

:setEducationN
set KEY=84NGF-MHBT6-FXBX8-QWJK7-DRR8H
goto :eof

:setEnterpriseS
set KEY=NK96Y-D9CD8-W44CQ-R8YTK-DYJWX
goto :eof

:setServerDatacenter
set KEY=K6KXM-9DNM4-B4V79-WH2WM-7MJVR
goto :eof

:setEnterpriseN
set KEY=WGGHN-J84D6-QYCPR-T7PJ7-X766F
goto :eof

:setServerDatacenterACor
if %MMD% EQU 15063 (set KEY=P7CCN-72DMB-93C9B-C9PD7-379HK) else (set KEY=VFNKW-XR3VK-9XQFX-X42YX-T84KX)
goto :eof

:setCloud
set KEY=V3WVW-N2PV2-CGWC3-34QGF-VMJ2C
goto :eof

:setServerStandardNano
set KEY=69NHX-WQQ7G-QVBPG-4HPQP-8XDB7
goto :eof

:setProfessionalEducationN
set KEY=GJTYN-HDMQY-FRR76-HVGC7-QPF8P
goto :eof

:setEnterpriseG
set KEY=FV469-WGNG4-YQP66-2B2HY-KD8YX
goto :eof

:setCore
set KEY=YTMG3-N6DKC-DKB77-7M9GH-8HVX7
goto :eof

:setServerStorageStandardCore
set KEY=VN8D3-PR82H-DB6BJ-J9P4M-92F6J
goto :eof

:setServerStandard
set KEY=6DQBR-MN24F-GKG2G-WYFRD-YBJT4
goto :eof

:setServerStandardCor
set KEY=CTB8X-F3NDH-KWF36-KF87X-7XPMF
goto :eof

:setEducation
set KEY=YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY
goto :eof

:setServerDatacenterCore
set KEY=K6KXM-9DNM4-B4V79-WH2WM-7MJVR
goto :eof

:setServerDatacenterCor
set KEY=WH32N-PKDPK-FW7FB-GR8G4-MWTBC
goto :eof

:setProfessionalN
set KEY=2B87N-8KFHP-DKV6R-Y2C8J-PKCKT
goto :eof

:setCoreCountrySpecific
set KEY=N2434-X9D7W-8PF6X-8DV9T-8TYMD
goto :eof

:setServerStandard
set KEY=WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY
goto :eof

:setServerStandardACorCore
set KEY=PTXN8-JFHJM-4WC78-MPCBR-9W4KR
goto :eof

:setProfessionalEducationN
set KEY=YVWGF-BXNMC-HTQYQ-CPQ99-66QFC
goto :eof

:setEnterpriseG
set KEY=YYVX9-NTFWV-6MDM3-9PT4T-4M68B
goto :eof

:setEnterpriseGN
set KEY=44RPN-FTY23-9VTTB-MP9BX-T84FV
goto :eof

:setEnterprise
set KEY=NPPR9-FWDCX-D2C8J-H872K-2YT43
goto :eof

:setCore
set KEY=TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
goto :eof

:setServerStandard
set KEY=WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY
goto :eof

:setProfessionalWorkstationN
set KEY=9FNHH-K3HBT-3W4TD-6383H-6XYWF
goto :eof

:setEducation
set KEY=NW6C2-QMPVW-D7KKK-3GKT6-VCFB2
goto :eof

:setCoreN
set KEY=3KHY7-WNT83-DGQKR-F7HPR-844BM
goto :eof

:setServerDatacenterCore
set KEY=CB7KF-BWN84-R7R2Y-793K2-8XDDG
goto :eof

:setEnterpriseSN
set KEY=QFFDN-GRT3P-VKWWX-X7T3R-8B639
goto :eof

:setProfessionalN
set KEY=MH37W-N47XK-V7XM9-C7227-GCQG9
goto :eof

:setProfessionalEducation
set KEY=6TP4R-GNPTD-KYYHQ-7B7DP-J447Y
goto :eof

:setEducationN
set KEY=2WH4N-8QGBV-H22JP-CT43Q-MDWWJ
goto :eof

:setEnterpriseS
set KEY=DCPHK-NFMTC-H88MJ-PFHPY-QJ4BJ
goto :eof

:setCoreCountrySpecific
set KEY=PVMJN-6DFY6-9CCP6-7BKTT-D3WVR
goto :eof

:setServerDatacenter
set KEY=CB7KF-BWN84-R7R2Y-793K2-8XDDG
goto :eof

:setEnterpriseN
set KEY=DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4
goto :eof

:setServerStandardCore
set KEY=WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY
goto :eof

:setProfessionalWMC
set KEY=GBFNG-2X3TC-8R27F-RMKYB-JK7QT
goto :eof

:setEmbeddedIndustry
set KEY=NDXXJ-YX29Q-JDY6B-C93G8-TQ6WH
goto :eof

:output
echo %n%^:%OSBliuldM%>>%temp%OSBliuld.txt
goto :eof

:SJGNBC
echo.
echo    主要针对从低版本提升到高版本增加低版本没有的打印和UWF功能
echo.
%YCDM% /Image:%MOU% /english /Get-Features>%YCP%Features.txt
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "Printing-PrintToPDFServices-" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "ScanManagementConsole" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "UnifiedWriteFilter" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a /all)
if exist %YCP%Features.txt del /q %YCP%Features.txt
goto :eof

:BJYD
echo.
echo   修改无人值守文件...
echo.
start notepad.exe %MOU%\Windows\Panther\unattend.xml
echo.
echo   自定义电脑或用户名称  请注意编码规范  编辑完成请保存退出即可
echo.
ping -n 3 127.1>nul
goto MENU

:MMZB
%SSREG% >NUL
CALL :GetNow
if "%MEID%"=="Pro" (
if not exist ProfessionalZL.cmd echo set MOS=%MOS%>ProfessionalZL.cmd
if exist %MOU%\Windows\Professional.xml del /q /f %MOU%\Windows\Professional.xml
%UNREG% >NUL
goto :eof
)
if "%MEID%"=="Professional" (
if not exist ProfessionalZL.cmd echo set MOS=%MOS%>ProfessionalZL.cmd
if exist %MOU%\Windows\Professional.xml del /q /f %MOU%\Windows\Professional.xml
%UNREG% >NUL
goto :eof
)
%UNREG% >NUL
echo set MOS=%MOS%>%MEID%ZL.cmd
if exist %MOU%\Windows\%MEID%.xml del /q /f %MOU%\Windows\%MEID%.xml
goto :eof

:BBXM
if "%MEID%"=="Pro" (
if not exist ProfessionalZL.cmd echo set MOS=%MOS%>ProfessionalZL.cmd
if exist %MOU%\Windows\servicing\Editions\ProfessionalEdition.xml Copy /y %MOU%\Windows\servicing\Editions\ProfessionalEdition.xml  %MOU%\Windows\Professional.xml
goto :eof
)
if "%MEID%"=="Professional" (
if not exist ProfessionalZL.cmd echo set MOS=%MOS%>ProfessionalZL.cmd
if exist %MOU%\Windows\Professional.xml del /q /f %MOU%\Windows\Professional.xml
goto :eof
)
echo set MOS=%MOS%>%MEID%ZL.cmd
if exist %MOU%\Windows\servicing\Editions\%MEID%Edition.xml Copy /y %MOU%\Windows\servicing\Editions\%MEID%Edition.xml  %MOU%\Windows\%MEID%.xml
goto :eof