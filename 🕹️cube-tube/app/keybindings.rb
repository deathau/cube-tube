# frozen_string_literal: true

# Set the default input / key bindings here
module Input
  class << self
    PRIMARY_KEYS = [:j, :z, :space]
    SECONDARY_KEYS = [:k, :x, :backspace]
    PAUSE_KEYS = [:escape, :p]
    BINDINGS = {
      primary:      {
        keyboard:       %i[j z space],
        controller_one: %i[a]
      },
      secondary:    {
        keyboard:       %i[k x backspace],
        controller_one: %i[b]
      },
      pause:        {
        keyboard:       %i[escape p],
        controller_one: %i[start]
      },
      rotate_left:  {
        keyboard:       %i[q j z space],
        controller_one: %i[a l1]
      },
      rotate_right: {
        keyboard:       %i[e x backspace],
        controller_one: %i[b l2]
      },
      up:           {
        keyboard:       %i[w up],
        controller_one: %i[up]
      },
      down:         {
        keyboard:       %i[s down],
        controller_one: %i[down]
      },
      left:         {
        keyboard:       %i[a left],
        controller_one: %i[left]
      },
      right:        {
        keyboard:       %i[d right],
        controller_one: %i[right]
      }
    }
  end
end
