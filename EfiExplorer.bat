@echo off
chcp 1252 > nul
setlocal
title EFI Partition Explorer by dnchplay
goto adm_chk

:adm_chk
    net session >nul 2>&1
    if %errorLevel% == 0 (
        goto adm_O
    ) else (
	goto adm_E
    )
    pause > nul


:adm_E
	color 0C
	mode con: cols=52 lines=10

	echo    ?                                            ?
	echo    !                                            !  
	echo    !                                            !  
	echo    !                                            !  
	echo  ##################################################
	echo  #(                                              )#
	echo  #( Please, run the batch file with Admin rights )#
	echo  #(______________________________________________)#
	echo  ##################################################

	pause > nul
	exit

:adm_O
	color 0A
	mode con: cols=69 lines=16
	echo  ____  ____  ____    ____  _  _  ____  __    _____  ____  ____  ____ 
	echo ( ___)( ___)(_  _)  ( ___)( \/ )(  _ \(  )  (  _  )(  _ \( ___)(  _ \
	echo  )__)  )__)  _)(_    )__)  )  (  )___/ )(__  )(_)(  )   / )__)  )   /
	echo (____)(__)  (____)  (____)(_/\_)(__)  (____)(_____)(_)\_)(____)(_)\_)
	echo Welcome to EFI Partition Explorer by dnchplay!
	echo. 
	echo If you already mounted your EFI drive with this script:
	echo. 
	echo - If you want to get rid of the mounted drive, restart yout PC
	echo - If EFI drive is already mounted,
	echo   you need to use the same letter you used previous time
	echo ____________________________________________________________
	echo [ Please, select a drive letter to mount the EFI partition ]
	echo ------------------------------------------------------------
	echo. 
	set /p drvlet=Drive letter(use UPPERCASE): 
	

mountvol %drvlet%: /S

set ps_fn=ofd.ps1
echo [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") ^| out-null > %ps_fn%
echo $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog >> %ps_fn%
echo $OpenFileDialog.initialDirectory = "%drvlet%:" >> %ps_fn%
echo $OpenFileDialog.filter = "" >> %ps_fn%
echo $result = $OpenFileDialog.ShowDialog() >> %ps_fn%
echo if ($result -eq [System.Windows.Forms.DialogResult]::OK) { >> %ps_fn%
echo     $filename = $OpenFileDialog.filename >> %ps_fn%
echo     Start-Process $filename >> %ps_fn%
echo } >> %ps_fn%
 
color 07
cls

mode con: cols=34 lines=2
echo The file window will be opened now

for /F "tokens=* usebackq" %%a in (`powershell -executionpolicy bypass -file %ps_fn%`) do (
    if not "%%a" == "Cancel" if not "%%a" == "OK" set filename=%%a
)

del %ps_fn%
if not "%filename%"=="" start %filename%

exit


 
endlocal