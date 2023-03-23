# frozen_string_literal: true

module Music
  MUSIC = {
    music1: SoundInstance.new({ path: 'music/music1.ogg', looping: true }),
    music2: SoundInstance.new({ path: 'music/music2.ogg', looping: true })
  }
end
