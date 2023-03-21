# frozen_string_literal: true

# Extension to the scene class for the cube tube scene
module Scene
  class << self
    def tick_cube_tube(args)
      # call the gameplay scene tick method (handles pause menu, etc)
      tick_gameplay(args)
      args.state.game ||= CubeTubeGame.new args
      args.state.game.tick
    end
  end
end

#
class CubeTubeGame
  def initialize args
    @args = args
    
    @blocksize = 30
    @grid_w = 10
    @grid_h = 20
    @grid_x = 115
    @grid_y = ((1280 - (@grid_h * @blocksize)) / 2) + 143
    @start_grid_x = @grid_x
    @start_grid_y = @grid_y
    @bg_x = 0
    @bg_w = 1335

    @next_piece_box = [2, -9.5, 7, 7]

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

    @music_queue = []

    reset_game
  end

  def reset_game
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

    each 0..@grid_w - 1 do |x|
      @grid[x] = []
      each 0..@grid_h - 1 do |y|
        @grid[x][y] = 0
      end
    end

    @music_queue = [:music1, :music2]
  end

  def render_grid_border x, y, w, h, color

    for i in x..(x+w)-1 do
      render_block i, y, color
      render_block i, (y + h - 1), color
    end

    for i in y..(y+h)-1 do
      render_block x, i, color
      render_block (x + w - 1), i, color
    end
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

    @bg_x += (@level+1)*2 unless @gameover
    if(@bg_x >= @bg_w) 
      @bg_x %= @bg_w
    end

    @args.outputs.sprites << [@bg_x,0,@bg_w,720,Sprite.for(:tunnel)]
    @args.outputs.sprites << [@bg_x-@bg_w,0,@bg_w,720,Sprite.for(:tunnel)]

    @args.outputs.sprites  << [
      0,
      @grid_x - 64,
      1597,
      540,
      Sprite.for(:train)
    ]
  end

  def render_foreground
    @args.outputs.sprites  << [
      0,
      @grid_x - 64,
      1597,
      540,
      Sprite.for(:train_fore)
    ]
  end

  # x and y are positions in the grid, not pixels
  def render_block x, y, color
    @args.outputs.sprites << [
      (1280 - @grid_y) - (y * @blocksize) - 6,
      @grid_x + (x * @blocksize),
      @blocksize + 6, @blocksize,
      @sprite_index[color]
    ]
  end

  def render_grid

    #render_grid_border -1, -1, @grid_w + 2, @grid_h + 2, 8

    for x in 0..@grid_w-1 do
      for y in 0..@grid_h-1 do
        render_block x, y, @grid[x][y] if @grid[x][y] != 0 && (!@lines_to_clear.include?(y) || (@line_clear_timer % 14) < 7)
      end
    end

  end

  def render_piece piece, piece_x, piece_y

    for x in 0..piece.length-1 do
      for y in 0..piece[x].length-1 do
        render_block piece_x + x, piece_y + y, piece[x][y] if piece[x][y] != 0
      end
    end
  end

  def render_current_piece
    render_piece @current_piece, @current_piece_x, @current_piece_y if @line_clear_timer <= 0
  end

  def render_next_piece

    screen_x = @grid_y + 400
    screen_y = @grid_x + 80
    screen_w = 250
    screen_h = 200

    @args.outputs.sprites << [
      screen_x, screen_y + 10, screen_w, screen_h + 10,
      Sprite.for(:screen)
    ]
    
    next_piece = @line_clear_timer <= 0 ? @next_piece : @current_piece
    # render_grid_border *@next_piece_box, 8
    centerx = (@next_piece_box[2] - next_piece.length) / 2
    centery = (@next_piece_box[3] - next_piece[0].length) / 2

    render_piece next_piece, @next_piece_box[0] + centerx, @next_piece_box[1] + centery

    @args.outputs.labels << [screen_x + 33, screen_y + screen_h - 8, "Next piece", 8, 255, 255, 255, 255 ]

    screen_s = case (@args.state.tick_count % 32)
    when 0..7
      :screen_s1
    when 8..15
      :screen_s2
    when 16..23
      :screen_s3
    when 24..31
      :screen_s4
    end

    @args.outputs.sprites << [
      screen_x, screen_y + 10, screen_w, screen_h + 10,
      Sprite.for(screen_s)
    ]
  end

  def render_score
    @args.outputs.labels << [ 200, 600, "Lines: #{@lines}", 10, 255, 255, 255, 255 ]
    @args.outputs.labels << [ 400, 600, "Level: #{@level}", 10, 255, 255, 255, 255 ]
    @args.outputs.labels << [ 400, 563, "(Speed: #{(1/(@current_speed/60)).round 2} L/s)", 0.1, 255, 255, 255, 255 ]
  end

  def render_gameover
    @args.outputs.solids << [ 0, 245, 1280, 200, 0, 0, 0, 255]
    @args.outputs.labels << [ 200, 450, "GAME OVER", 100, 255, 255, 255, 255 ]
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
    for x in 0..@current_piece.length-1 do
      for y in 0..@current_piece[x].length-1 do
        if (@current_piece[x][y] != 0) && ((@current_piece_y + y >= @grid_h) || ((@current_piece_y + y) >= 0 && @grid[@current_piece_x + x][@current_piece_y + y] != 0 ))
          return true
        end
      end
    end
    return false
  end

  def get_speed
    return case @level
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
      when 14 then 6
      when 15 then 6
      when 16 then 5
      when 17 then 5
      when 18 then 4
      when 19 then 4
      when 20 then 3
      else 3
    end
  end

  def plant_current_piece
    rows_to_check = []

    for x in 0..@current_piece.length-1 do
      for y in 0..@current_piece[x].length-1 do
        if @current_piece[x][y] != 0
          col = @current_piece_x + x
          row = @current_piece_y + y
          @grid[col][row] = @current_piece[x][y]
          rows_to_check << row if !rows_to_check.include? row
        end
      end
    end

    @lines_to_clear = []

    # see if any rows need to be cleared out
    for y in 0..@grid_h-1
      full = true
      for x in 0..@grid_w-1
        if @grid[x][y] == 0
          full = false
          break
        end
      end

      if full # no empty space in the row
        @lines_to_clear.push y
        @lines += 1
        @line_clear_timer = 70
        if (@lines%10).floor == 0
          @level += 1 
          @args.audio[:music].looping = false
        end
      end
    end

    select_next_piece
    if @lines_to_clear.empty?
      play_sfx(@args, :drop)
      if current_piece_colliding
        @gameover = true
        stop_music(@args)
      end
    else
      play_sfx(@args, :clear)
      @current_speed = get_speed
    end

    @next_move = @current_speed + 2
  end

  def select_next_piece

    @current_piece = @next_piece

    @current_piece_x = 4
    @current_piece_y = -1

    r = (rand 7) + 1
    @next_piece = case r 
      when 1 then [ [r, 0], [r, r], [0, r]]
      when 2 then [ [0, r], [r, r], [r, 0]]
      when 3 then [ [r, r, r], [r, 0, 0]]
      when 4 then [ [r, r], [r, r] ]
      when 5 then [ [r], [r], [r], [r]]
      when 6 then [ [r, 0], [r, r], [r, 0]]
      when 7 then [ [r, 0, 0], [r, r, r]]
    end
    select_next_piece if @current_piece == nil
  end

  def rotate_current_piece_left
    play_sfx(@args, :rotate)
    @current_piece = @current_piece.transpose.map(&:reverse)
    if(@current_piece_x + @current_piece.length) >= @grid_w
      @current_piece_x = @grid_w - @current_piece.length
    end
  end

  def rotate_current_piece_right
    play_sfx(@args, :rotate)
    @current_piece = @current_piece.transpose.map(&:reverse)
    @current_piece = @current_piece.transpose.map(&:reverse)
    @current_piece = @current_piece.transpose.map(&:reverse)
  end

  def fill_grid
    b = false
    for y in 0..@grid_h-1 do
      for x in 0..@grid_w-1 do
        if @grid[x][y] == 0
          @grid[x][y] = (rand 7) + 1
          b = true
        end
      end
      return if b
    end
    @showgameover = true
  end

  def restart_game
    reset_game
  end

  def iterate

    # check input first
    k = @args.inputs.keyboard
    c = @args.inputs.controller_one

    if @gameover
      if @showgameover
        if k.key_down.space || k.key_down.enter || c.key_down.start
          restart_game
        end
      else
        fill_grid
      end
      return
    end

    if @args.audio[:music]
      resume_music(@args) if @args.audio[:music].paused
      @args.audio[:music].pitch = 1 + (@level * 0.125)
    else
      music = @music_queue.shift
      @music_queue.push music
      play_music(@args, music)
    end

    if @line_clear_timer.positive?
      @line_clear_timer -= 1
      if @line_clear_timer.zero?
        for y in @lines_to_clear
          for i in y.downto(1) do
            for j in 0..@grid_w-1
              @grid[j][i] = @grid[j][i-1]
            end
          end
          for i in 0..@grid_w-1
            @grid[i][0] = 0
          end
        end
        play_sfx(@args, :drop)
        @lines_to_clear = []
      end
      return
    end
    
    if k.key_down.down || k.key_down.s || c.key_down.down
      if @current_piece_x > 0
        @current_piece_x -= 1
        if current_piece_colliding
          play_sfx(@args, :move_deny)
          @current_piece_x += 1
        else
          play_sfx(@args, :move)
        end
      else
        play_sfx(@args, :move_deny)
      end
    end
    if k.key_down.up || k.key_down.w || c.key_down.up
      if (@current_piece_x + @current_piece.length) < @grid_w
        @current_piece_x += 1
        if current_piece_colliding
          play_sfx(@args, :move_deny)
          @current_piece_x -= 1
        else
          play_sfx(@args, :move)
        end
      else
        play_sfx(@args, :move_deny)
      end
    end
    if k.key_down.left || k.key_held.left || k.key_down.a || k.key_held.a || c.key_down.left || c.key_held.left
      @next_move -= @current_speed / 3
    end
    if k.key_down.plus || k.key_down.equal_sign
      @level += 1
      @current_speed = get_speed
    end

    if k.key_down.q || c.key_down.a
      rotate_current_piece_left
    end
    if k.key_down.e || c.key_down.b
      rotate_current_piece_right
    end

    case @args.state.tick_count % (@current_speed * 6)
    when 0..3, (@current_speed * 2)..((@current_speed * 2) + 3)
      @grid_x = @start_grid_x + 3
    else
      @grid_x = @start_grid_x
    end

    @next_move -= 1
    if @next_move <= 0
      @next_move = @current_speed
      @current_piece_y += 1
      if current_piece_colliding
        @current_piece_y -= 1
        plant_current_piece
      end
    end
  end

  def tick
    iterate
    render
  end
end