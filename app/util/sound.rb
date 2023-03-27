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

# # play a sound effect. the file in sounds/ must match the key name. ex:
# # play_sfx(args, :select)
# def play_sfx(args, key)
#   if args.state.setting.sfx
#     args.outputs.sounds << "sounds/#{key}.wav"
#   end
# end

# # play the specified music track, the key must correspond to the
# # `sounds/#{key}.ogg` file naming scheme.
# def play_music(args, key)
#   args.audio[:music] = { input: "sounds/#{key}.ogg", looping: true, }
#   set_music_vol(args)
# end

# # sets the music vol based on whether or not music is enabled or disabled
# def set_music_vol(args)
#   vol = args.state.setting.music ? 0.8 : 0.0
#   args.audio[:music]&.gain = vol
# end

# # pause the currently playing music track
# def pause_music(args)
#   args.audio[:music].paused = true
# end

# # pause the current music track
# def resume_music(args)
#   args.audio[:music].paused = false
# end

# # stop the currently playing music track
# def stop_music(args)
#   args.audio.delete(:music)
# end
