module Sprite
  # annoying to track but useful for reloading with +i+ in debug mode; would be
  # nice to define a different way
  SPRITES = {
    train: 'sprites/train-1.png',
    train_fore: 'sprites/train-2.png',
    screen: 'sprites/screen.png',
    screen_s1: 'sprites/screen-s1.png',
    screen_s2: 'sprites/screen-s2.png',
    screen_s3: 'sprites/screen-s3.png',
    screen_s4: 'sprites/screen-s4.png',
    tunnel: 'sprites/tunnel.png',
    pause: 'sprites/pause.png',
    gray: 'sprites/box/gray.png',
    black: 'sprites/box/black.png',
    white: 'sprites/box/white.png',
    red: 'sprites/box/red.png',
    green: 'sprites/box/green.png',
    blue: 'sprites/box/blue.png',
    yellow: 'sprites/box/yellow.png',
    indigo: 'sprites/box/indigo.png',
    violet: 'sprites/box/violet.png',
    orange: 'sprites/box/orange.png'
  }

  class << self
    def reset_all(args)
      SPRITES.each { |_, v| args.gtk.reset_sprite(v) }
    end

    def for(key)
      SPRITES.fetch(key)
    end
  end
end

