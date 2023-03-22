# frozen_string_literal: true

module Sprite
  # annoying to track but useful for reloading with +i+ in debug mode; would be
  # nice to define a different way
  SPRITES = {
    train:      SpriteInstance.new({ w: 1597, h: 540, path: 'sprites/train-1.png' }),
    train_fore: SpriteInstance.new({ w: 1597, h: 540, path: 'sprites/train-2.png' }),
    screen:     SpriteInstance.new({ w: 250,  h: 210, path: 'sprites/screen.png' }),
    tunnel:     SpriteInstance.new({ w: 267,  h: 144, path: 'sprites/tunnel.png' }),
    pause:      SpriteInstance.new({ w: 16,   h: 16,  path: 'sprites/pause.png' }),
    gray:       SpriteInstance.new({ w: 176,  h: 148, path: 'sprites/box/gray.png' }),
    black:      SpriteInstance.new({ w: 176,  h: 148, path: 'sprites/box/black.png' }),
    white:      SpriteInstance.new({ w: 176,  h: 148, path: 'sprites/box/white.png' }),
    red:        SpriteInstance.new({ w: 176,  h: 148, path: 'sprites/box/red.png' }),
    green:      SpriteInstance.new({ w: 176,  h: 148, path: 'sprites/box/green.png' }),
    blue:       SpriteInstance.new({ w: 176,  h: 148, path: 'sprites/box/blue.png' }),
    yellow:     SpriteInstance.new({ w: 176,  h: 148, path: 'sprites/box/yellow.png' }),
    indigo:     SpriteInstance.new({ w: 176,  h: 148, path: 'sprites/box/indigo.png' }),
    violet:     SpriteInstance.new({ w: 176,  h: 148, path: 'sprites/box/violet.png' }),
    orange:     SpriteInstance.new({ w: 176,  h: 148, path: 'sprites/box/orange.png' }),
    screen_s1:  SpriteInstance.new({ w: 250,  h: 210, path: 'sprites/screen-s1.png' }),
    screen_s2:  SpriteInstance.new({ w: 250,  h: 210, path: 'sprites/screen-s2.png' }),
    screen_s3:  SpriteInstance.new({ w: 250,  h: 210, path: 'sprites/screen-s3.png' }),
    screen_s4:  SpriteInstance.new({ w: 250,  h: 210, path: 'sprites/screen-s4.png' }),
  }
end
