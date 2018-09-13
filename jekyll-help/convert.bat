@echo off
@chcp 65001 >nul
echo run %CMDCMDLINE%
rem --------------------------------------------------------
rem -- Function : 辅助Jekyll发布文章所用，保留源文件markdown文件，生成或同步指定的YAML标签头，合并YAML标签头和源文件生成带时间戳的markdown文件，并支持打开生成的YAML标签头和生成目录以及最终的markdown文件
rem --------------------------------------------------------
if "%~1"=="" (
    set /p msg=参数为空，任意键退出
    exit;
)

:: ----------------------------------------------> 全局变量定义,带下划线
:: -> 执行当前日期2018-07-12格式
set "_DATA="
:: -> 源文件的文件名,无后缀名
set "_FILE_NAME=%~n1"
:: -> 源文件的绝对路径
set "_SOURCE_FILE=%1"
:: -> 生成的文件的目录
set "_DEST_PATH=D:\project\skyc00p.github.io\_posts\"
:: -> 与源文件对应的头标签目录
set "_YAML_PATH=D:\project\skyc00p.github.io\_drafts\yaml\"
:: -> Yaml 头标签绝对路径
set "_YAML_FILE=%_YAML_PATH%%_FILE_NAME%.yaml"
:: -> 操作指令: M 修改，A 添加
set "_CMD="
:: -> 是否开启调试模式
set "_DEBUG=n"
:: -> 头文件是否存在时间属性且符合标准的时间格式
set "_HasDate=N"
:: ----------------------------------------------

:: 初始化参数
call :init

:: 临时测试函数
%_DEBUG%goto F_debug

if /i [%_CMD%] == [A] call :add

if /i [%_CMD%] == [M] call :update

%_exit%

::--------------------------------------------------------
::-- Function : 
::--------------------------------------------------------
:: 创建一个默认的YAML标签头
:: 打开并编辑YAML标签头
:: 合并
:add
echo do add %_toNul%
call :createYaml
if not exist "%_YAML_FILE%" ( 
	echo yaml 头文件创建失败 %_toNul%
	goto:eof	
)

"%_YAML_FILE%"
call :combine

rem 异常情况，不可能到这里
pause
goto:eof

::--------------------------------------------------------
::-- Function : update
rem - 已确定头文件存在，从头文件里获取日期
rem - 如果不存在日期，代表执行 [call :add] 时异常退出或者不符合规范，回显文件内容，询问是否删除，然后退出脚本
rem - 如果存在日期，代表旧文件可能存在，删掉旧文件,回显头文件内容，询问是否打开头文件进行修改，无论如何都进行合并操作
::--------------------------------------------------------

:update
echo do update %_toNul%
call :queryDate
echo _HasDate is %_HasDate% %_toNul%

IF /i [%_HasDate%] == [N] (
	echo.
	echo ------------------------------------------------------------------
	echo: 头标签内容如下. & type "%_YAML_FILE%"
	echo ------------------------------------------------------------------
	echo 没有发现有效的日期，是否删除该头文件?
	echo.
	set /p _ANS="取消请按 [C/c/N/n]，任意键回车确定..."
	
	IF "%_ANS%" == "C" goto:eof
	IF "%_ANS%" == "c" goto:eof
	IF "%_ANS%" == "N" goto:eof
	IF "%_ANS%" == "n" goto:eof
	
	del "%_YAML_FILE%" && echo del yaml suc || echo del yaml fail 
	
	goto:eof
)

call :delOldFile

echo.
echo ------------------------------------------------------------------
echo: 头标签内容如下. & type "%_YAML_FILE%"
echo ------------------------------------------------------------------
echo.
set /p _ANS="是否修改头文件，确认请按 [Y/y]，任意键继续..."
echo.

IF "%_ANS%" == "Y" "%_YAML_FILE%"
IF "%_ANS%" == "y" "%_YAML_FILE%"

call :combine

goto:eof

