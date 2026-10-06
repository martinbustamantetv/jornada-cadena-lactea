@echo off
rem ============================================================
rem  renombrar.bat - prepara un dia de la galeria.
rem
rem  Copialo adentro de la carpeta del dia (la que tiene g y m)
rem  y hacele doble clic. Renombra las dos carpetas de una:
rem
rem      g\JORNADA CADENA LACTEA-001.jpg ...   las fotos grandes
rem      m\JORNADA CADENA LACTEA-001.jpg ...   las miniaturas
rem      fotos.js                              la lista que lee la web
rem
rem  Si queres otro nombre, cambia la linea PREFIJO de aca abajo.
rem
rem  Ordena como el explorador de Windows (alfabetico). Si tus
rem  fotos tienen numeros SIN ceros adelante (IMG_2, IMG_10),
rem  IMG_10 va a quedar antes que IMG_2: avisame y te lo cambio.
rem ============================================================
setlocal enabledelayedexpansion
pushd "%~dp0"

set "PREFIJO=JORNADA CADENA LACTEA"

echo.
echo  %CD%
echo.

if not exist "g\" (
  echo  No encuentro la carpeta g. Este archivo va en la carpeta del dia,
  echo  la que tiene g y m adentro.
  echo.
  pause
  popd
  exit /b
)

rem --- juntar las fotos grandes ---
set ng=0
for /f "delims=" %%f in ('dir /b /a-d /on "g" 2^>nul') do (
  set "e="
  if /i "%%~xf"==".jpg"  set "e=.jpg"
  if /i "%%~xf"==".jpeg" set "e=.jpeg"
  if /i "%%~xf"==".png"  set "e=.png"
  if /i "%%~xf"==".webp" set "e=.webp"
  if defined e (
    set /a ng+=1
    set "g[!ng!]=%%f"
    set "gx[!ng!]=!e!"
  )
)

rem --- juntar las miniaturas ---
set nm=0
if exist "m\" (
  for /f "delims=" %%f in ('dir /b /a-d /on "m" 2^>nul') do (
    set "e="
    if /i "%%~xf"==".jpg"  set "e=.jpg"
    if /i "%%~xf"==".jpeg" set "e=.jpeg"
    if /i "%%~xf"==".png"  set "e=.png"
    if /i "%%~xf"==".webp" set "e=.webp"
    if defined e (
      set /a nm+=1
      set "m[!nm!]=%%f"
    )
  )
)

echo  g: %ng% fotos
echo  m: %nm% miniaturas
echo.

if %ng%==0 (
  echo  No hay fotos en g.
  echo.
  pause
  popd
  exit /b
)

set "HACERM="
if %nm%==%ng% set "HACERM=1"
if not defined HACERM (
  if %nm%==0 (
    echo  No hay miniaturas: la web va a usar las fotos grandes en la grilla.
  ) else (
    echo  OJO: g y m tienen distinta cantidad. Voy a renombrar solo g y dejar
    echo  m como esta, para no aparear mal las fotos. Revisa m y volve a correrlo.
  )
  echo.
)

set "DIG=3"
if %ng% GTR 999 set "DIG=4"

echo  Van a quedar:  %PREFIJO%-001!gx[1]!
echo.
echo  Enter para renombrar, o cerra esta ventana para cancelar.
pause >nul

rem --- primera pasada: nombres temporales, para que no choquen ---
for /l %%i in (1,1,%ng%) do ren "g\!g[%%i]!" "__t%%i.tmp"
if defined HACERM for /l %%i in (1,1,%nm%) do ren "m\!m[%%i]!" "__t%%i.tmp"

rem --- segunda pasada: nombre definitivo, y la lista para la web ---
break > fotos.js
break > nombres-originales.txt
>> fotos.js echo window.__FOTOS__=[
for /l %%i in (1,1,%ng%) do (
  set "p=0000%%i"
  if "%DIG%"=="3" (set "p=!p:~-3!") else (set "p=!p:~-4!")
  set "nv=%PREFIJO%-!p!!gx[%%i]!"
  ren "g\__t%%i.tmp" "!nv!"
  if defined HACERM ren "m\__t%%i.tmp" "!nv!"
  >> fotos.js echo "!nv!",
  >> nombres-originales.txt echo !nv! = !g[%%i]!
)
>> fotos.js echo ];

echo.
echo  Listo: %ng% fotos, de 001 a !p!
if defined HACERM echo  Las miniaturas quedaron con los mismos nombres.
echo  Subi la carpeta del dia entera: g, m y fotos.js
echo.
pause
popd
