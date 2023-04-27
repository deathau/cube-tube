# frozen_string_literal: true

# This is the first screen in this game, allowing access to everything else
class MainMenu < MenuScene
  def initialize(args, opts = {})
    # these are the menu options for the main menu
    menu_options = [
      {
        key:       :start,
        on_select: ->(iargs) { Scene.switch(iargs, :intro, reset: true) }
      },
      {
        key:       :settings,
        on_select: ->(iargs) { Scene.push(iargs, :settings, reset: true, reset_on_pop: true) }
      }
    ]

    if args.gtk.platform?(:desktop)
      menu_options << {
        key:       :quit,
        on_select: ->(iargs) { iargs.gtk.request_quit }
      }
    end

    super args, opts, title, menu_options
  end

  # called every tick of the game loop
  def tick(args)
    # actual menu logic is handled by the MenuScene super class
    super

    Music.play(args, :ambience) if args.state.setting.music && Music.stopped(args)
    @next_announcement ||= 0
    if @next_announcement <= args.state.tick_count
      next_sec = random(20..50)
      @next_announcement = args.state.tick_count + (next_sec * 60)
      sound = :"ambient#{random(1..6)}"
      puts sound, Sound.for(sound).input
      Sound.play(args, sound)
    end

    # additionally draw some labels with information about the game
    labels = []
    labels << label(
      "v#{version}",
      x: 400.from_right, y: 150.from_bottom,
      size: SIZE_XS, align: ALIGN_RIGHT,
      font: FONT_DOTMATRIX
    ).merge(YELLOW)
    # labels << label(
    #   title.upcase, x: args.grid.w / 2, y: args.grid.top - 100,
    #   size: SIZE_LG, align: ALIGN_CENTER, font: FONT_BOLD_ITALIC
    # )
    labels << label(
      "#{text(:made_by)} #{dev_title}",
      x: 242.from_left, y: 150.from_bottom,
      size: SIZE_XS, align: ALIGN_LEFT,
      font: FONT_DOTMATRIX
    ).merge(YELLOW)
    # labels << label(
    #   :controls_title,
    #   x: args.grid.right - 24, y: 84,
    #   size: SIZE_SM, align: ALIGN_RIGHT
    # )
    # labels << label(
    #   args.inputs.controller_one.connected ? :controls_gamepad : :controls_keyboard,
    #   x: args.grid.right - 24, y: 48,
    #   size: SIZE_XS, align: ALIGN_RIGHT
    # )

    args.outputs.labels << labels
  end
end
