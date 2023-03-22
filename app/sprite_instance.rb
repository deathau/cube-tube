# frozen_string_literal: true

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

  def initialize(opts)
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
