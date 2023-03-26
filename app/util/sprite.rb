# frozen_string_literal: true

# Module for managing and interacting with sprites.
module Sprite
  class << self
    def reset_all(args)
      SPRITES.each { |_, v| args.gtk.reset_sprite(v) }
    end

    def for(key)
      SPRITES.fetch(key)
    end
  end
end
