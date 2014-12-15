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

    p listen_for_intel # do not comment out!

    
  	if ticking_captives?
      free_captives
    elsif next_to_warrior?(:enemy)
      if outnumbered?
        bind_closest_enemy
      elsif severely_wounded?
        retreat_to_safety
      else
        attack_closest_enemy
      end
  	elsif hit_points_needed?
      recover_from_battle
    elsif captives_in_room?
      free_captives
    elsif room_clear?
      walk_towards(:stairs)
  	else
      p 'Act casual'
      #walk_around_object
  	end
  end
  print %x{clear}
end
