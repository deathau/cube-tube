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
    @bg_w = 1335

    @next_piece_box = [2, -9, 7, 7]

    @sprite_index = [
      Sprite.for(:black),
      Sprite.for(:red),
      Sprite.for(:green),
      Sprite.for(:blue),
      Sprite.for(:yellow),
      Sprite.for(:indigo),
      Sprite.for(:violet),
      Sprite.for(:orange),
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
    @next_piece = nil
    @lines_to_clear = []
    @line_clear_timer = 0

    @current_music = :music1

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

    @bg_x += (@level + 1) * 2 unless @gameover
    @bg_x %= @bg_w if @bg_x >= @bg_w

    Sprite.for(:tunnel).render(@args, { x: @bg_x, y: 0, w: @bg_w, h: 720 })
    Sprite.for(:tunnel).render(@args, { x: @bg_x - @bg_w, y: 0, w: @bg_w, h: 720 })

    # @grid_y = ((1280 - (@grid_h * @blocksize)) / 2) - 21
    Sprite.for(:train).render(@args, { x: 0, y: @grid_x - 140.75 })
  end

  def render_foreground
    Sprite.for(:tracks).render(@args, { x: @bg_x, y: 0, w: @bg_w, h: 720 })
    Sprite.for(:tracks).render(@args, { x: @bg_x - @bg_w, y: 0, w: @bg_w, h: 720 })

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
        if @grid[x][y] != 0 && (!@lines_to_clear.include?(y) || (@line_clear_timer % 14) < 7)
          render_block(x, y, @grid[x][y])
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

  def render_current_piece
    render_piece(@current_piece, @current_piece_x, @current_piece_y) if @line_clear_timer <= 0
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

    @args.outputs.labels << [screen_x + 33, screen_y + screen_h - 8, 'Next piece', 8, 255, 255, 255, 255 ]

    screen_s =
      case (@args.state.tick_count % 32)
      when 0..7
        :screen_s1
      when 8..15
        :screen_s2
      when 16..23
        :screen_s3
      when 24..31
        :screen_s4
      end

    Sprite.for(screen_s).render(@args, { x: screen_x, y: screen_y + 10, w: screen_w, h: screen_h + 10 })
  end

  def render_score
    @args.outputs.labels << [200, 600, "Lines: #{@lines}", 10, 255, 255, 255, 255]
    @args.outputs.labels << [400, 600, "Level: #{@level}", 10, 255, 255, 255, 255]
  end

  def render_gameover
    @args.outputs.solids << [0, 245, 1280, 200, 0, 0, 0, 255]
    @args.outputs.labels << [200, 450, 'GAME OVER', 100, 255, 255, 255, 255]
  end

  def render
    render_background
    render_next_piece
    render_current_piece
    render_grid
    render_foreground
    render_score
    render_gameover if @showgameover
  end

  def current_piece_colliding
    (0..@current_piece.length - 1).each do |x|
      (0..@current_piece[x].length - 1).each do |y|
        next if @current_piece[x][y].zero?
        if (@current_piece_y + y >= @grid_h) ||
            ((@current_piece_y + y) >= 0 && @grid[@current_piece_x + x][@current_piece_y + y] != 0)
          return true
        end
      end
    end
    false
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
    @current_music = @current_music == :music1 ? :music2 : :music1
    Music.queue_up(@current_music)
  end

  def line_full?(row)
    (0..@grid_w - 1).each do |x|
      return false if @grid[x][row].zero?
    end
    true
  end

  def plant_current_piece
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
        change_music
      end
    end

    select_next_piece
    if @lines_to_clear.empty?
      Sound.play(@args, :drop)
      if current_piece_colliding
        @gameover = true
        Music.stop(@args)
      end
    else
      Sound.play(@args, :clear)
      @current_speed = get_speed
    end

    @next_move = @current_speed + 2
  end

  def select_next_piece
    @current_piece = @next_piece

    @current_piece_x = 4
    @current_piece_y = -1

    r = (rand 7) + 1
    @next_piece =
      case r
      when 1 then [[r, 0], [r, r], [0, r]]
      when 2 then [[0, r], [r, r], [r, 0]]
      when 3 then [[r, r, r], [r, 0, 0]]
      when 4 then [[r, r], [r, r] ]
      when 5 then [[r], [r], [r], [r]]
      when 6 then [[r, 0], [r, r], [r, 0]]
      when 7 then [[r, 0, 0], [r, r, r]]
      end
    select_next_piece if @current_piece.nil?
  end

  def rotate_current_piece_left
    Sound.play(@args, :rotate)
    @current_piece = @current_piece.transpose.map(&:reverse)
    @current_piece_x = @grid_w - @current_piece.length if (@current_piece_x + @current_piece.length) >= @grid_w
  end

  def rotate_current_piece_right
    Sound.play(@args, :rotate)
    @current_piece = @current_piece.transpose.map(&:reverse)
    @current_piece = @current_piece.transpose.map(&:reverse)
    @current_piece = @current_piece.transpose.map(&:reverse)
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
    @lines_to_clear = []
    false
  end

  def iterate_input
    restart_game if Input.pressed?(@args, :primary) && @gameover && @showgameover
    return if @gameover

    move_current_piece_down if Input.pressed?(@args, :down)
    move_current_piece_up if Input.pressed?(@args, :up)
    @next_move -= @current_speed / 3 if Input.pressed_or_held?(@args, :left)
    rotate_current_piece_left if Input.pressed?(@args, :rotate_left)
    rotate_current_piece_right if Input.pressed?(@args, :rotate_right)
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

    @next_move = @current_speed
    @current_piece_y += 1

    return unless current_piece_colliding

    @current_piece_y -= 1
    plant_current_piece
  end

  def iterate
    # input first
    iterate_input

    fill_grid if @gameover && !@showgameover
    # skip the rest if it's game over
    return if @gameover

    # resume music if it's paused
    Music.resume(@args) if !Music.stopped(@args) && Music.paused(@args)

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

    @current_piece_x = 4
    @current_piece_y = -1
    @current_piece = nil
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

    @current_music = :music1
    Music.play(args, @current_music)
    Music.set_volume(args, args.state.setting.music ? 0.8 : 0.0)
  end
end
