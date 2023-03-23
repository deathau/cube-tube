# frozen_string_literal: true

module Sound
  SOUNDS = {
    menu:      SoundInstance.new({ path: 'sounds/menu.wav' }),
    select:    SoundInstance.new({ path: 'sounds/select.wav' }),
    clear:     SoundInstance.new({ path: 'sounds/clear.wav' }),
    drop:      SoundInstance.new({ path: 'sounds/drop.wav' }),
    move:      SoundInstance.new({ path: 'sounds/move.wav' }),
    move_deny: SoundInstance.new({ path: 'sounds/move_deny.wav' }),
    rotate:    SoundInstance.new({ path: 'sounds/rotate.wav' })
  }
end