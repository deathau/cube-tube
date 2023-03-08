module Sprite
  # annoying to track but useful for reloading with +i+ in debug mode; would be
  # nice to define a different way
  SPRITES = {
    bullet: 'sprites/bullet.png',
    enemy: 'sprites/enemy.png',
    enemy_king: 'sprites/enemy_king.png',
    enemy_super: 'sprites/enemy_super.png',
    exp_chip: 'sprites/exp_chip.png',
    familiar: 'sprites/familiar.png',
    player: 'sprites/player.png',
    pause: 'sprites/pause.png',
    gray: 'sprites/square/gray.png',
    black: 'sprites/square/black.png',
    white: 'sprites/square/white.png',
    red: 'sprites/square/red.png',
    green: 'sprites/square/green.png',
    blue: 'sprites/square/blue.png',
    yellow: 'sprites/square/yellow.png',
    indigo: 'sprites/square/indigo.png',
    violet: 'sprites/square/violet.png',
    orange: 'sprites/square/orange.png'
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

