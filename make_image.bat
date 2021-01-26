rem echo OFF
mkdir build
echo Unmounting old image ...
osfmount.com -D -m X:

echo Assembling ...
tools\sjasmplus\sjasmplus.exe gifview.asm --lst=gifview.lst
if errorlevel 1 goto ERR

echo Preparing floppy disk image ...
copy /Y image\dss_image.img build\gifviewer.img
rem Delay before copy image
timeout 2 > nul
osfmount.com -a -t file -o rw -f build/gifviewer.img -m X:
if errorlevel 1 goto ERR
mkdir X:\GIFVIEW\EXAMPLES
copy /Y gifview.exe /B X:\GIFVIEW\ /B
copy /Y examples\moroz.gif /B X:\GIFVIEW\EXAMPLES\ /B
copy /Y examples\pirate.gif /B X:\GIFVIEW\EXAMPLES\ /B
copy /Y examples\sun.gif /B X:\GIFVIEW\EXAMPLES\ /B
copy /Y examples\sample.gif /B X:\GIFVIEW\EXAMPLES\ /B
rem copy /Y gifview.txt /A X:\GIFVIEW\ /A
if errorlevel 1 goto ERR
echo Unmounting image ...
osfmount.com -d -m X:
rem Delay before copy image
timeout 2 > nul
goto SUCCESS
:ERR
rem pause
echo Some Building ERRORs!!!
pause 0
rem exit
goto END
:SUCCESS
echo Copying image to ZXMAK2 Emulator
copy /Y build\gifviewer.img /B %SPRINTER_EMULATOR% /B
rem "%PROGRAMFILES%\7-Zip\7z.exe" a build\trdlist.zip trdlist.exe trdlist.txt
rem timeout 2 > nul
rem echo Starting ZXMAK2 Emulator
rem call %SPRINTER_EMULATOR%\ZXMAK2.EXE build\trdlist.img
echo Done!
:END
pause 0