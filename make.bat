@echo off

if EXIST gifview.exe (
	del gifview.exe
)
tools\sjasmplus\sjasmplus.exe gifview.asm --lst=gifview.lst
if errorlevel 1 goto ERR
echo Ok!
goto END

:ERR
del gifview.exe
pause
echo �訡�� �������樨...
pause
goto END

:END
