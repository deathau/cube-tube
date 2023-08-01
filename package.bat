@echo off
chcp 65001 >NUL
cd /d %~dp0

set gamedir=🕹️cube-tube
for /F %%a IN ('powershell -command "$([guid]::NewGuid().ToString().toUpper())"') DO (set newProductCode=%%a)
for /F %%a IN ('powershell -command "$([guid]::NewGuid().ToString().toUpper())"') DO (set newPackageCode=%%a)

@setlocal ENABLEEXTENSIONS

@set version=0
@for /F "tokens=*" %%A in (%gamedir%/metadata/game_metadata.txt) do @call :CheckForVersion "%%A"

cd .dragonruby

robocopy ../marketing-assets/AppIcon.appiconset ./dragonruby-ios.app/Assets.xcassets/AppIcon.appiconset /e
robocopy ../marketing-assets/AppIcon.appiconset ./dragonruby-ios-simulator.app/Assets.xcassets/AppIcon.appiconset /e
robocopy ../%gamedir% ./%gameid% /e

@echo on
dragonruby-publish --only-package %gameid%
@echo off
rd /s /q %gameid%

cd builds

if exist ./%gameid%-windows-amd64.exe (
if exist ../../installer/installer.vdproj (
  echo "Building windows installer..."
  for /F "tokens=* USEBACKQ" %%t IN (`findstr /c:"%version%" ..\..\installer\installer.vdproj`) do (SET OldVersion=%%t)
  if defined OldVersion (
    echo "version already the same"
  ) else (
    echo "need to update version & product/package codes (%version%, %newProductCode%, %newPackageCode%)"
    powershell -Command "(Get-Content ../../installer/installer.vdproj) | Foreach-Object { $_ -replace '""""ProductCode"""" = """"8:\{.*\}""""$', '""""ProductCode"""" = """"8:{%newProductCode%}""""' -replace '""""PackageCode"""" = """"8:\{.*\}""""$', '""""PackageCode"""" = """"8:{%newPackageCode%}""""' -replace '""""ProductVersion"""" = """"8:.+""""$', '""""ProductVersion"""" = """"8:%version%""' } | Out-File -encoding UTF8 ../../installer/installer.vdproj"
  )
  call "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe" ..\..\installer\installer.sln /build Release
) else (
  ECHO "no installer project?"
  ECHO ../../installer/installer.vdproj
)
) else (
  ECHO "no exe?"
  ECHO ./%gameid%-windows-amd64.exe
)

if not exist ../../%gameid%.keystore (
  echo "no keystore, generating keys"
  keytool -genkey -v -keystore ../../%gameid%.keystore -alias %gameid% -keyalg RSA -keysize 2048 -validity 10000
)
if exist ./%gameid%-android.apk (
  echo "Signing apk..."
  call "C:\Program Files (x86)\Android\android-sdk\build-tools\32.0.0\apksigner.bat" sign -ks ../../%gameid%.keystore %gameid%-android.apk
  echo "Signing aab..."
  call jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 -keystore ../../%gameid%.keystore %gameid%-googleplay.aab %gameid%
) else (
  ECHO "no apk?"
  ECHO ./%gameid%-android.apk
)

ECHO "All done!"
explorer.exe %cd%
PAUSE
@exit /b 0

:CheckForVersion
@set _line=%~1
@set _linePrefeix=%_line:~0,8%
@if "%_linePrefeix%" equ "version=" (@set version="%_line:~8%")
@set _linePrefeix=%_line:~0,7%
@if "%_linePrefeix%" equ "gameid=" (@set gameid="%_line:~7%")
@exit /b 0