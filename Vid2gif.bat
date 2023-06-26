@echo off
echo.
echo ******************************************
echo          Video2Gif FFMPEG Script
echo.
echo      *********************************
echo      **          Wex Naozumi        **
echo      **                             **
echo      **  https://github.com/Wexnaoz **
echo      **                             **
echo      *********************************
echo.
echo ******************************************
echo.

REM Input file path (MP4)
:input
set /p "input=Input File: "
if "%input%"=="" goto input

REM Output file path (GIF)
:output
set /p "output=Output: "
if "%output%"=="" goto output

REM Start time HH:MM:SS
:start_time
set /p "start_time=Start Time: "
if "%start_time%"=="" goto start_time

REM Duration in seconds
:duration
set /p "duration=Duration: "
if "%duration%"=="" goto duration

REM Gif scale
:scale
set /p "scale=Scale: "
if "%scale%"=="" goto scale

REM Create a temporary palette in PNG, convert to gif and then delete the temporary palette
ffmpeg -v warning -ss "%start_time%" -t "%duration%" -i "%input%" -vf "scale=%scale%:-1:flags=lanczos,palettegen=stats_mode=diff" -y "%output%temp_palette.png"
ffmpeg -v warning -ss "%start_time%" -t "%duration%" -i "%input%" -i "%output%temp_palette.png" -lavfi "scale=%scale%:-1:flags=lanczos [x]; [x][1:v] paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" -y "%output%GIF.gif"

echo **DONE**

del "%output%temp_palette.png"

choice /c yn /m "Do you want to continue? Press 'y' and Enter for Yes: "
if errorlevel 2 exit /b
goto input
