# frozen_string_literal: true

# A scene represents a discreet state of gameplay. Things like the main menu,
# game over screen, and gameplay.
#
# Define a new scene by adding one to `app/scenes/` and inheriting from
# SceneInstance
#
# The main `#tick` of the game handles delegating to the current scene based on
# the `args.state.scene_stack` value, which contains the current scene, as well
# as scenes that can be "popped" back to.
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
      
      # if `scene` is not a `SceneInstance`, it's probably a symbol representing
      # the scene we're switching to, so go get it.
      the_scene = scene.is_a?(SceneInstance) ? scene : SCENES[scene].new(args)

      # if the stack is empty (e.g. we just cleared it), then push this scene
      args.state.scene_stack.push(the_scene) if args.state.scene_stack.empty?

      # if we asked to reset the scene, then do so.
      the_scene.reset(args) if reset

      raise FinishTick, 'finish tick early'
    end

    # Change the current scene by pushing it onto the scene stack
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
