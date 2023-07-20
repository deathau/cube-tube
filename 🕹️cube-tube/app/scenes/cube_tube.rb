# frozen_string_literal: true

# this is the main gameplay!
class CubeTubeGame < GameplayScene
  def initialize(args, opts = {})
    super

    @args = args

    @blocksize = 30
    @grid_w = 10
    @grid_h = 20
    @grid_x = 180
    @grid_y = ((1280 - (@grid_h * @blocksize)) / 2) - 21
    @start_grid_x = @grid_x
    @start_grid_y = @grid_y
    @bg_x = 0
    @bg_w = Sprite.for(:tunnel_loop).w

    @next_piece_box = [2, -9, 7, 7]

    @sprite_index = [
      Sprite.for(:black),
      Sprite.for(:cyan),
      Sprite.for(:blue),
      Sprite.for(:orange),
      Sprite.for(:yellow),
      Sprite.for(:green),
      Sprite.for(:violet),
      Sprite.for(:red),
      Sprite.for(:gray)
    ]

    @grid = []

    @lines = 0
    @level = 0
    @current_speed = 0
    @next_move = 0
    @gameover = false
    @showgameover = false

    @current_piece_x = 0
    @current_piece_y = 0
    @current_piece = nil
    @current_piece_rotation = 0
    @next_piece = nil
    @lines_to_clear = []
    @line_clear_timer = 0
    @lock_delay = 30
    @lock_timer = 0

    @current_song = 0
    @current_song_progress = 0

    @cursor_down = nil
    @cursor_down_tick = nil
    @cursor_piece_x_origin = nil
    @cursor_piece_y_origin = nil

    # wall kick tests taken from https://tetris.fandom.com/wiki/SRS#Wall_Kicks
    @wall_kick_tests = {
      [0, 1] => [[-1, 0], [-1, 1], [0, -2], [-1, -2]],
      [1, 0] => [[1, 0], [1, -1], [0, 2], [1, 2]],
      [1, 2] => [[1, 0], [1, -1], [0, 2], [1, 2]],
      [2, 1] => [[-1, 0], [-1, 1], [0, -2], [-1, -2]],
      [2, 3] => [[1, 0], [1, 1], [0, -2], [1, -2]],
      [3, 2] => [[-1, 0], [-1, -1], [0, 2], [-1, 2]],
      [3, 0] => [[-1, 0], [-1, -1], [0, 2], [-1, 2]],
      [0, 3] => [[1, 0], [1, 1], [0, -2], [1, -2]],
    }

    @wall_kick_tests_i = {
      [0, 1] => [[-2, 0], [1, 0], [-2, -1], [1, 2]],
      [1, 0] => [[2, 0], [-1, 0], [2, 1], [-1, -2]],
      [1, 2] => [[-1, 0], [2, 0], [-1, 2], [2, -1]],
      [2, 1] => [[1, 0], [-2, 0], [1, -2], [-2, 1]],
      [2, 3] => [[2, 0], [-1, 0], [2, 1], [-1, -2]],
      [3, 2] => [[-2, 0], [1, 0], [-2, -1], [1, 2]],
      [3, 0] => [[1, 0], [-2, 0], [1, -2], [-2, 1]],
      [0, 3] => [[-1, 0], [2, 0], [-1, 2], [2, -1]],
    }

    @song = [
      [
        [:underscore_b, :underscore2_a, :underscore2_b, :underscore_bridge1, :underscore_bridge2_a, :underscore_b, :underscore_a],
        [:silent_bar,   :silent_bar,    :silent_bar,    :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar],
      ],[
        [:lead_beats,   :lead_beats,   :lead_beats,    :lead_beats,    :silent_bar, :silent_bar, :silent_bar, :silent_bar, :lead_beats, :lead_beats],
        [:underscore_a, :underscore_b, :underscore2_a, :underscore2_b, :underscore_bridge1, nil, :underscore_bridge2_a, nil, nil,     :underscore_b]
      ],[
        [:fill1, :fill1, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar],
        [nil,    nil,    :lead1,      nil,         nil,         nil,         :lead2,      nil,         nil,         nil]
      ],[
        [:silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar],
        [:post_lead,  nil,         :post_lead2, nil,         :loop1_a,    :loop1_b,    :loop1_a,    :loop1_b,    :loop2_a,    :loop2_b,    :loop2_a,    :loop2_b],

      ],[
        [:fill1, :fill1, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar, :silent_bar],
        [nil,    nil,    :lead1,      nil,         nil,         nil,         :lead2,      nil,         nil,         nil,         :post_lead,  nil,         :post_lead2, nil,         :loop1_a,    :loop1_b,    :loop1_a,    :loop1_b,    :loop2_a,    :loop2_b,    :loop2_a,    :loop2_b]
      ]
    ]

    reset(args)
  end

  def render_background
    # draw a solid black background
    @args.outputs.solids << [
      0,
      0,
      1280,
      1280,
      0, 0, 0
    ]

    if @gameover
      @gameover_tick = @args.state.tick_count if @gameover_tick == 0
      ease = 1.0 - @args.easing.ease(@gameover_tick, @args.state.tick_count, 60, :quad)
      @bg_x += (@level + 5) * ease
    else
      @bg_x += @level + 5 unless @gameover
    end
    @bg_x %= @bg_w if @bg_x >= @bg_w

    Sprite.for(:tunnel_loop).render(@args, { x: @bg_x + @bg_w, y: 0, w: @bg_w, h: 720 })
    Sprite.for(:tunnel_loop).render(@args, { x: @bg_x, y: 0, w: @bg_w, h: 720 })
    Sprite.for(:tunnel_loop).render(@args, { x: @bg_x - @bg_w, y: 0, w: @bg_w, h: 720 })
    Sprite.for(:tunnel_loop).render(@args, { x: @bg_x - (@bg_w * 2), y: 0, w: @bg_w, h: 720 })

    # @grid_y = ((1280 - (@grid_h * @blocksize)) / 2) - 21
    Sprite.for(:train).render(@args, { x: 0, y: @grid_x - 140.75 })
  end

  def render_foreground
    Sprite.for(:tracks).render(@args, { x: @bg_x, y: 0, w: @bg_w })
    Sprite.for(:tracks).render(@args, { x: @bg_x - @bg_w, y: 0, w: @bg_w })

    Sprite.for(:train_fore).render(@args, { x: 0, y: @grid_x - 140.75 })
  end

  # x and y are positions in the grid, not pixels
  def render_block(x, y, color)
    @sprite_index[color].render(
      @args,
      {
        x: (1280 - @grid_y) - (y * @blocksize) - 6,
        y: @grid_x + (x * @blocksize),
        w: @blocksize + 6,
        h: @blocksize
      }
    )
  end

  def render_grid
    (0..@grid_w - 1).each do |x|
      (0..@grid_h - 1).each do |y|
        if @grid[x][y] != 0
          render_block(x, y, @grid[x][y]) if !@lines_to_clear.include?(y) || (@line_clear_timer % 14) < 7
        elsif (x - @current_piece_x).between?(0, @current_piece.length - 1) &&
              (y - @current_piece_y).between?(0, @current_piece[x - @current_piece_x].length - 1) &&
              !@current_piece[x - @current_piece_x][y - @current_piece_y].zero?
          # render the current piece
          render_block(x, y, @current_piece[x - @current_piece_x][y - @current_piece_y]) if @lines_to_clear.empty?
        end
      end
    end
  end

  def render_piece(piece, piece_x, piece_y)
    (0..piece.length - 1).each do |x|
      (0..piece[x].length - 1).each do |y|
        render_block(piece_x + x, piece_y + y, piece[x][y]) if piece[x][y] != 0
      end
    end
  end

  def render_next_piece
    screen_x = @grid_y + 705
    screen_y = @grid_x + 80
    screen_w = 250
    screen_h = 200

    Sprite.for(:screen).render(@args, { x: screen_x, y: screen_y + 10, w: screen_w, h: screen_h + 10 })

    next_piece = @line_clear_timer <= 0 ? @next_piece : @current_piece
    centerx = (@next_piece_box[2] - next_piece.length) / 2
    centery = (@next_piece_box[3] - next_piece[0].length) / 2

    render_piece next_piece, @next_piece_box[0] + centerx, @next_piece_box[1] + centery

    @args.outputs.labels << label(
      'Next piece',
      x:     screen_x + (screen_w / 2),
      y:     screen_y + screen_h - 10,
      align: ALIGN_CENTER,
      size:  8,
      font:  FONT_DOTMATRIX,
      color: YELLOW
    )

    screen_s =
      case (@args.state.tick_count % 32)
      when 0..7 then :screen_s1
      when 8..15 then :screen_s2
      when 16..23 then :screen_s3
      when 24..31 then :screen_s4
      end

    Sprite.for(screen_s).render(@args, { x: screen_x, y: screen_y + 10, w: screen_w, h: screen_h + 10 })
  end

  def render_score
    @args.outputs.labels << label(
      "Lines: #{@lines}",
      x:     65,
      y:     @grid_x + 215,
      size:  10,
      color: YELLOW,
      font:  FONT_DOTMATRIX
    )
    @args.outputs.labels << label(
      "Level: #{@level}",
      x:     60,
      y:     @grid_x + 165,
      size:  10,
      color: YELLOW,
      font:  FONT_DOTMATRIX
    )
    #  [200, 600, "Lines: #{@lines}", 10, 255, 255, 255, 255]
    # @args.outputs.labels << [400, 600, "Level: #{@level}", 10, 255, 255, 255, 255]
  end

  def render_gameover
    @args.outputs.solids << [0, 245, 1280, 200, 0, 0, 0, 255]
    @args.outputs.labels << [200, 450, 'GAME OVER', 100, 255, 255, 255, 255]
  end

  def render
    render_background
    render_next_piece
    render_grid
    render_foreground
    render_score
    render_gameover if @showgameover
  end

  def piece_colliding(piece, piece_x, piece_y)
    return true if (piece_x + piece.length) > @grid_w || piece_x < 0

    (0..piece.length - 1).each do |x|
      (0..piece[x].length - 1).each do |y|
        next if piece[x][y].zero?
        if (piece_y + y >= @grid_h) ||
           ((piece_y + y) >= 0 && @grid[piece_x + x][piece_y + y] != 0)
          return true
        end
      end
    end
    false
  end

  def current_piece_colliding
    piece_colliding(@current_piece, @current_piece_x, @current_piece_y)
    # (0..@current_piece.length - 1).each do |x|
    #   (0..@current_piece[x].length - 1).each do |y|
    #     next if @current_piece[x][y].zero?
    #     if (@current_piece_y + y >= @grid_h) ||
    #         ((@current_piece_y + y) >= 0 && @grid[@current_piece_x + x][@current_piece_y + y] != 0)
    #       return true
    #     end
    #   end
    # end
    # false
  end

  def get_speed
    case @level
    when 0 then 53
    when 1 then 49
    when 2 then 45
    when 3 then 41
    when 4 then 37
    when 5 then 33
    when 6 then 28
    when 7 then 22
    when 8 then 17
    when 9 then 11
    when 10 then 10
    when 11 then 9
    when 12 then 8
    when 13 then 7
    when 14..15 then 6
    when 16..17 then 5
    when 18..19 then 4
    else 3
    end
  end

  def change_music
    @current_song = (@current_song + 1) % @song.length
    @current_song_progress = 0
    
    case @level
    when 5
      Music.queue_up(:bridge)
    when 10
      Music.queue_up(:bridge)
    when 15
      Music.queue_up(:bridge)
    when 20 
      Music.queue_up(:bridge)
    end
  end

  def line_full?(row)
    (0..@grid_w - 1).each do |x|
      return false if @grid[x][row].zero?
    end
    true
  end

  def plant_current_piece
    @lock_timer -= 1
    return unless @lock_timer <= 0

    @cursor_down = nil
    @cursor_piece_x_origin = nil
    @cursor_piece_y_origin = nil

    (0..@current_piece.length - 1).each do |x|
      (0..@current_piece[x].length - 1).each do |y|
        next if @current_piece[x][y].zero?

        @grid[@current_piece_x + x][@current_piece_y + y] = @current_piece[x][y]
      end
    end

    @lines_to_clear = []

    # see if any rows need to be cleared out
    (0..@grid_h - 1).each do |y|
      next unless line_full?(y)

      # no empty space in the row
      @lines_to_clear.push y
      @lines += 1
      @line_clear_timer = 70
      if (@lines % 10).floor.zero?
        @level += 1
        change_music()
        Sound.play(@args, :horn)
      end
    end

    select_next_piece
    if @lines_to_clear.empty?
      Sound.play(@args, :drop)
      if current_piece_colliding
        @gameover = true
        Sound.play(@args, :train_stop2)
        Music.stop(@args)
      end
    else
      Sound.play(@args, :clear)
      Sound.play(@args, :fourlines) if @lines_to_clear.length == 4
      @current_speed = get_speed
    end

    @next_move = @current_speed + 2
  end

  def select_next_piece
    @current_piece = @next_piece

    @current_piece_x = 4
    @current_piece_y = -1
    @current_piece_rotation = 0
    @lock_timer = @lock_delay

    r = (rand 7) + 1
    @next_piece =
      case r
      when 1 then [[r], [r], [r], [r]]     # I
      when 2 then [[0, r], [0, r], [r, r]] # J
      when 3 then [[r, r], [0, r], [0, r]] # L
      when 4 then [[r, r], [r, r]]         # O
      when 5 then [[r, 0], [r, r], [0, r]] # S
      when 6 then [[0, r], [r, r], [0, r]] # T
      when 7 then [[0, r], [r, r], [r, 0]] # Z
      end
    select_next_piece if @current_piece.nil?
  end

  def wall_kick(new_piece, old_rotation, new_rotation)
    is_i = new_piece.length == 1 || (new_piece.length == 4 && new_piece[0].length == 1)
    
    kick_test_set = is_i ? @wall_kick_tests_i : @wall_kick_tests
    kick_test = kick_test_set[[old_rotation, new_rotation]]
    kick_test.each do |t|
      collide = piece_colliding(new_piece, @current_piece_x + t[0], @current_piece_y + t[1])
      next if collide

      @current_piece_x += t[0]
      @current_piece_y += t[1]
      return true
    end
    false
  end

  def rotate_current_piece(new_piece, new_rotation)
    should_rotate = false
    if piece_colliding(new_piece, @current_piece_x, @current_piece_y)
      should_rotate = wall_kick(new_piece, @current_piece_rotation, new_rotation)
    else
      should_rotate = true
    end

    if should_rotate
      @lock_timer = @lock_delay
      @current_piece_rotation = new_rotation
      @current_piece = new_piece
      Sound.play(@args, :rotate)
    else
      # wall kick failed. Don't do the rotation
      Sound.play(@args, :move_deny)
    end
  end

  def rotate_current_piece_left
    new_piece = @current_piece.transpose.map(&:reverse)
    new_rotation = (@current_piece_rotation - 1) % 4
    rotate_current_piece(new_piece, new_rotation)
  end

  def rotate_current_piece_right
    new_piece = @current_piece.transpose.map(&:reverse)
    new_piece = new_piece.transpose.map(&:reverse)
    new_piece = new_piece.transpose.map(&:reverse)
    new_rotation = (@current_piece_rotation + 1) % 4
    rotate_current_piece(new_piece, new_rotation)
  end

  def fill_grid
    b = false
    (0..@grid_h - 1).each do |y|
      (0..@grid_w - 1).each do |x|
        if @grid[x][y].zero?
          @grid[x][y] = (rand 7) + 1
          b = true
        end
      end
      return nil if b
    end
    @showgameover = true
  end

  def restart_game
    reset(@args)
  end

  def move_current_piece_up
    if (@current_piece_x + @current_piece.length) < @grid_w
      @current_piece_x += 1
      if current_piece_colliding
        Sound.play(@args, :move_deny)
        @current_piece_x -= 1
      else
        Sound.play(@args, :move)
        @lock_timer = @lock_delay
      end
    else
      Sound.play(@args, :move_deny)
    end
  end

  def move_current_piece_down
    if @current_piece_x.positive?
      @current_piece_x -= 1
      if current_piece_colliding
        Sound.play(@args, :move_deny)
        @current_piece_x += 1
      else
        Sound.play(@args, :move)
        @lock_timer = @lock_delay
      end
    else
      Sound.play(@args, :move_deny)
    end
  end

  def iterate_line_clear
    return false unless @line_clear_timer.positive?

    @line_clear_timer -= 1
    return true unless @line_clear_timer.zero?

    @lines_to_clear.each do |y|
      y.downto(1).each do |i|
        (0..@grid_w - 1).each do |j|
          @grid[j][i] = @grid[j][i - 1]
        end
      end
      (0..@grid_w - 1).each do |i|
        @grid[i][0] = 0
      end
    end
    Sound.play(@args, :drop)
    @lock_timer = @lock_delay
    @lines_to_clear = []
    false
  end

  def iterate_input
    restart_game if Input.pressed?(@args, :primary) && @gameover && @showgameover
    return if @gameover

    if @lines_to_clear.empty?
      move_current_piece_down if Input.pressed?(@args, :down)
      move_current_piece_up if Input.pressed?(@args, :up)
      if Input.pressed_or_held?(@args, :left)
        @next_move -= @current_speed / 3
        @lock_timer -= 3 if @lock_timer.positive?
      end
      rotate_current_piece_left if Input.pressed?(@args, :rotate_left)
      rotate_current_piece_right if Input.pressed?(@args, :rotate_right)

      if @args.inputs.mouse.button_left || @args.inputs.finger_one
        if @cursor_down.nil?
          @cursor_down = @args.inputs.mouse.button_left ? @args.inputs.mouse.point : @args.inputs.finger_one
          @cursor_down_tick = @args.state.tick_count
          @cursor_piece_x_origin = @current_piece_x
          @cursor_piece_y_origin = @current_piece_y
        end

        cursor = @args.inputs.mouse.button_left ? @args.inputs.mouse.point : @args.inputs.finger_one

        delta_x = cursor.x - @cursor_down.x
        if delta_x.negative? && delta_x.abs > (@blocksize * 2) && @cursor_piece_x_origin == @current_piece_x
          @next_move -= @current_speed / 3
          @lock_timer -= 3 if @lock_timer.positive?
          return
        end

        delta_y = cursor.y - @cursor_down.y
        delta_block = (delta_y / @blocksize).floor
        max_delta = 0
        if delta_block.negative?
          @cursor_piece_x_origin.downto((@cursor_piece_x_origin + delta_block)) do |i|
            break if piece_colliding(@current_piece, i, @current_piece_y)

            max_delta = i
          end
        else
          @cursor_piece_x_origin.upto((@cursor_piece_x_origin + delta_block)) do |i|
            break if piece_colliding(@current_piece, i, @current_piece_y)

            max_delta = i
          end
        end
        @current_piece_x = max_delta
      else
        if !@cursor_down.nil? && (@cursor_down_tick + 30) >= @args.state.tick_count && @cursor_piece_x_origin == @current_piece_x
          if @cursor_down.x < 640
            rotate_current_piece_right
          else
            rotate_current_piece_left
          end
        end
        @cursor_down = nil
        @cursor_down_tick = nil
        @cursor_piece_x_origin = nil
        @cursor_piece_y_origin = nil
      end

      if @args.inputs.mouse.click
        rotate_current_piece_left if @cursor_piece_x_origin.nil?
      end
    end

    if @args.inputs.keyboard.key_down.equal_sign
      @level += 1
      @lines += 10
      change_music()
      Sound.play(@args, :horn)
    end
  end

  # train bounce effect
  def iterate_train_bounce
    # TODO: time it better to the music
    case @args.state.tick_count % (@current_speed * 6)
    when 0..3, (@current_speed * 2)..((@current_speed * 2) + 3)
      @grid_x = @start_grid_x + 3
    else
      @grid_x = @start_grid_x
    end
  end

  def iterate_movement
    @next_move -= 1
    return unless @next_move <= 0

    @current_piece_y += 1

    if current_piece_colliding
      @current_piece_y -= 1
      plant_current_piece
    else
      @lock_timer = @lock_delay
      @next_move = @current_speed
    end
  end

  def iterate_music
    Music.resume(@args) if !Music.stopped?(@args) && Music.paused?(@args)
    return unless Music.stopped?(@args, 0) && (!Music.queue[0] || Music.queue[0].empty?)

    song_length = @song[@current_song][0].length
    @current_song_progress = @current_song_progress % song_length # just in case we changed to a shorter song
    @song[@current_song].each_with_index do |track, i|
      if @current_song_progress < track.length && !track[@current_song_progress].nil?
        Music.play(@args, track[@current_song_progress], { channel: i })
      end
    end
    @current_song_progress = (@current_song_progress + 1) % song_length
  end

  def iterate
    # input first
    iterate_input

    fill_grid if @gameover && !@showgameover
    # skip the rest if it's game over
    return if @gameover

    iterate_music

    iterate_train_bounce

    # if we're currently animating a line clear, then skip the movement logic
    return if iterate_line_clear

    iterate_movement
  end

  # called every tick of the game loop
  def tick(args)
    iterate
    render
    super
  end

  # custom logic to reset this scene
  def reset(args)
    super

    @lines = 0
    @level = 0
    @current_speed = get_speed
    @next_move = @current_speed
    @gameover = false
    @showgameover = false
    @gameover_tick = 0

    @current_piece_x = 4
    @current_piece_y = -1
    @current_piece = nil
    @current_piece_rotation = 0
    @next_piece = nil
    select_next_piece
    @lines_to_clear = []
    @line_clear_timer = 0

    @bg_x = 0

    (0..@grid_w - 1).each do |x|
      @grid[x] = []
      (0..@grid_h - 1).each do |y|
        @grid[x][y] = 0
      end
    end

    @current_song = 0
    @current_song_progress = 0
    Music.stop(args)
    Music.set_volume(args, args.state.setting.music ? 0.6 : 0.0)
    Music.play(args, :underscore_a)
  end
end
