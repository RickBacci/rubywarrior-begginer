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
    # p listen_for_intel
    # p captives_in_room?
    # p next_enemy?
    p @everything_in_room
    #p direction_around_stairs
    #p !@warrior.feel.stairs?
    p "Is room clear? #{room_clear?}"
    p "bound enemies #{@bound_enemies}"

  	
  	if enemies_are_near?
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
      #system `clear`
      print %x{clear}

end
