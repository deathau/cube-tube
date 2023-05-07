# frozen_string_literal: true

# Code that only gets run once on game start
def init(args)
  Input.reset_swipe(args)
  GameSetting.load_settings(args)
end

# Code that runs every game tick (mainly just calling other ticks)
def tick(args)
  init(args) if args.state.tick_count.zero?

  Music.tick(args)
  
  # this looks good on non 16:9 resolutions; game background is different
  args.outputs.background_color = TRUE_BLACK.values

  args.state.has_focus ||= true
  args.state.scene_stack ||= []
  Scene.push(args, Scene.default(args), reset: true) if args.state.scene_stack.empty?

  Input.track_swipe(args) if mobile?

  args.state.scene_stack.each do |scene|
    scene.tick(args) if scene.tick_in_background || scene == args.state.scene_stack.last
  end

  debug_tick(args)
rescue FinishTick
end

# raise this as an easy way to end the current tick early
class FinishTick < StandardError; end

# code that only runs while developing
# put shortcuts and helpful info here
def debug_tick(args)
  return unless debug?

  debug_label(
    args, 24.from_right, 24.from_top,
    "v#{version} | DR v#{$gtk.version} (#{$gtk.platform}) | Ticks: #{args.state.tick_count} | FPS: #{args.gtk.current_framerate.round}",
    ALIGN_RIGHT)


  if args.inputs.keyboard.key_down.zero
    Sound.play(args, :select)
    args.state.render_debug_details = !args.state.render_debug_details
  end

  if args.inputs.keyboard.key_down.i
    Sound.play(args, :select)
    Sprite.reset_all(args)
    args.gtk.notify!('Sprites reloaded')
  end

  if args.inputs.keyboard.key_down.r
    Sound.play(args, :select)
    $gtk.reset
  end

  if args.inputs.keyboard.key_down.m
    Sound.play(args, :select)
    args.state.simulate_mobile = !args.state.simulate_mobile
    msg = if args.state.simulate_mobile
            'Mobile simulation on'
          else
            'Mobile simulation off'
          end
    args.gtk.notify!(msg)
  end
end

# render a label that is only shown when in debug mode and the debug details
# are shown; toggle with +0+ key
def debug_label(args, x, y, text, align=ALIGN_LEFT)
  return unless debug?
  return unless args.state.render_debug_details

  args.outputs.debug << { x: x, y: y, text: text, alignment_enum: align }.merge(WHITE).label!
end

# different than background_color... use this to change the bg color for the
# visible portion of the game
def draw_bg(args, color)
  args.outputs.solids << { x: args.grid.left, y: args.grid.bottom, w: args.grid.w, h: args.grid.h }.merge(color)
end