::--------------------------------------------------------
::-- Function : 
::--------------------------------------------------------
:openDir
echo.
choice /t 3 /d n /m "打开[_post]目录"
if %errorlevel%==1 (start %_DEST_PATH%) else ( echo openDir unknown cmd %_toNul% )
echo openDir done.%_toNul%
goto:eof

::--------------------------------------------------------
::-- Function : 
::--------------------------------------------------------
:openFile
if not exist "%_DEST_PATH%%_DATA%-%_FILE_NAME%.md" ( 
	echo openFile file don't exist
	goto:eof 
)

echo.
choice /t 10 /d n /m "打开生成的markdown文件"
if %errorlevel%==1 ( "%_DEST_PATH%%_DATA%-%_FILE_NAME%.md" ) else ( echo openFile unknown cmd %_toNul% )
goto:eof

::--------------------------------------------------------
::-- Function : 
::--------------------------------------------------------
:combine
if not exist "%_YAML_FILE%" ( echo yaml file not exist & goto:eof )

call :queryDate
if not [%_HasDate%] == [Y] ( echo find no effective data in yaml file & goto:eof )

REM 询问是否要合并
echo ------------------------------------------------------------------
echo: 文本内容如下. & type "%_YAML_FILE%"
echo ------------------------------------------------------------------
echo.
choice /m "是否合并标签头和markdown源文件"
echo.

REM 否的处理，删掉yaml标签文件
IF %errorlevel%==2 (
	del "%_YAML_FILE%"
	echo del yaml suc.. %_toNul%
	goto:eof
)

REM 是的处理，合并
if %errorlevel%==1 (
	echo ["%_DEST_PATH%%_DATA%-%_FILE_NAME%.md"] 合并。%_toNul%
	copy /y "%_YAML_FILE%" /B + %_SOURCE_FILE% /B "%_DEST_PATH%%_DATA%-%_FILE_NAME%.md" /B %_toNul%
	call :openDir
	call :openFile
	goto:eof
)

goto:eof

::--------------------------------------------------------
::-- Function : 
::--------------------------------------------------------
:delOldFile
if not exist "%_DEST_PATH%%_DATA%-%_FILE_NAME%.md" (
	echo [delOldFile] 旧文件不存在 %_toNul% 
	goto:eof 
)

echo del right now "%_DEST_PATH%%_DATA%-%_FILE_NAME%.md" %_toNul% 
echo.
echo Waring : 当前更新的源文件已经在[_post]目录存在对应的副本.
choice /m "是否删除" 
echo.

if %errorlevel%==1 ( 
	del "%_DEST_PATH%%_DATA%-%_FILE_NAME%.md"
	echo [delOldFile] return code %ERRORLEVEL% %_toNul% 
) else ( echo delOldFile unknown cmd %_toNul% )
goto:eof

::--------------------------------------------------------
::-- Function : 
::--------------------------------------------------------
:F_debug
echo debuging...
echo cmd line is %CMDCMDLINE%
%_pause%
rem call :openDir
rem call :add
call :update
rem call :checkDate "   2018-01-03    "
rem pause
rem call :checkDate
rem pause
rem call :checkDate "2018-01-01"
rem pause
rem call :checkDate ""2018-01-02""
rem pause
rem call :checkDate ""   2018-01-04    ""
rem pause
rem call :checkDate "胜多负少的"
rem pause
rem call :checkDate "asdasd"
rem pause
rem call :checkDate "胜多负少的asdasdasd"
rem pause
rem call :checkDate "1616131651"
rem pause
rem call :checkDate "胜多asdasd负231231少的"
rem pause
rem call :checkDate "胜多负123少的1231"
rem pause
rem call :checkDate "asdas123123"
rem pause
rem call :checkDate "1235-41-51 11-15-1"
rem pause
rem echo done checkDate [new _DATA is %_DATA%, new _HasDate is %_HasDate%] %_toNul%
%_exit%

::--------------------------------------------------------
::-- Function : 创建Yaml头标签
::--------------------------------------------------------
:createYaml
%_DEBUG%echo create yaml

