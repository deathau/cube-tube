# frozen_string_literal: true

module Sound
  SOUNDS = {
    menu:        SoundInstance.new({ path: 'sounds/menu.wav' }),
    select:      SoundInstance.new({ path: 'sounds/select.wav' }),
    clear:       SoundInstance.new({ path: 'sounds/clear.wav' }),
    fourlines:   SoundInstance.new({ path: 'sounds/fourlines.wav' }),
    drop:        SoundInstance.new({ path: 'sounds/drop.wav' }),
    move:        SoundInstance.new({ path: 'sounds/move.wav' }),
    move_deny:   SoundInstance.new({ path: 'sounds/move_deny.wav' }),
    rotate:      SoundInstance.new({ path: 'sounds/rotate.wav' }),
    gameover:    SoundInstance.new({ path: 'sounds/gameover.wav' }),
    train_stop:  SoundInstance.new({ path: 'sounds/train_stop.wav' }),
    train_stop2: SoundInstance.new({ path: 'sounds/train_stop2.wav' }),
    train_leave: SoundInstance.new({ path: 'sounds/train_leave.wav' }),
    horn:        SoundInstance.new({ path: 'sounds/horn.wav' }),
    chime:       SoundInstance.new({ path: 'sounds/please_stand_clear.wav' }),
    ambient1:    SoundInstance.new({ path: 'sounds/announcement.ogg', loop: false }),
    ambient2:    SoundInstance.new({ path: 'sounds/announcement2.ogg', loop: false }),
    ambient3:    SoundInstance.new({ path: 'sounds/announcement3.ogg', loop: false }),
    ambient4:    SoundInstance.new({ path: 'sounds/announcements.ogg', loop: false }),
    ambient5:    SoundInstance.new({ path: 'sounds/train_pass.ogg', loop: false }),
    ambient6:    SoundInstance.new({ path: 'sounds/train_pass2.ogg', loop: false })
  }
end