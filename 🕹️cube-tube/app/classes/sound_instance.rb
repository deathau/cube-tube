# frozen_string_literal: true

# class to represent sound files
class SoundInstance
  def initialize(opts)
    @input = opts[:input]._? opts[:path]
    @key = opts[:key]._? @input
    @x = opts[:x]._? 0.0
    @y = opts[:y]._? 0.0
    @z = opts[:z]._? 0.0
    @gain = opts[:gain]._? opts[:volume]._? 1.0
    @pitch = opts[:pitch]._? 1.0
    @paused = opts[:paused]._? false
    @looping = opts[:looping]._? false
  end

  attr_reader :key, :input, :x, :y, :z, :gain, :pitch, :paused, :looping

  def input=(input)
    args.audio[@key].input = input if args.audio[@key]
    @input = input
  end

  def x=(xval)
    args.audio[@key].x = xval if args.audio[@key]
    @x = xval
  end

  def y=(yval)
    args.audio[@key].y = yval if args.audio[@key]
    @y = yval
  end

  def z=(zval)
    args.audio[@key].z = zval if args.audio[@key]
    @z = zval
  end

  def xyz(xval, yval, zval)
    if args.audio[@key]
      args.audio[@key].x = xval
      args.audio[@key].y = yval
      args.audio[@key].z = zval
    end
    @x = xval
    @y = yval
    @z = zval
  end

  def xyz=(xyz=[])
    xyz(xyz[0], xyz[1], xyz[2])
  end

  def gain=(gain)
    args.audio[@key].gain = gain if args.audio[@key]
    @gain = gain
  end

  def pitch=(pitch)
    args.audio[@key].pitch = pitch if args.audio[@key]
    @pitch = pitch
  end

  def paused=(paused)
    args.audio[@key].paused = paused if args.audio[@key]
    @paused = paused
  end

  def looping=(looping)
    args.audio[@key].looping = looping if args.audio[@key]
    @looping = looping
  end

  def playtime
    args.audio[@key].playtime._?(0.0)
  end

  def playtime=(playtime)
    args.audio[@key].playtime = playtime
  end

  # convenience getter for 'path' (@input)
  def path
    @input
  end

  # convenience setter for 'path' (@input)
  def path=(path)
    input(path)
  end

  # convenience getter for 'volume' (@gain)
  def volume
    @gain
  end

  # convenience setter for 'volume' (@gain)
  def volume=(volume)
    gain(volume)
  end

  def play(args, opts = {})
    obj = {
      input:    opts[:input]._?(opts[:path]._?(@input)),
      x:        opts[:x]._?(@x),
      y:        opts[:y]._?(@y),
      z:        opts[:z]._?(@z),
      gain:     opts[:gain]._?(opts[:volume]._?(@gain)),
      pitch:    opts[:pitch]._?(@pitch),
      paused:   opts[:paused]._?(@paused),
      looping:  opts[:looping]._?(@looping),
      playtime: opts[:playtime]._?(0.0)
    }
    args.audio[@key] = obj
  end

  def play_music(args, opts = { channel: 0 })
    # @looping = true
    @key = "MUSIC_CHANNEL_#{opts[:channel]}"
    play(args, opts)
  end

  def stop(args)
    args.audio.delete(@key)
  end

  def pause(args)
    args.audio[@key].paused = true
  end

  def resume(args)
    args.audio[@key].paused = false
  end
end
