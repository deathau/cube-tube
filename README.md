dragonruby binaries, etc are in the `.dragonruby` folder

To update dragonruby, use the following:
```
git subtree add --prefix .dragonruby <path/to/dragonruby/repo> <version-tag> --squash
```
(or just dump the files in the .dragonruby folder)

Also, make sure to dump icons in `.dragonruby/dragonruby-ios-simulator.app/Assets.xcassets/AppIcon.appiconset/` and `.dragonruby/dragonruby-ios.app/Assets.xcassets/AppIcon.appiconset` (see the `.gitkeep` files in those folders for more info)