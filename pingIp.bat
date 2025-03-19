@echo off
setlocal enabledelayedexpansion

REM ���û�д����κβ�������ʾ������Ϣ
if "%~1"=="" (
    echo ʹ�÷�����
    echo %~nx0 [��ַ��] [����ļ�·��]
    echo.
    echo ʾ����
    echo %~nx0 192.168.1.1-192.168.1.10 C:\output.txt
    echo.
    echo ˵����
    echo - ��ַ�θ�ʽ����ʼIP-����IP������ 192.168.1.1-192.168.1.254
    echo - ����ļ�·�������ڱ������pingͨ��IP��ַ���ļ�·��
    exit /b 1
)

REM �������ļ�·������
if "%~2"=="" (
    echo �����봫������ļ�·��������
    echo.
    echo ʹ�÷�����
    echo %~nx0 [��ַ��] [����ļ�·��]
    exit /b 1
)

REM ��ȡ��ַ�κ�����ļ�·��
set address_range=%~1
set output_file=%~2

REM �������ļ�
echo. > "%output_file%"

REM ��ȡ��ַ�ε���ʼ�ͽ���IP
for /f "tokens=1,2 delims=-" %%a in ("%address_range%") do (
    set start_ip=%%a
    set end_ip=%%b
)

REM ����ʼIP�ͽ���IPת��Ϊ����
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

REM ������ַ�β�pingÿ��IP
for /l %%a in (%start_octet1%,1,%end_octet1%) do (
    for /l %%b in (%start_octet2%,1,%end_octet2%) do (
        for /l %%c in (%start_octet3%,1,%end_octet3%) do (
            for /l %%d in (%start_octet4%,1,%end_octet4%) do (
                set ip=%%a.%%b.%%c.%%d
                echo ����ping !ip!...
                ping -n 1 -w 100 !ip! >nul
                if !errorlevel!==0 (
                    echo !ip! ����pingͨ��
                    echo !ip! >> "%output_file%"
                ) else (
                    echo !ip! �޷�pingͨ��
                )
            )
        )
    )
)

echo Ping��ɣ������д�� %output_file%