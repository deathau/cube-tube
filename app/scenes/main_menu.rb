# frozen_string_literal: true

# This is the first screen in this game, allowing access to everything else
class MainMenu < MenuScene
  def initialize(args, opts = {})
    # these are the menu options for the main menu
    menu_options = [
      {
        key:       :start,
        on_select: ->(iargs) { Scene.switch(iargs, :cube_tube, reset: true) }
      },
      {
        key:       :settings,
        on_select: ->(iargs) { Scene.push(iargs, :settings, reset: true) }
      }
    ]

    if args.gtk.platform?(:desktop)
      menu_options << {
        key:       :quit,
        on_select: ->(iargs) { iargs.gtk.request_quit }
      }
    end

    super args, opts, menu_options
  end

  # called every tick of the game loop
  def tick(args)
    draw_bg(args, DARK_PURPLE)

    # actual menu logic is handled by the MenuScene super class
    super

    # additionally draw some labels with information about the game
    labels = []
    labels << label(
      "v#{version}",
      x: 32.from_left, y: 32.from_top,
      size: SIZE_XS, align: ALIGN_LEFT
    )
    labels << label(
      title.upcase, x: args.grid.w / 2, y: args.grid.top - 100,
      size: SIZE_LG, align: ALIGN_CENTER, font: FONT_BOLD_ITALIC
    )
    labels << label(
      "#{text(:made_by)} #{dev_title}",
      x: args.grid.left + 24, y: 48,
      size: SIZE_XS, align: ALIGN_LEFT
    )
    labels << label(
      :controls_title,
      x: args.grid.right - 24, y: 84,
      size: SIZE_SM, align: ALIGN_RIGHT
    )
    labels << label(
      args.inputs.controller_one.connected ? :controls_gamepad : :controls_keyboard,
      x: args.grid.right - 24, y: 48,
      size: SIZE_XS, align: ALIGN_RIGHT
    )

    args.outputs.labels << labels
  end
end
