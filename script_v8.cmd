@Echo off
@title WinTask

REM ==============================================================
REM Impostare la data e creare la cartella ed il file per l'audit
REM ==============================================================

Set mydate_0=%Date%
Set mydate_1=%mydate_0:/=-%
Set mydate=%mydate_1: =_%
if not exist "C:\Audit\" mkdir C:\Audit
echo --AZIONE ESEGUITA--                   ------DATA------     -UTENTE- >> C:\Audit\Audit_%mydate%.txt

:startup
title LOADING...
echo [101mLOADING LOGIN SYSTEM [0m
echo [101m PLEASE WAIT... [0m
timeout /t 2
cd %userprofile%/documents
if exist "Login system" goto skip
md "Login System"
set chkpw = 0

:skip
attrib -h -s "%userprofile%/documents/Login system"
cd "Login System"
ping localhost -n 1 >nul

REM ==============================================================
REM Fare un check dei nomi e delle password, ricorda che puoi
REM aggiungere utenti andando ad inserire alcune righe:
REM if %user%== UTENTE goto PW5/6/7 
REM if NOT %user%==UTENTE
REM :PW5/6/7 
REM echo Inserisci la Password:
REM set/p "pass=>"
REM if %pass%== PASSWORD goto VALID
REM if NOT %pass%== PASSWORD goto NVAL2
REM ESCAPE CHAR ALT+027
REM https://stackoverflow.com/questions/2048509/how-to-echo-with-different-colors-in-the-windows-command-line
REM ==============================================================
:home
color 7
title HOME
cls
echo 	[92m				"  _    _                         ";	[0m
echo 	[92m 				" | |  | |                        "; 	[0m
echo 	[92m				" | |__| |  ___   _ __ ___    ___ ";	[0m
echo 	[92m				" |  __  | / _ \ | '_ \` _ \ / _ \";	[0m
echo 	[92m				" | |  | || (_) || | | | | ||  __/";	[0m
echo 	[92m				" |_|  |_| \___/ |_| |_| |_| \___|";	[0m
echo.
echo [44m ------------------------------------[0m
echo " __ _                         ";
echo "/ _(_) __ _ _ __  _   _ _ __  ";
echo "\ \| |/ _\` | '_ \| | | | '_\ ";
echo "_\ | | (_| | | | | |_| | |_) |";
echo "\__|_|\__, |_| |_|\__,_| .__/ ";
echo "      |___/            |_|    ";
echo [44m ------------------------------------[0m
echo "   __             _       ";
echo "  / /  ___   __ _(_)_ __  ";
echo " / /  / _ \ / _\`| | '_ \ ";
echo "/ /__| (_) | (_| | | | | |";
echo "\____/\___/ \__, |_|_| |_|";
echo "            |___/         ";
echo [44m ------------------------------------[0m
echo "           _ _   ";
echo "  _____  _(_| |_ ";
echo " / _ \ \/ | | __|";
echo "|  __/>  <| | |_ ";
echo " \___/_/\_|_|\__|";
echo "                 "
echo [44m ------------------------------------[0m
echo.
set /p "a=Choice: "

if ["%a%"] == ["1"] goto signup
if ["%a%"] == ["2"] goto login
if ["%a%"] == ["3"] goto exit
if ["%a%"] == [""] goto home

:delaccount
color 7
title DELETE ACCOUNT
cls
set /p "duser=Username: "
if ["%duser%"] == [""] goto pwchk
if exist "%duser%.bat" goto contin
goto usernotexistdel

:contin
call %duser%.bat
set /p "dpass=Password: "
if ["%dpass%"] == ["%apass%"] goto contin2
goto passerror

:contin2
cls
echo Sei sicuro di volere cancellare il tuo account?
set /p "delacc=y/n: "
if ["%delacc%"] == ["n"] goto home
echo [101mEliminazione account... [0
del "%duser%.bat"
ping localhost -n 2 >nul
cls
color a
goto CANCELLATO



:signup
color 7
title SIGNUP
attrib -h -s "%userprofile%/documents/Login system"
cls
set /p "nuser=New Username: "
if ["%nuser%"] == [""] goto signuperror
if EXIST "%nuser%.bat" goto usertaken
goto npass

:usertaken
cls
color c
echo [103mUSERNAME già in uso, inserirne un altro. [0
pause >nul
goto signup

:npass
set /p "npass=New Password: "
if ["%npass%"] == [""] goto signuperror
set /p "npassr=Repeat Password: "
if ["%npassr%"] == ["%npass%"] goto signupc
goto signuperror

:signupc
echo set "auser=%nuser%"> %nuser%.bat
echo set "apass=%npass%">> %nuser%.bat
cls
color a
echo Creazione utente completata!
echo Clicca qualsiasi bottone per proseguire
attrib +h +s "%userprofile%/documents/Login system"
pause >nul
goto home

:login
attrib -h -s "%userprofile%/documents/Login system"
color 7
title LOGIN
cls
set /p "user=Username: "
if ["%user%"] == [""] goto NVAL
if EXIST "%user%.bat" goto pass
goto usernotexist

:usernotexist
color c
cls
echo USERNAME non esistente.
attrib +h +s "%userprofile%/documents/Login system"
pause >nul
goto skip

:pass
attrib -h -s "%userprofile%/documents/Login system"
call %user%.bat
set /p "pass=Password: "
if ["%pass%"] == ["%apass%"] goto pwchk
goto passinvalid

:passinvalid
color c
cls
echo La PASSWORD che hai inserito è INVALIDA
attrib +h +s "%userprofile%/documents/Login system"
pause >nul
goto skip

:signuperror
color c
cls
echo [101m ERRORE [0m 
echo Ritorno alla schermata di signup...
ping localhost -n 2 >nul
goto signup

:passerror
color c
cls
echo PASSWORD INVALIDA
goto NVAL2

:usernotexistdel
color c
cls
echo USERNAME inesistente
pause >nul
goto delaccount

:pwchk
if %user% == Void goto VALID3 && attrib +h +s "%userprofile%/documents/Login system"
if %user% == Admin goto VALID2 && attrib +h +s "%userprofile%/documents/Login system"
goto VALID

REM ==============================================================
REM Scelte diversificate per gli utenti e per gli Admin
REM infatti l'admin è l'unico che può chiudere il programma e
REM visionare l'audit
REM ==============================================================

:LOOP
attrib +h +s "%userprofile%/documents/Login system"
color 0f
CHOICE /N /C:123 /M "Rendere visibile [1], invisibile [2] o LOGOUT [3]?"
IF ERRORLEVEL 3 goto USC
IF ERRORLEVEL 2 goto INV
IF ERRORLEVEL 1 goto VIS 

:LOOP2
attrib +h +s "%userprofile%/documents/Login system"
color 0f
CHOICE /N /C:123456 /M "Rendere visibile [1], invisibile [2], LOGOUT [3], USCIRE [4], AUDIT [5], CANCELLA ACCOUNT [6]?"
IF ERRORLEVEL 6 goto delaccount
IF errorlevel 5 goto ADT
IF ERRORLEVEL 4 goto EXT
IF ERRORLEVEL 3 goto USC
IF ERRORLEVEL 2 goto INV2
IF ERRORLEVEL 1 goto VIS2


:LOOP3
color 0f
attrib +h +s "%userprofile%/documents/Login system"
CHOICE /N /C:12345678 /M "Rendere visibile [1], invisibile [2], LOGOUT [3], USCIRE [4], AUDIT [5], KILLEXP [6], EXP [7], CANCELLA ACCOUNT [8]?"
IF ERRORLEVEL 8 goto delaccount
IF ERRORLEVEL 7 goto EXP
IF ERRORLEVEL 6 goto KEXP
IF errorlevel 5 goto ADT
IF ERRORLEVEL 4 goto EXT
IF ERRORLEVEL 3 goto USC
IF ERRORLEVEL 2 goto INV3
IF ERRORLEVEL 1 goto VIS3
	
REM ==============================================================
REM Casistiche che avvengono in base alle scelte prese sopra
REM ogni scelta viene tracciata nell'audit
REM ==============================================================

:EXP
color 0a
start explorer.exe
echo Aperto explorer nel:                   "%mydate%" da "%user%" >> C:\Audit\Audit_%mydate%.txt
attrib +h +s C:\Audit\Audit_%mydate%.txt
cls
goto LOOP3

:KEXP
color 0a
taskkill /F /IM explorer.exe
echo Chiuso explorer nel:                   "%mydate%" da "%user%" >> C:\Audit\Audit_%mydate%.txt
attrib +h +s C:\Audit\Audit_%mydate%.txt
cls
goto LOOP3

:INV
color 0b
nircmd.exe win trans class Shell_TrayWnd 0
nircmd.exe win hide class progman
echo Impostata traspatenza nel:             "%mydate%" da "%user%" >> C:\Audit\Audit_%mydate%.txt
attrib +h +s C:\Audit\Audit_%mydate%.txt
cls
goto LOOP

:VIS
color 0a
nircmd.exe win trans class Shell_TrayWnd 255
nircmd.exe win show class progman
echo Tolta trasparenza nel:                 "%mydate%" da "%user%" >> C:\Audit\Audit_%mydate%.txt
attrib +h +s C:\Audit\Audit_%mydate%.txt
cls
goto LOOP

:INV3
color 0b
nircmd.exe win trans class Shell_TrayWnd 0
nircmd.exe win hide class progman
echo Impostata traspatenza nel:             "%mydate%" da "%user%" >> C:\Audit\Audit_%mydate%.txt
attrib +h +s C:\Audit\Audit_%mydate%.txt
cls
goto LOOP3

:VIS3
color 0a
nircmd.exe win trans class Shell_TrayWnd 255
nircmd.exe win show class progman
echo Tolta trasparenza nel:                 "%mydate%" da "%user%" >> C:\Audit\Audit_%mydate%.txt
attrib +h +s C:\Audit\Audit_%mydate%.txt
cls
goto LOOP3

:INV2
color 0b
nircmd.exe win trans class Shell_TrayWnd 0
nircmd.exe win hide class progman
echo Impostata traspatenza nel:             "%mydate%" da "%user%" >> C:\Audit\Audit_%mydate%.txt
attrib +h +s C:\Audit\Audit_%mydate%.txt
cls
goto LOOP2

:VIS2
color 0a
nircmd.exe win trans class Shell_TrayWnd 255
nircmd.exe win show class progman
echo Tolta trasparenza nel:                 "%mydate%" da "%user%" >> C:\Audit\Audit_%mydate%.txt
attrib +h +s C:\Audit\Audit_%mydate%.txt
cls
goto LOOP2

:NVAL
echo Utente errato nel:                     "%mydate%" di "%user%" >> C:\Audit\Audit_%mydate%.txt
color 0c
echo Nome utente errato o inesistente!
attrib +h +s C:\Audit\Audit_%mydate%.txt
TIMEOUT /t 1
goto skip

:NVAL2
echo Password errata nel:                   "%mydate%" di "%user%" >> C:\Audit\Audit_%mydate%.txt
color 0c
echo Password errata!
attrib +h +s C:\Audit\Audit_%mydate%.txt
goto skip

:VALID
echo Login eseguito correttamente nel:      "%mydate%" di "%user%" >> C:\Audit\Audit_%mydate%.txt
color 02
echo Login eseguito correttamente!
attrib +h +s C:\Audit\Audit_%mydate%.txt
goto LOOP

:VALID2
echo Login eseguito correttamente nel:      "%mydate%" di "%user%" >> C:\Audit\Audit_%mydate%.txt
color 02
echo Login eseguito correttamente!
attrib +h +s C:\Audit\Audit_%mydate%.txt
goto LOOP2

:VALID3
echo Login eseguito correttamente nel:      "%mydate%" di "%user%" >> C:\Audit\Audit_%mydate%.txt
color 02
echo Login eseguito correttamente!
attrib +h +s C:\Audit\Audit_%mydate%.txt
goto LOOP3

:ADT
echo Audit visualizzato correttamente:      "%mydate%" da "%user%" >> C:\Audit\Audit_%mydate%.txt
start C:\Audit\Audit_%mydate%.txt
attrib +h +s C:\Audit\Audit_%mydate%.txt
cls
goto LOOP2

:CANCELLATO
echo Utente rimosso in data:                "%mydate%" da "%user%" >> C:\Audit\Audit_%mydate%.txt
attrib +h +s C:\Audit\Audit_%mydate%.txt
echo Account Cancellato.
echo Ritorno alla schermata principale
ping localhost -n 3 >nul
cls
goto pwchk

:USC
echo Logout eseguito correttamente nel:     "%mydate%" di "%user%" >> C:\Audit\Audit_%mydate%.txt
goto skip

:EXT
echo Programma chiuso nel:                  "%mydate%" da "%user%" >> C:\Audit\Audit_%mydate%.txt
exit