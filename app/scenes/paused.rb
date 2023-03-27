# frozen_string_literal: true

# This is the pause menu, triggered by a button press when the player wants a
# break from gameplay.
class PauseMenu < MenuScene
  def initialize(args, opts = {})
    menu_options = [
      {
        key:       :resume,
        on_select: ->(args) { Scene.pop(args) }
      },
      {
        key:       :settings,
        on_select: ->(args) { Scene.push(args, :settings, reset: true) }
      },
      {
        key:       :return_to_main_menu,
        on_select: ->(args) { Scene.switch(args, :main_menu) }
      }
    ]

    if args.gtk.platform?(:desktop)
      menu_options << {
        key:       :quit,
        on_select: ->(args) { args.gtk.request_quit }
      }
    end

    super args, opts, menu_options
  end

  # called every tick of the game loop
  def tick(args)
    super
    Music.pause(args) unless Music.stopped(args) || Music.paused(args)

    args.outputs.labels << label(
      :paused,
      x:     args.grid.w / 2,
      y:     args.grid.top - 200,
      align: ALIGN_CENTER,
      size:  SIZE_LG,
      font:  FONT_BOLD
    )
  end
end
