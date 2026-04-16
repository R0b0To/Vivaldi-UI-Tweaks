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

if not exist "!latestVersionFolder!\window.bak.html" (
    echo Creating backup...
    copy "!latestVersionFolder!\window.html" "!latestVersionFolder!\window.bak.html" >nul
)

echo Building custom.js...
type "*.js" > "!latestVersionFolder!\custom.js"

echo Patching window.html...

type "!latestVersionFolder!\window.bak.html" ^
| findstr /v /c:"</body>" ^
| findstr /v /c:"</html>" ^
> "!latestVersionFolder!\window.html"

(
    echo     ^<script src="custom.js"^>^</script^>
    echo   ^</body^>
    echo ^</html^>
) >> "!latestVersionFolder!\window.html"

echo Done!
pause
