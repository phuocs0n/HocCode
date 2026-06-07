@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM =============================================
REM AUTO GIT PUSH SCRIPT
REM Tu dong commit va push code len GitHub
REM =============================================

echo.
echo ==============================================================
echo     AUTO GIT PUSH
echo     Tu dong luu code len GitHub
echo ==============================================================
echo.

REM Kiem tra xem co thu muc .git khong
if not exist ".git" (
    echo [Loi] Thu muc hien tai chua duoc khoi tao la mot kho luu tru Git.
    echo Vui long chay 'git init' truoc de su dung.
    echo.
    pause
    exit /b 1
)

REM Kiem tra xem co thay doi khong
git status --porcelain > temp_status.txt
set STATUS=
set /p STATUS=<temp_status.txt
del temp_status.txt

if "!STATUS!"=="" (
    echo [INFO] Khong co file nao bi thay doi. Code cua ban dang duoc cap nhat moi nhat!
    echo.
    pause
    exit /b 0
)

REM Hien thi cac file thay doi
echo [FILES] Cac file da thay doi:
echo --------------------------------------------------------------
git status --short
echo --------------------------------------------------------------
echo.

REM Hoi commit message
set COMMIT_MSG=
set /p COMMIT_MSG="[INPUT] Nhap noi dung commit (Nhan Enter de tu dong tao theo thoi gian): "

REM Neu khong nhap, dung message mac dinh voi timestamp
if "!COMMIT_MSG!"=="" (
    set COMMIT_MSG=Auto update: !date! !time!
)

echo.
echo [COMMIT] Thong diep: !COMMIT_MSG!
echo.

REM Add tat ca cac file
echo [1/3] Dang them file vao Git (git add)...
git add -A
if !errorlevel! neq 0 (
    echo [ERROR] Co loi xay ra khi them file!
    pause
    exit /b 1
)
echo      -^> OK

REM Commit
echo [2/3] Dang luu cac thay doi (git commit)...
git commit -m "!COMMIT_MSG!"
if !errorlevel! neq 0 (
    echo [ERROR] Co loi xay ra khi commit!
    pause
    exit /b 1
)
echo      -^> OK

REM Push
echo [3/3] Dang day code len GitHub (git push)...
REM Kiem tra xem nhanh hien tai la main hay master de push cho dung
for /f "tokens=*" %%a in ('git branch --show-current') do set CURRENT_BRANCH=%%a

if "!CURRENT_BRANCH!"=="" (
    echo [ERROR] Khong xac dinh duoc nhanh hien tai. Co the ban chua co commit nao.
    pause
    exit /b 1
)

git push origin !CURRENT_BRANCH!
if !errorlevel! neq 0 (
    echo.
    echo [WARNING] Day len that bai theo cach thong thuong. Thu day len voi quyen ep buoc an toan (force-with-lease)...
    git push origin !CURRENT_BRANCH! --force-with-lease
    if !errorlevel! neq 0 (
        echo [ERROR] Khong the day code len GitHub! Hay kiem tra lai ket noi mang hoac quyen truy cap kho luu tru.
        pause
        exit /b 1
    )
)
echo      -^> OK

echo.
echo ==============================================================
echo     DA DAY CODE LEN GITHUB THANH CONG!
echo ==============================================================
echo.
echo [INFO] Commit moi nhat cua ban:
git log -1 --oneline
echo.

pause
