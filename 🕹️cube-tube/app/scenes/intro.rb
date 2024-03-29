# frozen_string_literal: true

# this is the lead-in to the main gameplay
class Intro < GameplayScene
  def initialize(args, opts = {})
    super

    @train_duration = 190
    @train_spline = [
      [1.0, 0.25, 0, 0]
    ]
    @full_station_w = Sprite.for(:station_loop).w + Sprite.for(:station_end).w
    @station_start_w = Sprite.for(:station_start).w
    @tunnel_w = Sprite.for(:tunnel_loop).w
    @full_station_start_w = @station_start_w + @tunnel_w
    @tracks_w = Sprite.for(:tracks).w

    @leave_duration = 500
    @leave_spline = [
      [0, 0, 0.5, 1.0]
    ]
    reset(args)
  end

  # called every tick of the game loop
  def tick(args)
    if Input.pressed?(args, :primary)
      Scene.switch(args, :cube_tube, reset: true)
    end

    now = args.state.tick_count

    if @start.zero? || @start.nil?
      @start = now
      Sound.play(args, :train_stop)
    end

    case @state
    when 0
      if (now - @start) > 60
        @train_start = now
        @state += 1
      end
    when 1
      @train_pos = @train_start_pos * args.easing.ease_spline(@train_start, now, @train_duration, @train_spline)
      if @train_pos <= 0
        @state += 1
        @wait_start = now
        Sound.play(args, :chime)
      end
    when 2
      if (now - @wait_start) > 60
        @leave_start = now
        @state += 1
        Sound.play(args, :train_leave)
      end
    when 3
      ease = args.easing.ease_spline(@leave_start, now, @leave_duration, @leave_spline)
      @station_pos = @full_station_start_w * ease

      @screen_on = true if ease > 0.75

      if @station_pos >= @full_station_start_w
        Scene.switch(args, :cube_tube, reset: true)
      end
    end

    dirt = Sprite.for(:dirt)
    dx = 0 - @full_station_start_w - @tunnel_w
    while dx < @full_station_w
      dirt.render(args, { x: @station_pos + dx, y: 0 - dirt.h + 1 })
      dirt.render(args, { x: @station_pos + dx, y: args.grid.h })
      dx += dirt.w
    end

    Sprite.for(:station_loop).render(args, { x: @station_pos })
    Sprite.for(:station_start).render(args, { x: @station_pos - @station_start_w })
    Sprite.for(:tunnel_loop).render(args, { x: @station_pos - @full_station_start_w })
    Sprite.for(:tunnel_loop).render(args, { x: @station_pos - @full_station_start_w - @tunnel_w })

    Sprite.for(:train).render(args, { y: 39.25, x: @train_pos })
    Sprite.for(:screen).render(args, { x: @train_pos + 1024, y: 270 })

    if @screen_on
      screen_s =
        case (now % 32)
        when 0..7 then :screen_s1
        when 8..15 then :screen_s2
        when 16..23 then :screen_s3
        when 24..31 then :screen_s4
        end

      Sprite.for(screen_s).render(args, { x: @train_pos + 1024, y: 270 })
    end

    Sprite.for(:tracks).render(args, { x: @station_pos })
    Sprite.for(:tracks).render(args, { x: @station_pos - @tracks_w })
    Sprite.for(:tracks).render(args, { x: @station_pos - (@tracks_w * 2) })
    Sprite.for(:train_fore).render(args, { y: 39.25, x: @train_pos })
    
    super
  end

  # custom logic to reset this scene
  def reset(args)
    super
    @state = 0
    @start = 0
    @train_start = 0
    @wait_start = 0
    @leave_start = 0
    @train_pos = @train_start_pos = 1500
    @station_pos = 0
    @screen_on = false
  end
end