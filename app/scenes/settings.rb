# frozen_string_literal: true

# This is the settings menu, allowing for various settings to be changed
class SettingsMenu < MenuScene
  def initialize(args, opts = {})
    menu_options = [
      {
        key:       :sfx,
        kind:      :toggle,
        on_select: ->(args) do
          GameSetting.save_after(args) do |args|
            args.state.setting.sfx = !args.state.setting.sfx
          end
        end
      },
      {
        key:       :music,
        kind:      :toggle,
        on_select: ->(args) do
          GameSetting.save_after(args) do |args|
            args.state.setting.music = !args.state.setting.music
            Music.set_volume(args, args.state.setting.music ? 0.8 : 0.0)
          end
        end
      },
      {
        key:       :back,
        on_select: ->(iargs) { Scene.pop(iargs) }
      }
    ]

    if args.gtk.platform?(:desktop)
      menu_options.insert(
        menu_options.length - 1,
        {
          key:       :fullscreen,
          kind:      :toggle,
          on_select: ->(args) do
            GameSetting.save_after(args) do |args|
              args.state.setting.fullscreen = !args.state.setting.fullscreen
              args.gtk.set_window_fullscreen(args.state.setting.fullscreen)
            end
          end
        }
      )
    end

    super args, opts, menu_options
  end

  # called every tick of the game loop
  def tick(args)
    draw_bg(args, DARK_GREEN)

    # actual menu logic is handled by the MenuScene super class
    super

    args.outputs.labels << label(
      :settings,
      x:     args.grid.w / 2,
      y:     args.grid.top - 200,
      align: ALIGN_CENTER,
      size:  SIZE_LG,
      font:  FONT_BOLD
    )
  end
end
