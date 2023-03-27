# frozen_string_literal: true

# class to represent scenes
class SceneInstance
  def initialize(_args, opts = {})
    @tick_in_background = opts.tick_in_background._? false
  end

  attr_reader :tick_in_background

  # called every tick of the game loop
  def tick(args) end

  # custom logic to reset this scene
  def reset(args) end
end
