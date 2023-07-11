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

    def stopped?(args, channel = nil)
      channel_names(args, channel).none? do |c|
        args.audio.key?(c)
      end
    end

    def paused?(args, channel = nil)
      channel_names(args, channel).all? do |c|
        args.audio.key?(c) && args.audio[c].paused
      end
    end

    def stop(args, channel = nil)
      channel_names(args, channel).each do |c|
        args.audio.delete(c)
      end
    end

    def pause(args, channel = nil)
      channel_names(args, channel).each do |c|
        args.audio[c].paused = true unless stopped?(args, c)
      end
    end

    def resume(args, channel = nil)
      channel_names(args, channel).each do |c|
        args.audio[c].paused = false unless stopped?(args, c)
      end
    end

    def set_volume(args, volume, channel = nil)
      channel_names(args, channel).each do |c|
        args.audio[c].gain = volume
      end
    end

    def channel_names(args, channel = nil)
      if channel.nil?
        args.audio.keys.select do |key|
          key.start_with? 'MUSIC_CHANNEL_'
        end
      elsif channel.is_a?(String)
        [channel]
      elsif channel.is_a?(Numeric)
        ["MUSIC_CHANNEL_#{channel}"]
      else
        channel
      end
    end

    def tick(args)
      queue.each do |channel, value|
        next if value.empty?

        if args.audio["MUSIC_CHANNEL_#{channel}"]
          args.audio["MUSIC_CHANNEL_#{channel}"].looping = false if args.audio["MUSIC_CHANNEL_#{channel}"].looping
        else
          value.shift.play_music(args, { channel: channel, gain: args.state.setting.music ? 0.8 : 0.0, paused: false })
        end
      end
    end
  end
end
