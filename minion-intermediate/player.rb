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
    @current_goal = [:ticking_captives, :captives, :enemies, :bound_enemies, :stairs]

    listen_for_intel  # do not comment out!
    look_for_intel    # do not comment out!


  	if ticking_captives?
      
      if previous_orders?
        enact_orders
      elsif outnumbered? && trapped?
      
        if surrounded?
          bind_closest_enemy
        else
          if warrior_has_yet_to_move
            bind_closest_enemy
          else
            move_away_to_throw_bombs
          end
        end
      else # not outnumbered or trapped, and no previous orders
        if single_enemy?
          if severely_wounded_with_enemies_in_room?
            stop_to_rest
          elsif multiple_enemies_ahead?
            @warrior.detonate!(towards_captive)
          else
            walk_towards(:captive)
          end
        elsif @warrior.health < 10 && enemies_in_room?
          @warrior.rest!
        elsif @warrior.feel(towards_captive).empty?
          walk_towards(:captive)
        elsif @warrior.feel(towards_captive).captive?
          @warrior.rescue!(towards_captive)
        else
          p 'ticking captives...not outnumbered?'
        end
      end
    elsif next_to_warrior?(:captive) && @bound_enemies == [] # no ticking captives
      free_captives
    elsif next_to_warrior?(:enemy) ### none of this will happen
      if outnumbered?              ### until captive saved!
        bind_closest_enemy
      elsif severely_wounded?
        move_to_safety
      elsif multiple_enemies_ahead?
        free_captives if captives_in_room?
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
