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
  def initialize(args, opts = {}, title = title(), menu_options = [])
    super args, opts

    @menu_state ||= {
      current_option_i: 0,
      hold_delay:       0
    }
    @spacer ||= mobile? ? 100 : 80
    @menu_options ||= menu_options
    @menu_y = opts.menu_y._?(440)
    @title ||= title
    @rand_strings = (0..@menu_options.length).map do |i|
      (0...@title.length).map { ('A'..'Z').to_a[rand(26)] }.join
    end
    @first_render = nil
  end

  def render_options(args)
    labels = []
    @menu_options.each.with_index do |option, i|
      active = @menu_state.current_option_i == i && (!mobile? || (mobile? && args.inputs.controller_one.connected))

      text = case option.kind
             when :toggle
               "#{text(option[:key])}: #{text_for_setting_val(args, option[:key])}"
             else
               text(option[:key])
             end

      if (args.state.tick_count - @first_render) < 60 * (1.5 + i) * 0.2
        if args.state.tick_count % 4 == 0
          @rand_strings[i] = (0...(rand(text.length >= 3 ? text.length : 3) + 3)).map { ('A'..'Z').to_a[rand(26)] }.join
        end
        text = @rand_strings[i]
        active = false
      end

      l = label(
        text.upcase,
        x:     (args.grid.w / 2) - 70,
        y:     @menu_y + (@menu_options.length - (i * @spacer)),
        align: ALIGN_CENTER,
        size:  16,
        font:  FONT_DOTMATRIX_BOLD
      )
      l.key = option[:key]
      l.width, l.height = args.gtk.calcstringbox(l.text, l.size_enum, l.font)

      labels << l.merge(active ? WHITE : YELLOW)

      if active
        labels << label(
          '.',
          x:     l.x - (l.width / 2) - 26 - (Math.sin(args.state.tick_count / 8) * 4),
          y:     l.y + 15,
          align: ALIGN_CENTER,
          size:  18,
          font:  FONT_DOTMATRIX
        ).merge(WHITE)
      end

      button_border = { w: 340, h: 80, x: l.x - 170, y: l.y - 55 }.merge(WHITE)
      (args.outputs.borders << button_border) if mobile?
      if args.inputs.mouse.up && args.inputs.mouse.inside_rect?(button_border)
        o = @menu_options.find { |o| o[:key] == l[:key] }
        Sound.play(args, :menu)
        o[:on_select].call(args) if o
      end
    end

    args.outputs.labels << labels
  end

  # called every tick of the game loop
  def tick(args)
    super
    @first_render = args.state.tick_count if @first_render.nil?

    Sprite.for(:menu).render(args)

    args.outputs.labels << label(
      @title.to_s.upcase,
      x:     (args.grid.w / 2) - 70,
      y:     args.grid.top - 175,
      align: ALIGN_CENTER,
      size:  SIZE_LG,
      font:  FONT_RUBIK_BLACK
    ).merge(TRUE_BLACK)

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

    if Input.pressed?(args, :secondary) && !Scene.stack(args).empty?
      Sound.play(args, :select)
      Scene.pop(args)
    end
  end

  # custom logic to reset this scene
  def reset(args)
    super

    @menu_state.current_option_i = 0
    @menu_state.hold_delay = 0
    @first_render = nil
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
