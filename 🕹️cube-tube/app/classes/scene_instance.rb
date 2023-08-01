# frozen_string_literal: true

# class to represent scenes
class SceneInstance
  def initialize(_args, opts = {})
    @tick_in_background = opts.tick_in_background._? false
    @reset_on_pop = opts.reset_on_pop._? false
  end

  attr_reader :tick_in_background
  attr_accessor :reset_on_pop

  def screenshot(args)
    screenshot_path = "../marketing-assets/screenshots/#{args.gtk.platform}"
    now = Time.new
    now_s = "#{now.year}-#{"#{now.month}".rjust(2, "0")}-#{"#{now.day}".rjust(2, "0")} at #{"#{now.hour}".rjust(2, "0")}.#{"#{now.min}".rjust(2, "0")}.#{"#{now.sec}".rjust(2, "0")}"
    base_filename = "#{screenshot_path}/Screenshot - #{args.gtk.platform} - #{now_s}"
    filename = "#{base_filename}.png"
    count = 0
    while !args.gtk.stat_file(filename).nil?
      count += 1;
      filename = "#{base_filename} (#{count}).png"
    end

    args.outputs.screenshots << {
      x: 0, y: 0, w: args.grid.w, h: args.grid.h,    # Which portion of the screen should be captured
      path: filename,        # Output path of PNG file (inside game directory)
      # r: 255, g: 255, b: 255, a: 0   # Optional chroma key
    }

    args.gtk.notify!("Screenshot taken: '#{filename}'")
  end

  # called every tick of the game loop
  def tick(args)
    screenshot(args) if args.inputs.keyboard.ctrl_p
  end

  # custom logic to reset this scene
  def reset(args) end
end
