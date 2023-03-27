# frozen_string_literal: true

# Module for managing and interacting with music.
module Music
  class << self
    def queue
      @queue ||= {}
      @queue
    end

    def queue_up(key, channel = 0)
      @queue[channel] ||= []
      @queue[channel].push(MUSIC.fetch(key))
    end

    def for(key)
      MUSIC.fetch(key)
    end

    def play(args, key, opts = { channel: 0 })
      MUSIC.fetch(key).play_music(args, opts)
    end

    def stopped(args, channel = 0)
      !args.audio.key?("MUSIC_CHANNEL_#{channel}")
    end

    def paused(args, channel = 0)
      args.audio["MUSIC_CHANNEL_#{channel}"].paused unless stopped(args, channel)
    end

    def stop(args, channel = 0)
      args.audio.delete("MUSIC_CHANNEL_#{channel}")
    end

    def pause(args, channel = 0)
      args.audio["MUSIC_CHANNEL_#{channel}"].paused = true unless stopped(args, channel)
    end

    def resume(args, channel = 0)
      args.audio["MUSIC_CHANNEL_#{channel}"].paused = false unless stopped(args, channel)
    end

    def set_volume(args, volume, channel = 0)
      args.audio["MUSIC_CHANNEL_#{channel}"].gain = volume unless stopped(args, channel)
    end

    def tick(args)
      queue.each do |channel, value|
        unless value.empty?
          if args.audio["MUSIC_CHANNEL_#{channel}"]
            if args.audio["MUSIC_CHANNEL_#{channel}"].looping
              args.audio["MUSIC_CHANNEL_#{channel}"].looping = false
            end
          else
            value.shift.play_music(args, { channel: channel, gain: args.state.setting.music ? 0.8 : 0.0 })
          end
        end
      end
    end
  end
end