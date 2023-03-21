# A scene represents a discreet state of gameplay. Things like the main menu,
# game over screen, and gameplay.
#
# Define a new scene by adding one to `app/scenes/` and defining a
# `Scene.tick_SCENE_NAME` class method.
#
# The main `#tick` of the game handles delegating to the current scene based on
# the `args.state.scene` value, which is a symbol of the current scene, ex:
# `:gameplay`
module Scene
  class << self
    # Change the current scene, and optionally reset the scene that's begin
    # changed to so any data is cleared out
    # ex:
    #   Scene.switch(args, :gameplay)
    def switch(args, scene, reset: false, push_or_pop: false)
      # if we're here /not/ from push or pop, clear the scene stack
      args.state.scene_stack.clear unless push_or_pop

      if reset
        args.state.send(scene)&.current_option_i = nil
        args.state.send(scene)&.hold_delay = nil

        # you can also add custom reset logic as-needed for specific scenes
        # here
      end

      args.state.scene = scene
      raise FinishTick, 'finish tick early'
    end

    # Change the current scene and push the previous scene onto the stack
    def push(args, scene, reset: false)
      puts "Pushing #{scene}"
      args.state.scene_stack ||= []
      args.state.scene_stack.push(args.state.scene)

      switch(args, scene, reset: reset, push_or_pop: true)
    end

    # Return to the previous scene on the stack
    def pop(args, reset: false)
      scene = !args.state.scene_stack || args.state.scene_stack.empty? ? :back : args.state.scene_stack.pop
      switch(args, scene, reset: reset, push_or_pop: true)
    end
  end
end
