# frozen_string_literal: true

# A scene represents a discreet state of gameplay. Things like the main menu,
# game over screen, and gameplay.
#
# Define a new scene by adding one to `app/scenes/` and inheriting from
# SceneInstance
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
      args.state.scene_stack ||= []
      # if we're here /not/ from push or pop, clear the scene stack
      args.state.scene_stack.clear unless push_or_pop
      args.state.scene_stack.push(scene) if args.state.scene_stack.empty?

      scene.reset(args) if reset

      args.state.scene = scene
      raise FinishTick, 'finish tick early'
    end

    # Change the current scene and push the previous scene onto the stack
    def push(args, scene, reset: false)
      args.state.scene_stack ||= []
      the_scene = scene.is_a?(SceneInstance) ? scene : SCENES[scene].new(args)
      args.state.scene_stack.push(the_scene)

      switch(args, the_scene, reset: reset, push_or_pop: true)
    end

    # Return to the previous scene on the stack
    def pop(args, reset: false)
      scene = args.state.scene_stack&.pop

      switch(args, scene._?(default(args)), reset: reset, push_or_pop: true)
    end

    def default(args)
      args.state.scene_stack ||= []
      SCENES[:DEFAULT].new(args)
    end
  end
end
