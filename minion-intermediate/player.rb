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

    listen_for_intel
   
    #p @path_traveled
    #p ticking_captives?
    p next_enemy?

  	
  	if ticking_captives?
      if found_a_captive
        rescue_captive
  		else  
  		  walk_towards_ticking_captive
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
      walk_around_stairs
  	end
  end
  print %x{clear}
end
