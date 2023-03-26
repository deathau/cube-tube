module Scene
  class << self
    # scene reached from gameplay when the player needs a break
    def tick_paused(args)
      draw_bg(args, DARK_YELLOW)

      options = [
        {
          key: :resume,
          on_select: -> (args) { Scene.pop(args) }
        },
        {
          key: :settings,
          on_select: -> (args) { Scene.push(args, :settings, reset: true) }
        },
        {
          key: :return_to_main_menu,
          on_select: -> (args) { Scene.switch(args, :main_menu) }
        },
      ]

      if args.gtk.platform?(:desktop)
        options << {
          key: :quit,
          on_select: -> (args) { args.gtk.request_quit }
        }
      end

      Menu.tick(args, :paused, options)

      Music.pause(args) unless Music.stopped(args)

      if Input.pressed?(args, :secondary)
        Sound.play(args, :select)
        options.find { |o| o[:key] == :resume }[:on_select].call(args)
        
      end

      args.outputs.labels << label(:paused, x: args.grid.w / 2, y: args.grid.top - 200, align: ALIGN_CENTER, size: SIZE_LG, font: FONT_BOLD)
    end
  end
end
