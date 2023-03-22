# frozen_string_literal: true

# first, third-party libraries
require 'lib/coalesce.rb'

# then, some basic classes required for lists of assets
require 'app/sprite_instance.rb'

# then, asset lists
require 'sprites/_list.rb'

# then, utility classes
require 'app/input.rb'
require 'app/sprite.rb'
require 'app/util.rb'
require 'app/sound.rb'

require 'app/constants.rb'
require 'app/menu.rb'
require 'app/scene.rb'
require 'app/game_setting.rb'
require 'app/text.rb'

# then, the scenes
require 'app/scenes/gameplay.rb'
require 'app/scenes/main_menu.rb'
require 'app/scenes/paused.rb'
require 'app/scenes/settings.rb'
require 'app/scenes/cube_tube.rb'

# finally, the main tick
# NOTE: add all other requires above this
require 'app/tick.rb'
