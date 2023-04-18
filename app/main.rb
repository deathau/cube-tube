# frozen_string_literal: true

# first, third-party libraries
require 'lib/coalesce.rb'

# then, some basic classes required for lists of assets
require 'app/classes/sprite_instance.rb'
require 'app/classes/sound_instance.rb'
require 'app/classes/scene_instance.rb'

# then, asset lists
require 'sprites/_list.rb'
require 'sounds/_list.rb'
require 'music/_list.rb'

# then, default keybindings
require 'app/keybindings.rb'

# then, utility classes
require 'app/util/sprite.rb'
require 'app/util/sound.rb'
require 'app/util/music.rb'
require 'app/util/util.rb'
require 'app/util/input.rb'

require 'app/constants.rb'
require 'app/game_setting.rb'
require 'app/text.rb'

# then, the scenes
require 'app/scenes/menu.rb'
require 'app/scenes/gameplay.rb'
require 'app/scenes/main_menu.rb'
require 'app/scenes/paused.rb'
require 'app/scenes/settings.rb'
require 'app/scenes/cube_tube.rb'
require 'app/scenes/intro.rb'

require 'app/scenes/_list.rb'
require 'app/util/scene.rb'

# finally, the main tick
# NOTE: add all other requires above this
require 'app/tick.rb'
