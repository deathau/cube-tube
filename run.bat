@echo off
cd /d %~dp0

for %%I in (.) do set CurrDirName=%%~nxI

cd ..
@echo on
dragonruby %CurrDirName%