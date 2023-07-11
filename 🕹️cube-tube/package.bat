@echo off
cd /d %~dp0

for %%I in (.) do set CurrDirName=%%~nxI
for /F %%a IN ('powershell -command "$([guid]::NewGuid().ToString().toUpper())"') DO (set newProductCode=%%a)
for /F %%a IN ('powershell -command "$([guid]::NewGuid().ToString().toUpper())"') DO (set newPackageCode=%%a)

@setlocal ENABLEEXTENSIONS

@set version=0
@for /F "tokens=*" %%A in (./metadata/game_metadata.txt) do @call :CheckForVersion "%%A"

cd ..
@echo on
dragonruby-publish --only-package %CurrDirName%
@echo off
cd builds

if exist ./%CurrDirName%-windows-amd64.exe (
if exist ../%CurrDirName%/installer/installer.vdproj (
  echo "Building windows installer..."
  for /F "tokens=* USEBACKQ" %%t IN (`findstr /c:"%version%" ..\%CurrDirName%\installer\installer.vdproj`) do (SET OldVersion=%%t)
  if defined OldVersion (
    echo "version already the same"
  ) else (
    echo "need to update version & product/package codes (%version%, %newProductCode%, %newPackageCode%)"
    powershell -Command "(Get-Content ../%CurrDirName%/installer/installer.vdproj) | Foreach-Object { $_ -replace '""""ProductCode"""" = """"8:\{.*\}""""$', '""""ProductCode"""" = """"8:{%newProductCode%}""""' -replace '""""PackageCode"""" = """"8:\{.*\}""""$', '""""PackageCode"""" = """"8:{%newPackageCode%}""""' -replace '""""ProductVersion"""" = """"8:.+""""$', '""""ProductVersion"""" = """"8:%version%""' } | Out-File -encoding UTF8 ../%CurrDirName%/installer/installer.vdproj"
  )
  call "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe" ..\%CurrDirName%\installer\installer.sln /build Release
) else (
  ECHO "no installer project?"
  ECHO ../%CurrDirName%/installer/installer.vdproj
)
) else (
  ECHO "no exe?"
  ECHO ./%CurrDirName%-windows-amd64.exe
)

if not exist ./%CurrDirName%.keystore (
  echo "no keystore, generating keys"
  keytool -genkey -v -keystore %CurrDirName%.keystore -alias %CurrDirName% -keyalg RSA -keysize 2048 -validity 10000
)
if exist ./%CurrDirName%-android.apk (
  echo "Signing apk..."
  call "C:\Program Files (x86)\Android\android-sdk\build-tools\32.0.0\apksigner.bat" sign -ks %CurrDirName%.keystore %CurrDirName%-android.apk
  echo "Signing aab..."
  call jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 -keystore %CurrDirName%.keystore %CurrDirName%-googleplay.aab %CurrDirName%
) else (
  ECHO "no apk?"
  ECHO ./%CurrDirName%-android.apk
)

ECHO "All done!"
explorer.exe %cd%
PAUSE
@exit /b 0

:CheckForVersion
@set _line=%~1
@set _linePrefeix=%_line:~0,8%
@if "%_linePrefeix%" equ "version=" (@set version="%_line:~8%")
@exit /b 0