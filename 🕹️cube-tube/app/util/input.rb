# frozen_string_literal: true

# Module for managing inputs.
module Input
  class << self

    def input_interaction?(args, input, interaction)
      BINDINGS[input].any? do |source, bindings|
        bindings.any? do |k|
          args.inputs.send(source).send(interaction).send(k)
        end
      end
    end

    def pressed?(args, input)
      input_interaction?(args, input, :key_down)
    end

    def held?(args, input)
      input_interaction?(args, input, :key_held)
    end

    def released?(args, input)
      input_interaction?(args, input, :key_up)
    end

    def pressed_or_held?(args, input)
      pressed?(args, input) || held?(args, input)
    end

    # check for arrow keys, WASD, gamepad, and swipe up
    def up?(args)
      args.inputs.up || args.state.swipe.up
    end

    # check for arrow keys, WASD, gamepad, and swipe down
    def down?(args)
      args.inputs.down || args.state.swipe.down
    end

    # check for arrow keys, WASD, gamepad, and swipe left
    def left?(args)
      args.inputs.left || args.state.swipe.left
    end

    # check for arrow keys, WASD, gamepad, and swipe right
    def right?(args)
      args.inputs.right || args.state.swipe.right
    end

    # called by the main #tick method to keep track of swipes, you likely don't
    # need to call this yourself
    #
    # to check for swipes outside of the directional methods above, use it like
    # this:
    #
    # if args.state.swipe.up
    #   # do the thing
    # end
    #
    def track_swipe(args)
      return unless mobile?

      reset_swipe(args) if args.state.swipe.nil? || args.state.swipe.stop_tick
      swipe = args.state.swipe

      if args.inputs.mouse.down
        swipe.merge!({
          start_tick: args.state.tick_count,
          start_x: args.inputs.mouse.x,
          start_y: args.inputs.mouse.y,
        })
      end

      if swipe.start_tick && swipe.start_x && swipe.start_y
        p1 = [swipe.start_x, swipe.start_y]
        p2 = [args.inputs.mouse.x, args.inputs.mouse.y]
        dist = args.geometry.distance(p1, p2)

        if dist > 50 # min distance threshold
          swipe.merge!({
            stop_x: p2[0],
            stop_y: p2[1],
          })

          angle = args.geometry.angle_from(p1, p2)
          swipe.angle = angle
          swipe.dist = dist
          swipe.stop_tick = args.state.tick_count

          if angle > 315 || swipe.angle < 45
            swipe.left = true
          elsif angle >= 45 && angle <= 135
            swipe.down = true
          elsif angle > 135 && angle < 225
            swipe.right = true
          elsif angle >= 225 && angle <= 315
            swipe.up = true
          end
        end
      end
    end

    # reset the currently tracked swipe
    def reset_swipe(args)
      args.state.swipe = { up: false, down: false, right: false, left: false }
    end
  end
end
