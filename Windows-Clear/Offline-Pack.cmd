@ECHO OFF
::网址：nat.ee
::批处理：荣耀&制作 QQ:1800619
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

::配置
:head
CLS
ECHO 离线封装 Windows 系统
ECHO.
ECHO 使用前，请把所需的文件放进相应文件夹
ECHO.
ECHO 说明：
ECHO iso 文件夹，存放(仅1个)ISO系统镜像
ECHO packages 文件夹，存放补丁文件
ECHO driver 文件夹，存放驱动文件
ECHO vhd 文件夹，存放(仅1个).vhd格式虚拟硬盘
ECHO 更多详情……请阅读 _ReadMe.txt 文档
ECHO.
ECHO 准备工作
ECHO 请设置操作的VHD虚拟硬盘分区盘符/路径
ECHO.
ECHO 例如：Z:
ECHO.
ECHO 按回车键(Enter),确定
SET /p diskdir=路径:
IF NOT EXIST "%diskdir%" (
CLS
ECHO 设置硬盘分区路径有误，请重试。
ECHO.
TIMEOUT 3 >NUL
GOTO:head
EXIT
)

::菜单
:menu
TITLE 离线封装系统
CLS
ECHO 当前操作分区：%diskdir%
ECHO.
ECHO 1.安装系统
ECHO.
ECHO 2.安装补丁
ECHO.
ECHO 3.安装驱动
ECHO.
ECHO 4.无人值守
ECHO.
ECHO 5.生成wim文件
ECHO.
choice /C:12345 /N /M "请输入你的选择 [1-5]"：
if errorlevel 5 GOTO:wim-file
if errorlevel 4 GOTO:apply-unattend
if errorlevel 3 GOTO:install-driver
if errorlevel 2 GOTO:install-packages
if errorlevel 1 GOTO:install-win

::安装系统
:install-win
CLS
for /f %%i in ('dir /b %~dp0iso^|findstr "^.*\.iso$"') do (set winisofile=%%i)
IF NOT EXIST "%~dp0iso\install.wim" (
IF DEFINED winisofile (
ECHO 正在提取 install.wim 文件
%~dp0bin\%os%\7z.exe e -y "%~dp0iso\%winisofile%" "sources\install.wim" -o"%~dp0iso"
IF NOT EXIST "%~dp0iso\install.wim" (
CLS
ECHO.
ECHO 警告：
ECHO %winisofile%
ECHO 不是有效的Windows ISO 镜像文件。
ECHO 没有提取到 install.wim 文件。
ECHO 请重试……
ECHO.
PAUSE
GOTO:menu
EXIT
)
ECHO.
ECHO 提取完成。
ECHO.
TIMEOUT 3 >NUL
)ELSE (
CLS
ECHO.
ECHO 系统镜像ISO文件不存在，请先下载Windows系统镜像。
ECHO 把下载好的ISO系统镜像，复制到 iso 文件夹。
ECHO 注意：iso 文件夹，只能存在一个.iso文件！
ECHO.
PAUSE
GOTO:menu
EXIT
)
)
CLS
%Dism% /Get-ImageInfo /ImageFile:"%~dp0iso\install.wim"||ECHO.&&PAUSE&&GOTO:menu
ECHO.
ECHO 按回车键(Enter),确定
SET /p ov=请输入安装的索引数字：
ECHO.
%imagex% /apply "%~dp0iso\install.wim" "%ov%" "%diskdir%"||ECHO.&&PAUSE&&GOTO:menu
:: %bcdboot% "%diskdir%\Windows" /s "%diskdir%" /f BIOS /l zh-CN
ECHO 安装完成。
ECHO.
TIMEOUT 3 >NUL
GOTO:menu
EXIT

::安装补丁
:install-packages
CLS
IF EXIST "%diskdir%\Windows\servicing\Packages" (
%Dism% /Image:"%diskdir%" /Add-Package /PackagePath:"%~dp0packages" /IgnoreCheck||ECHO.&&PAUSE&&GOTO:menu
)ELSE (
CLS
ECHO 系统错误，无法安装补丁，请重试！
ECHO.
TIMEOUT 5 >NUL
GOTO:menu
EXIT
)


::安装驱动
:install-driver
CLS
IF EXIST "%diskdir%\Windows\System32\drivers" (
%Dism% /Image:"%diskdir%" /Add-Driver /Driver:%~dp0driver /Recurse /ForceUnsigned||ECHO.&&PAUSE&&GOTO:menu
)ELSE (
CLS
ECHO 系统错误，无法安装驱动，请重试！
ECHO.
TIMEOUT 5 >NUL
GOTO:menu
EXIT
)


::无人值守
:apply-unattend
CLS
ECHO Windows系统-添加无人值守
ECHO.
ECHO 以Administrator空密码自动登录
ECHO.
ECHO 1.Windows 7 32位
ECHO 2.Windows 7 64位
ECHO 3.Windows 8.1 32位
ECHO 4.Windows 8.1 64位
ECHO 5.Windows 10 32位
ECHO 6.Windows 10 64位
ECHO.
SET /p winauto=请输入选择，按回车：
IF "%winauto%" == "1" (SET unattend=Windows7x86.xml)
IF "%winauto%" == "2" (SET unattend=Windows7amd64.xml)
IF "%winauto%" == "3" (SET unattend=Windows8.1x86.xml)
IF "%winauto%" == "4" (SET unattend=Windows8.1amd64.xml)
IF "%winauto%" == "5" (SET unattend=Windows10x86.xml)
IF "%winauto%" == "6" (SET unattend=Windows10amd64.xml)
CLS
IF EXIST "%diskdir%\Windows\System32\sysprep\sysprep.exe" (
ECHO 正在添加无人值守……
ECHO.
RMDIR /s /q "%diskdir%\Windows\Panther" 1>nul 2>nul
MD "%diskdir%\Windows\Panther" 1>nul 2>nul
COPY /y "%~dp0bin\unattend\%unattend%" "%diskdir%\Windows\Panther\Unattend.xml"
ECHO.
ECHO 添加完成。
ECHO.
TIMEOUT 3 >NUL
GOTO:menu
EXIT
)ELSE (
CLS
ECHO.
ECHO 系统错误，无法添加，请重试。
ECHO.
TIMEOUT 5 >NUL
GOTO:menu
EXIT
)

:wim-file
CLS
TITLE 压缩生成过程中,请勿退出此窗口。
ECHO 压缩文件中.....
for /f %%t in ('echo %time:~0,2%%time:~3,2%%time:~6,2%') DO (SET newtime=%%t)
%imagex% /capture "%diskdir%" "%~dp0\export\%newtime%-install.wim" "Windows" /COMPRESS maximum||PAUSE&&GOTO:menu
ECHO 压缩生成文件完成。
ECHO 在 export 文件夹
ECHO 文件：%newtime%-install.wim
ECHO.
PAUSE
GOTO:menu
EXIT

::检测空格目录
:errdir
CLS
ECHO %~0
ECHO 检测到工具包存放在带有空格的目录
ECHO 请把工具包放在不带空格的目录，否则出错！
PAUSE
EXIT
