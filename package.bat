@echo off
cd /d %~dp0

for %%I in (.) do set CurrDirName=%%~nxI

cd ..
@echo on
dragonruby-publish --only-package %CurrDirName%
@echo off
cd builds
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