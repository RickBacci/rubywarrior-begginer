require 'health'
require 'enemies'
require 'captives'
require 'intel'
require 'movement'

class Player

  def play_turn(warrior)
  	@warrior = warrior

    gather_intel
    p listen_for_intel
		

    p captives_in_room?

  	
  	if enemies_are_near?
  		if outnumbered?
  			bind_closest_enemy
  		else
  		  attack_closest_enemy # add logic to attack bound sludges
  		end
  	elsif severely_wounded?
  		stop_to_rest
  	elsif captives_are_near?
  		rescue_closest_captive
    elsif captives_in_room?
      warrior.walk!(direction_to_captive)
  	else
  	  walk_towards_stairs
  	end
  end
end
