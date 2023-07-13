@echo off

cd .dragonruby
robocopy ../marketing-assets/AppIcon.appiconset ./dragonruby-ios.app/Assets.xcassets/AppIcon.appiconset /e
robocopy ../marketing-assets/AppIcon.appiconset ./dragonruby-ios-simulator.app/Assets.xcassets/AppIcon.appiconset /e
@echo on
dragonruby ../🕹️cube-tube
EXIT /B