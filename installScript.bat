@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0"
set "installPath=%LOCALAPPDATA%\Vivaldi\Application\"
echo Searching at: %installPath%

for /f "tokens=*" %%a in ('dir /a:-d /b /s "%installPath%"') do (
    if /i "%%~nxa"=="window.html" set "latestVersionFolder=%%~dpa"
)

if "!latestVersionFolder!"=="" (
    echo Could not find Vivaldi installation.
    pause & exit /b
)
echo Found latest version folder: "!latestVersionFolder!"

if not exist "!latestVersionFolder!window.bak.html" (
    echo Creating backup...
    copy "!latestVersionFolder!window.html" "!latestVersionFolder!window.bak.html" >nul
)

echo Building custom.js...
type "*.js" > "!latestVersionFolder!custom.js"

echo Patching window.html...
set "pyFile=%temp%\vivaldi_patch.py"
set "bakFile=!latestVersionFolder!window.bak.html"
set "outFile=!latestVersionFolder!window.html"

> "%pyFile%" echo bak = r"!bakFile!"
>> "%pyFile%" echo out = r"!outFile!"
>> "%pyFile%" echo src = open(bak, "rb").read()
>> "%pyFile%" echo inject = b"    <script src='custom.js'></script>" + b"\n"
>> "%pyFile%" echo patched = src.replace(b"</body>", inject + b"</body>", 1)
>> "%pyFile%" echo open(out, "wb").write(patched)
>> "%pyFile%" echo print("Injected!" if inject in patched else "WARNING: </body> not found!")

python "%pyFile%"

echo Done!
pause