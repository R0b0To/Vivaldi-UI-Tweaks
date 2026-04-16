@echo off
cd "%~dp0"

set "installPath=%LOCALAPPDATA%\Vivaldi\Application"
set "latestVersionFolder="

echo Searching at: %installPath%

for /d %%d in ("%installPath%\*") do (
    if exist "%%d\resources\window.html" (
        set "latestVersionFolder=%%d\resources"
    )
)

if "%latestVersionFolder%"=="" (
    echo Could not find Vivaldi installation.
    pause & exit
)

echo Found latest version folder: "%latestVersionFolder%"

if not exist "%latestVersionFolder%\window.bak.html" (
    echo Creating backup...
    copy "%latestVersionFolder%\window.html" "%latestVersionFolder%\window.bak.html"
)

echo Building custom.js...
type *.js > "%latestVersionFolder%\custom.js"

echo Patching window.html...

(
    type "%latestVersionFolder%\window.bak.html" | findstr /v "</body>" | findstr /v "</html>"
    echo     ^<script src="custom.js"^>^</script^>
    echo   ^</body^>
    echo ^</html^>
) > "%latestVersionFolder%\window.html"

echo Done!
pause