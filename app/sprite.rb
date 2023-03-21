module Sprite
  # Create type with ALL sprite properties AND primitive_marker
  class SpriteInstance
    attr_accessor :x, :y, :w, :h, :path, :angle, :a, :r, :g, :b,
                  :source_x, :source_y, :source_w, :source_h,
                  :tile_x, :tile_y, :tile_w, :tile_h,
                  :flip_horizontally, :flip_vertically,
                  :angle_anchor_x, :angle_anchor_y, :blendmode_enum

    def primitive_marker
      :sprite
    end

    def initialize opts
      @x = opts[:x]
      @y = opts[:y]
      @w = opts[:w]
      @h = opts[:h]
      @path = opts[:path]
      @angle = opts[:angle]
      @a = opts[:a]
      @r = opts[:r]
      @g = opts[:g]
      @b = opts[:b]
      @source_x = opts[:source_x]
      @source_y = opts[:source_y]
      @source_w = opts[:source_w]
      @source_h = opts[:source_h]
      @tile_x = opts[:tile_x]
      @tile_y = opts[:tile_y]
      @tile_w = opts[:tile_w]
      @tile_h = opts[:tile_h]
      @flip_horizontally = opts[:flip_horizontally]
      @flip_vertically = opts[:flip_vertically]
      @angle_anchor_x = opts[:angle_anchor_x]
      @angle_anchor_y = opts[:angle_anchor_y]
      @blendmode_enum = opts[:blendmode_enum]
    end

    def render(args, opts = {})
      args.outputs.sprites << [
        opts[:x]._?(@x),
        opts[:y]._?(@y),
        opts[:w]._?(@w),
        opts[:h]._?(@h),
        opts[:path]._?(@path),
        opts[:angle]._?(@angle),
        opts[:a]._?(@a),
        opts[:r]._?(@r),
        opts[:g]._?(@g),
        opts[:b]._?(@b),
        opts[:source_x]._?(@source_x),
        opts[:source_y]._?(@source_y),
        opts[:source_w]._?(@source_w),
        opts[:source_h]._?(@source_h),
        opts[:tile_x]._?(@tile_x),
        opts[:tile_y]._?(@tile_y),
        opts[:tile_w]._?(@tile_w),
        opts[:tile_h]._?(@tile_h),
        opts[:flip_horizontally]._?(@flip_horizontally),
        opts[:flip_vertically]._?(@flip_vertically),
        opts[:angle_anchor_x]._?(@angle_anchor_x),
        opts[:angle_anchor_y]._?(@angle_anchor_y),
        opts[:blendmode_enum]._?(@blendmode_enum)
      ]
    end
  end

  # annoying to track but useful for reloading with +i+ in debug mode; would be
  # nice to define a different way
  SPRITES = {
    train: SpriteInstance.new({ w: 1597, h: 540, path: 'sprites/train-1.png' }),
    train_fore: SpriteInstance.new({ w: 1597, h: 540, path: 'sprites/train-2.png' }),
    screen: SpriteInstance.new({ w: 250, h: 210, path: 'sprites/screen.png' }),
    tunnel: SpriteInstance.new({ w: 267, h: 144, path: 'sprites/tunnel.png' }),
    pause: SpriteInstance.new({ w: 16, h: 16, path: 'sprites/pause.png' }),
    gray: SpriteInstance.new({ w: 176, h: 148, path: 'sprites/box/gray.png' }),
    black: SpriteInstance.new({ w: 176, h: 148, path: 'sprites/box/black.png' }),
    white: SpriteInstance.new({ w: 176, h: 148, path: 'sprites/box/white.png' }),
    red: SpriteInstance.new({ w: 176, h: 148, path: 'sprites/box/red.png' }),
    green: SpriteInstance.new({ w: 176, h: 148, path: 'sprites/box/green.png' }),
    blue: SpriteInstance.new({ w: 176, h: 148, path: 'sprites/box/blue.png' }),
    yellow: SpriteInstance.new({ w: 176, h: 148, path: 'sprites/box/yellow.png' }),
    indigo: SpriteInstance.new({ w: 176, h: 148, path: 'sprites/box/indigo.png' }),
    violet: SpriteInstance.new({ w: 176, h: 148, path: 'sprites/box/violet.png' }),
    orange: SpriteInstance.new({ w: 176, h: 148, path: 'sprites/box/orange.png' }),
    screen_s1: SpriteInstance.new({ w: 250, h: 210, path: 'sprites/screen-s1.png' }),
    screen_s2: SpriteInstance.new({ w: 250, h: 210, path: 'sprites/screen-s2.png' }),
    screen_s3: SpriteInstance.new({ w: 250, h: 210, path: 'sprites/screen-s3.png' }),
    screen_s4: SpriteInstance.new({ w: 250, h: 210, path: 'sprites/screen-s4.png' }),
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