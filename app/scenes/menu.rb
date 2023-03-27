# frozen_string_literal: true

# A scene which updates and renders a list of options that get passed through.
#
# +menu_options+ data structure:
# [
#   {
#     text: 'some string',
#     on_select: -> (args) { 'do some stuff in this lambda' }
#   }
# ]
class MenuScene < SceneInstance
  def initialize(args, opts = {}, menu_options = [])
    super args, opts

    @menu_state ||= {
      current_option_i: 0,
      hold_delay:       0
    }
    @spacer ||= mobile? ? 100 : 60
    @menu_options ||= menu_options
    @menu_y = opts.menu_y._?(420)
  end

  def render_options(args)
    labels = []
    @menu_options.each.with_index do |option, i|
      text = case option.kind
             when :toggle
               "#{text(option[:key])}: #{text_for_setting_val(args, option[:key])}"
             else
               text(option[:key])
             end

      l = label(
        text,
        x:     args.grid.w / 2,
        y:     @menu_y + (@menu_options.length - (i * @spacer)),
        align: ALIGN_CENTER,
        size:  SIZE_MD
      )
      l.key = option[:key]
      l.width, l.height = args.gtk.calcstringbox(l.text, l.size_enum)
      labels << l

      if @menu_state.current_option_i == i && (!mobile? || (mobile? && args.inputs.controller_one.connected))
        args.outputs.solids << {
          x: l.x - (l.width / 1.4) - 24 + (Math.sin(args.state.tick_count / 8) * 4),
          y: l.y - 22,
          w: 16,
          h: 16
        }.merge(WHITE)
      end

      button_border = { w: 340, h: 80, x: l.x - 170, y: l.y - 55 }.merge(WHITE)
      (args.outputs.borders << button_border) if mobile?
      if args.inputs.mouse.up && args.inputs.mouse.inside_rect?(button_border)
        o = options.find { |o| o[:key] == l[:key] }
        Sound.play(args, :menu)
        o[:on_select].call(args) if o
      end
    end

    args.outputs.labels << labels
  end

  # called every tick of the game loop
  def tick(args)
    super

    render_options(args)

    move = nil
    if Input.down?(args)
      move = :down
    elsif Input.up?(args)
      move = :up
    else
      @menu_state.hold_delay = 0
    end

    if move
      @menu_state.hold_delay -= 1

      if @menu_state.hold_delay <= 0
        Sound.play(args, :menu)
        index = @menu_state.current_option_i
        if move == :up
          index -= 1
        else
          index += 1
        end

        if index.negative?
          index = @menu_options.length - 1
        elsif index > @menu_options.length - 1
          index = 0
        end
        @menu_state.current_option_i = index
        @menu_state.hold_delay = 10
      end
    end

    if Input.pressed?(args, :primary)
      @menu_options[@menu_state.current_option_i][:on_select].call(args)
      Sound.play(args, :select)
    end
  end

  # custom logic to reset this scene
  def reset(args)
    super

    @menu_state.current_option_i = 0
    @menu_state.hold_delay = 0
  end

  def text_for_setting_val(args, key)
    val = args.state.setting[key]
    case val
    when true
      text(:on)
    when false
      text(:off)
    else
      val
    end
  end
end