echo ---> "%_YAML_FILE%"
echo layout: post >> "%_YAML_FILE%"
echo date: %_DATA% >> "%_YAML_FILE%"
echo title: "%_FILE_NAME%" >> "%_YAML_FILE%"
echo categories: >> "%_YAML_FILE%"
echo tags: >> "%_YAML_FILE%"
echo author: skycoop >> "%_YAML_FILE%"
echo --- >> "%_YAML_FILE%"
echo:>> "%_YAML_FILE%"
echo * content >> "%_YAML_FILE%"
echo {:toc} >> "%_YAML_FILE%"
echo:>> "%_YAML_FILE%"

%_DEBUG%if exist "%_YAML_FILE%" echo. & type "%_YAML_FILE%"
goto:eof

::--------------------------------------------------------
::-- Function : 
::--------------------------------------------------------
:queryDate
for /f "usebackq skip=1 tokens=1,* delims=: " %%a in ("%_YAML_FILE%") do (
    if "date" == "%%a" call :checkDate "%%b"
)
goto:eof

::--------------------------------------------------------
rem 如果有有效的日期，则设置为 _DATA 和 _HasDate 为 Y
rem 日期格式不符合规格，则置空 _DATA 以及设置 _HasDate 为 N
::--------------------------------------------------------
:checkDate
set "d=%*"
echo d1 is "%d%" %_toNul%

set "d=%d: =%"
echo d2 is "%d%" %_toNul%

set "d=%d:"=%"
echo d3 is "%d%" %_toNul%

if ["%d%"] == [""] (
	set "_HasDate=N" & set "_DATA="
	echo [new _DATA is nul, new _HasDate is N] %_toNul%
	set "d="
	goto:eof
)

if ["%d%"] == [" ="] (
	set "_HasDate=N" & set "_DATA="
	echo [new _DATA is nul, new _HasDate is N] %_toNul%
	set "d="
	goto:eof
)

echo "%d%" | findstr /r /c:"^\"[1-9][0-9][0-9][0-9]\-[0-9][0-9]\-[0-9][0-9]\"" > tmp.txt
for /f "tokens=*" %%i in (tmp.txt) do set "str=%%i"
if exist tmp.txt del tmp.txt

echo [the str is %str%] %_toNul%
if not ["%str%"] == [""] (
	set "_DATA=%d%"
	set "_HasDate=Y"
) else (
	set "_HasDate=N"
	set "_DATA="
)

set "d="
set "str="
echo [new _DATA is %_DATA%, new _HasDate is %_HasDate%] %_toNul%
goto:eof

::--------------------------------------------------------
::-- Function : 初始化参数
::--------------------------------------------------------
:init

:: - _DATA
setlocal
FOR /f %%a in ('WMIC OS GET LocalDateTime ^| find "."') DO Set _DTS=%%a
Set data=%_DTS:~0,4%-%_DTS:~4,2%-%_DTS:~6,2%
endlocal & set _DATA=%data%

:: - _CMD
setlocal
if exist "%_YAML_FILE%" ( set "cmd=M" ) else ( set "cmd=A" )
endlocal & set _CMD=%cmd%

rem - _DEBUG
rem - _toNul
rem - _pause
rem - _exit
rem - _echoY , _echoN
setlocal
set "toNul=^>nul"
set "debug=REM "
set "breakpoint="
set "exit=exit"
set "echoY="
set "echoN="
if /i [%_DEBUG%] == [Y] set "debug=" & set "toNul=" & set "breakpoint=pause" & set "exit=pause & exit" & set "echoY=@echo on" & set "echoN=@echo off"
if /i [%_DEBUG%] == [y] set "debug=" & set "toNul=" & set "breakpoint=pause" & set "exit=pause & exit" & set "echoY=@echo on" & set "echoN=@echo off"

endlocal & (set _DEBUG=%debug% & set _toNul=%toNul% & set "_pause=%breakpoint%" & set "_exit=%exit%" & set "_echoY=%echoY%" & set "_echoN=%echoN%")

:: 显示所有的全局变量
echo:-----------------------------------------------
set _
echo:-----------------------------------------------
echo:

goto:eof