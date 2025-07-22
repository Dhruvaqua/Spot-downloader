@echo off
:: spotify_playlist_audio_downloader.bat
:: Spotify playlist/track downloader with skip-existing, using spotdl

:: === CONFIGURATION ===
set SAVE_ROOT=%USERPROFILE%\Downloads\spotify-audio
set /p SUBFOLDER_NAME="Enter folder name for this download (e.g., playlist name): "
if "%SUBFOLDER_NAME%"=="" set SUBFOLDER_NAME=default
set SAVE_PATH=%SAVE_ROOT%\%SUBFOLDER_NAME%

:: === CREATE SAVE DIRECTORY ===
if not exist "%SAVE_PATH%" mkdir "%SAVE_PATH%"

:: === INPUT SPOTIFY URL ===
set /p SPOTIFY_URL="Paste Spotify Playlist or Track URL: "

:: === INPUT DOWNLOAD LIMIT ===
echo How many files do you want to download? (e.g., 1, 2, all)
set /p USER_DOWNLOAD_COUNT="Enter number or 'all': "

:: === DETERMINE IF --limit IS NEEDED ===
set LIMIT_FLAG=
if /i not "%USER_DOWNLOAD_COUNT%"=="all" (
    set LIMIT_FLAG=--limit %USER_DOWNLOAD_COUNT%
)

:: === LOGGING SETUP ===
set LOGFILE=%SAVE_PATH%\spotdl_log.txt

:: === EXECUTION ===
echo.
echo Starting download with spotdl...
cd /d "%SAVE_PATH%"
spotdl download %SPOTIFY_URL% %LIMIT_FLAG% --overwrite skip > "%LOGFILE%" 2>&1

:: === CHECK SUCCESS ===
echo.
findstr /C:"Downloaded" "%LOGFILE%" >nul
if %errorlevel%==0 (
    echo Download completed successfully.
    powershell -Command "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Download completed successfully. Files saved to: %SAVE_PATH%','spotdl Downloader')"
) else (
    echo Some downloads may have failed or were skipped. Check log: %LOGFILE%
    powershell -Command "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Some downloads may have failed or were skipped. Check log at: %LOGFILE%','spotdl Downloader - Status')"
)

:: === OPEN FOLDER ===
explorer "%SAVE_PATH%"

pause
