require 'health'
require 'enemies'
require 'captives'
require 'intel'
require 'movement'

class Player

  def play_turn(warrior)
  	@warrior = warrior
    @path_traveled ||= []
    @bound_enemies ||= []

    #p @path_traveled.empty?
    #p previous_location

    # p listen_for_intel
   
    # p @enemy_locations.size
    # p number_of_enemies_next_to_warrior
    # p next_enemy?
    # p next_to_warrior?(:enemy)

  	
  	if ticking_captives?
      if found_a_captive
        rescue_captive
  		else  
  		  walk_towards_captive
  		end
    elsif next_to_warrior?(:enemy) #enemies_are_near?
      if outnumbered?
        bind_closest_enemy
      else
        if severely_wounded?
          retreat_to_safety
        else
          attack_closest_enemy
        end
      end
  	elsif hit_points_needed?
      recover_from_battle
    elsif captives_in_room?
      if found_a_captive
        rescue_captive
      else
        walk_towards_captive
      end
    elsif room_clear?
      walk_towards_stairs
  	else
      walk_around_object
  	end
  end
  print %x{clear}
end
