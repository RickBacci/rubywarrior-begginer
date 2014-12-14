require 'health'
require 'enemies'
require 'captives'
require 'intel'
require 'movement'

class Player

  def play_turn(warrior)
  	@warrior = warrior
    @path_traveled ||= []

    gather_intel
   
    #p @path_traveled
    #p ticking_captives?

  	
  	if ticking_captives?
      if found_a_ticking_captive
        rescue_captive
  		else  
  		  walk_towards_ticking_captive
  		end
    elsif enemies_are_near?
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
      if room_clear?
        walk_towards_stairs 
      else
        recover_from_battle
      end
  	elsif captives_are_near?
  		rescue_closest_captive
    elsif captives_in_room?
      walk_towards_captive
    elsif room_clear?
      walk_towards_stairs
  	else
      walk_around_stairs
  	end
  end
  print %x{clear}
end
