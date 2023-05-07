# frozen_string_literal: true

module Music
  MUSIC = {
    ambience:             SoundInstance.new({ path: 'music/ambience1.ogg', looping: true }),
    underscore_a:         SoundInstance.new({ path: 'music/pyramids/underscore1_a.ogg', looping: false }),
    underscore_b:         SoundInstance.new({ path: 'music/pyramids/underscore1_b.ogg', looping: false }),
    underscore2_a:        SoundInstance.new({ path: 'music/pyramids/underscore2_a.ogg', looping: false }),
    underscore2_b:        SoundInstance.new({ path: 'music/pyramids/underscore2_b.ogg', looping: false }),
    underscore_bridge1:   SoundInstance.new({ path: 'music/pyramids/underscore_bridge1.ogg', looping: false }),
    underscore_bridge2_a: SoundInstance.new({ path: 'music/pyramids/underscore_bridge2+a.ogg', looping: false }),
    lead_beats:           SoundInstance.new({ path: 'music/pyramids/lead_beats.ogg', looping: false }),
    fill1:                SoundInstance.new({ path: 'music/pyramids/fill1.ogg', looping: false }),
    lead1:                SoundInstance.new({ path: 'music/pyramids/lead1.ogg', looping: false }),
    lead2:                SoundInstance.new({ path: 'music/pyramids/lead2.ogg', looping: false }),
    loop1_a:              SoundInstance.new({ path: 'music/pyramids/loop1_a.ogg', looping: false }),
    loop1_b:              SoundInstance.new({ path: 'music/pyramids/loop1_b.ogg', looping: false }),
    loop2_a:              SoundInstance.new({ path: 'music/pyramids/loop1_a.ogg', looping: false }),
    loop2_b:              SoundInstance.new({ path: 'music/pyramids/loop1_b.ogg', looping: false }),
    post_lead:            SoundInstance.new({ path: 'music/pyramids/post_lead.ogg', looping: false }),
    post_lead2:           SoundInstance.new({ path: 'music/pyramids/post_lead2.ogg', looping: false }),
    bridge:               SoundInstance.new({ path: 'music/pyramids/underscore_bridge2+a.ogg', looping: false }),
    silent_bar:           SoundInstance.new({ path: 'music/pyramids/silent_bar.ogg', looping: false }),
  }
end
