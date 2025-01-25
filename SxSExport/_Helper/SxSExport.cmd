REM
REM Autor: KNARZ
REM Purpose: Export Windows Packages (the easy way)
REM          The script is intended to work with default system UI language.
REM Credits and best whishes to Melinda / Aunty Mel.
REM Also some credit to Alex Ionescu
REM
REM V.1
REM

@echo off & cls & mode 80, 45 & color 1b
setlocal EnableDelayedExpansion

pushd %~dp0
call definitions.cmd

::Flags
set Loop=1
set Flag_AskImage=0
set Flag_Log=0

::Examples
::You can overwrite values.
REM set Flag_AskImage=0
set Path_Image=%SystemRoot%
REM set Path_Image=E:\
REM set ImportList=C:\Kit\Win10\SomeList.txt

::More flags but not recommended to change
set Flag_NoAutoMUI=0
set Flag_CAB=1

::Workflow
call :AutoExportCheck %ImportList%
call :AskImagePath Path_Image
call :PackagesEnum "BaseMUM"

:Loop
call :SelectItem		"BaseMUM"
call :PackageExport		"%BaseMUM%"
if /i [%Flag_NoAutoMUI%] == [1] (
if NOT defined FirstRun	(call :PackagesEnum	MuiMUM "%MUI%")
	call :SelectItem	"MuiMUM"
	call :PackageExport	"!MuiMUM!"
) else (
	call :ShortBasicName	BaseMUM
	call :PackageAutoSearch	"!BaseMUM!" "~%MUI%~"
)
set FirstRun=1
call :VarClear BaseMUM
call :VarClear MuiMUM

if defined Loop goto :Loop
call :TextIntro "全部完成..."

popd
endlocal
exit /b



::------------------------------------------------------------------------------
::Routines
::------------------------------------------------------------------------------
:AskImagePath
if NOT defined Path_Image if /i [%Flag_AskImage%] == [1] (
	call :TextIntro	"请输入您要使用的Windows 镜像路径，例如："
	call :TextInfo	"'D:\Mount\Enterprise'"
	call :TextInfo	"C: &echo."
	call :TextInfo	"如果要从安装的映像中导出匹配的语言包"
	call :TextOutro	"例子: 'D:\Mount\Enterprise en-US'
	call :SelectImageSource	"%~1"
)
if NOT [%~2] == []	(set "MUI=%~2")
if NOT exist "%Path_Image%" (call :ThrowMessage "NotFound" "%Path_Image%")
goto :EOF

:AutoExportCheck
if exist "%~1" (
	call :TextIntro	"自动导出模式..."
	call :TextOutro	"echo. & echo 仅找到并导出显示的包。"
	for /f %%i in (%ImportList%) do (
		call :PackageAutoSearch "%%i" "~~"
		call :PackageAutoSearch "%%i" "~%MUI%~"
	)
	call :ThrowMessage "完成"
)
goto :EOF

:PackageAutoSearch
for /f "tokens=*" %%l in ('dir /b /o-d "%Path_Image%\%PathRel_Packages%\%~1~*%~2*.mum" 2^>nul') do (
	REM Unfortunatly with no Items 'for' stops immediately.
	if ErrorLevel 1 (goto :EOF)
	call :PackageExport "%%~nl"
)
goto :EOF

:PackageExport
for /f "tokens=1,3,4,5 delims=~" %%i in ("%~1") do (
	if [%%l] == [] (
	set Folder_PathExport=%%j\%%k
	set File_ExportName=%%i-%%j-%%k
	set "PackageName=%%i"
	) else (
	set Folder_PathExport=%%j\%%l\%%k
	set File_ExportName=%%i-%%j-%%l-%%k
	set "PackageName=%%i (%%k)"
	)
	echo 进行中: !PackageName!
)
if NOT exist "%Path_Export%\%Folder_PathExport%" (md "%Path_Export%\%Folder_PathExport%")
if /i [%Flag_CAB%] == [1] (set "Path_ExportFile=%Path_Export%\%Folder_PathExport%\%File_ExportName%.cab") else (set "Path_ExportFile=%Path_Export%\%Folder_PathExport%\%File_ExportName%")
if /i [%Flag_Log%] == [1] (set "LogFile=%Path_Export%\%Folder_PathExport%\%File_ExportName%.log") else (set "LogFile=nul")
%Tool_SxSExtract% /IMAGE:"%Path_Image%" %Parameter_SxSExtract% "%Path_Image%\%PathRel_Packages%\%~1.mum" "%Path_ExportFile%" > %LogFile%
timeout.exe /t 2 > nul
goto :EOF

:PackagesEnum
set Tip=
set Search=
if /i [%~1] == [BaseMUM] (
	set "Tip=Base-Package/s"
	set "Search=dir /b /o-d "%Path_Image%\%PathRel_Packages%\*Package*~*~~*.mum^""
	set "File_PackageList=%Path_Root%\_Packagelist_Base.txt
	call :TextIntro	"基本组件包列表 生成中..."
)
if /i [%~1] == [MuiMUM] (
	set "Tip=MUI-Package/s"
	set "Search=dir /b /o-d "%Path_Image%\%PathRel_Packages%\*Package*~%MUI%~*.mum^""
	set "File_PackageList=%Path_Root%\Packagelist_%MUI%.txt
	call :TextIntro	" MUI (%MUI%) 组件包列表 生成中..."
)
call :Selection	"%~1" "!Search!"
call :TextInfo	"请看:"
call :TextInfo	"'%File_PackageList%'"
call :TextOutro	"并键入您要导出的 !Tip:~,-2! 基本组件包的编号。"
goto :EOF

:Selection
type nul > %File_PackageList%
set /a CNT=0
for /f "tokens=*" %%f in ('%~2 ^| findstr.exe /i /v "_for_KB" ^| sort') do (
	set /a CNT+=1
	set "%~1!CNT!=%%~nf"
		for /f "tokens=1 delims=~" %%i in ("%%~f") do (
		REM echo 	!CNT!^) %%~i
		echo !CNT!;	%%~i>> %File_PackageList%
	)
)
echo.
goto :EOF

:SelectImageSource
set /p Imagepath=^>
if /i [%Imagepath%] == []		(call :ThrowMessage "Invalid")
set "%~1=%Imagepath%\Windows"
goto :EOF

:SelectItem
set /p SelNum=^>
if /i [%SelNum%] == []		(call :ThrowMessage "Invalid")
if /i [%SelNum%] == [X]		(call :ThrowMessage "Abort")
if %SelNum% LEQ 0			(call :ThrowMessage "Range")
if %SelNum% GTR %CNT%		(call :ThrowMessage "Range")
set "%~1=!%~1%SelNum%!"
set "SKIP="
REM timeout.exe /t 2 >nul
goto :EOF

:ShortBasicName
for /f "tokens=1 delims=~" %%i in ("!%~1!") do (set "%~1=%%i")
goto :EOF

:VarClear
set "%~1="
goto :EOF

:TextIntro
echo.
echo       %~1
echo %Line%
goto :EOF

:TextOutro
echo       %~1
echo %Line%
echo.
goto :EOF

:TextInfo
echo       %~1
goto :EOF

:ThrowMessage
echo.
if /i [%~1] == [Done] (
	echo 所有操作已完成。
)
if /i [%~1] == [NotFound] (
	echo %~2 找不到。
)
if /i [%~1] == [Invalid] (
	echo 输入无效。
)
if /i [%~1] == [Abort] (
	echo 进程被用户中止。
)
if /i [%~1] == [Range] (
	echo 所选号码超出范围。
)
echo.
echo 按任意键退出窗口...
pause >nul
exit