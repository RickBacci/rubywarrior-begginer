require 'health'
require 'enemies'
require 'captives'
require 'intel'
require 'movement'
require 'debugging'

class Player

  def play_turn(warrior)
  	@warrior = warrior
    @path_traveled ||= []
    @bound_enemies ||= []
    @queue ||= []
    @blocked = false if @blocked.nil?
    # @current_goal = [:ticking_captives, :captives, :enemies, :bound_enemies, :stairs]

    p listen_for_intel  # do not comment out!
    p look_for_intel    # do not comment out!
    p feel_for_intel    # do not comment out!

    # p @bound_enemies
    
    # p found_a_captive
    p @around_warrior.has_value?("wall")
    
    if previous_orders?
      enact_orders
    elsif next_to_warrior?(:enemy)
      engage_enemy
  	elsif hit_points_needed?
      recover_from_battle
    elsif captives_in_room?
      free_captives
    elsif bound_enemy?
      kill_bound_enemies
    elsif enemies_in_room?
      kill_enemies
    elsif room_clear?
      #towards_stairs
      walk_towards(:stairs)
  	else
      p 'Warrior doing nothing'
  	end
  end
end
