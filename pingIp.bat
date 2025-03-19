@echo off
setlocal enabledelayedexpansion

REM 如果没有传入任何参数，显示帮助信息
if "%~1"=="" (
    echo 使用方法：
    echo %~nx0 [地址段] [输出文件路径]
    echo.
    echo 示例：
    echo %~nx0 192.168.1.1-192.168.1.10 C:\output.txt
    echo.
    echo 说明：
    echo - 地址段格式：起始IP-结束IP，例如 192.168.1.1-192.168.1.254
    echo - 输出文件路径：用于保存可以ping通的IP地址的文件路径
    exit /b 1
)

REM 检查输出文件路径参数
if "%~2"=="" (
    echo 错误：请传入输出文件路径参数。
    echo.
    echo 使用方法：
    echo %~nx0 [地址段] [输出文件路径]
    exit /b 1
)

REM 获取地址段和输出文件路径
set address_range=%~1
set output_file=%~2

REM 清空输出文件
echo. > "%output_file%"

REM 提取地址段的起始和结束IP
for /f "tokens=1,2 delims=-" %%a in ("%address_range%") do (
    set start_ip=%%a
    set end_ip=%%b
)

REM 将起始IP和结束IP转换为数字
for /f "tokens=1-4 delims=." %%a in ("%start_ip%") do (
    set start_octet1=%%a
    set start_octet2=%%b
    set start_octet3=%%c
    set start_octet4=%%d
)

for /f "tokens=1-4 delims=." %%a in ("%end_ip%") do (
    set end_octet1=%%a
    set end_octet2=%%b
    set end_octet3=%%c
    set end_octet4=%%d
)

REM 遍历地址段并ping每个IP
for /l %%a in (%start_octet1%,1,%end_octet1%) do (
    for /l %%b in (%start_octet2%,1,%end_octet2%) do (
        for /l %%c in (%start_octet3%,1,%end_octet3%) do (
            for /l %%d in (%start_octet4%,1,%end_octet4%) do (
                set ip=%%a.%%b.%%c.%%d
                echo 正在ping !ip!...
                ping -n 1 -w 100 !ip! >nul
                if !errorlevel!==0 (
                    echo !ip! 可以ping通。
                    echo !ip! >> "%output_file%"
                ) else (
                    echo !ip! 无法ping通。
                )
            )
        )
    )
)

echo Ping完成，结果已写入 %output_file%