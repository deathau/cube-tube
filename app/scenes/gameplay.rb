# frozen_string_literal: true

# This is a base class for the main gameplay, handling things like pausing
class GameplayScene < SceneInstance
  def initialize(_args, opts = {})
    super
  end

  # called every tick of the game loop
  def tick(args) 
    super

    # focus tracking
    if !args.state.has_focus && args.inputs.keyboard.has_focus
      args.state.has_focus = true
    elsif args.state.has_focus && !args.inputs.keyboard.has_focus
      args.state.has_focus = false
    end

    # auto-pause & input-based pause
    return pause(args) if !args.state.has_focus || Input.pressed?(args, :pause)

    tick_pause_button(args) if mobile?

    draw_bg(args, BLACK)
  end

  def pause(args)
    Sound.play(args, :select)
    Scene.push(args, :paused, reset: true)
  end

  def tick_pause_button(args)
    pause_button = {
      x:    72.from_right,
      y:    72.from_top,
      w:    52,
      h:    52,
      path: Sprite.for(:pause)
    }
    pause_rect = pause_button.dup
    pause_padding = 12
    pause_rect.x -= pause_padding
    pause_rect.y -= pause_padding
    pause_rect.w += pause_padding * 2
    pause_rect.h += pause_padding * 2
    return pause(args) if args.inputs.mouse.down && args.inputs.mouse.inside_rect?(pause_rect)

    args.outputs.sprites << pause_button
  end
end
