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
    p listen_for_intel
    p captives_in_room?
    p next_enemy?

  	
  	if enemies_are_near?
  		if outnumbered?
  			bind_closest_enemy
  		else
        if severely_wounded?
          retreat_to_safety
        else
  		    attack_closest_enemy # add logic to attack bound sludges
        end
  		end
  	elsif hit_points_needed?#!fully_recovered?
      if room_clear?
        walk_towards_stairs
      else
        #stop_to_rest
        recover_from_battle
      end
  	elsif captives_are_near?
  		rescue_closest_captive
    elsif captives_in_room?
      walk_towards_captive
  	else
  	  walk_towards_stairs
  	end
  end
      #system `clear`
      print %x{clear}

end
