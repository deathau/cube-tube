# Cube Tube
_Tetrominoes on a Train!_

This is my first DragonRuby game project. It's basically a Tetris clone, after following these tutorials:
1. Building Tetris - Part 1: https://youtu.be/xZMwRSbC4rY
2. Building Tetris - Part 2: https://youtu.be/C3LLzDUDgz4

Then making a whole bunch of modifications, including graphics, sounds, music, rotating the whole thing on its side and more.

It also made use of the [Scale Framework](https://github.com/DragonRidersUnite/scale), which itself got heavily modified and is mostly unrecognisable now.

## DragonRuby
DragonRuby binaries, etc are in a git submodule under the `.dragonruby` folder

To update DragonRuby, update the `tag` value in `.gitmodules` then run the following git commands:
```
git submodule sync
git submodule foreach --recursive 'git fetch --tags'
git submodule update --init --recursive --remote
```
(or just dump the files in the .dragonruby folder)

Also, for iOS, make sure to create icons in `marketing-assets/AppIcon.appiconset/` (see the `.gitkeep` file in that folder for more info). The `run` and `package` scripts should copy these to the correct locations in `.dragonruby/dragonruby-ios-simulator.app/Assets.xcassets/AppIcon.appiconset/` and `.dragonruby/dragonruby-ios.app/Assets.xcassets/AppIcon.appiconset` respectively.