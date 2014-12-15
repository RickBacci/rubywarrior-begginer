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

     listen_for_intel # do not comment out!

     # p @enemies_near_warrior
     #  p @nearby_enemy_locations
     #  p "bound enemies: #{@bound_enemies}"
     # p @captive_locations
     #  p " enemy locations #{@enemy_locations}"
     p number_of_enemies_ahead?
     p multiple_enemies_ahead?
     p ticking_captives?

    
  	if ticking_captives?
      free_captives
    elsif next_to_warrior?(:enemy)
      if outnumbered?
        bind_closest_enemy
      elsif severely_wounded?
        retreat_to_safety
      elsif multiple_enemies_ahead?
        kill_enemies
      else
        attack_closest_enemy
      end
  	elsif hit_points_needed?
      recover_from_battle
    elsif captives_in_room?
      free_captives
    elsif bound_enemy?
      kill_bound_enemies
    elsif enemies_in_room?
      kill_enemies
    elsif room_clear?
      walk_towards(:stairs)
  	else
      p 'Warrior doing nothing'
      
  	end
  end
end
