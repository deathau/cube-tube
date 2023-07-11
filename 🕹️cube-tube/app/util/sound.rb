# frozen_string_literal: true

# Module for managing and interacting with sounds.
module Sound
  class << self
    def for(key)
      SOUNDS.fetch(key)
    end

    def play(args, key, opts = {})
      SOUNDS.fetch(key).play(args, opts) if args.state.setting.sfx
    end

    def stop(args, key)
      SOUNDS.fetch(key).stop(args)
    end

    def pause(args, key)
      SOUNDS.fetch(key).pause(args)
    end

    def resume(args, key)
      SOUNDS.fetch(key).resume(args)
    end
  end
end