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
      #if severely_wounded? && enemies_in_room?
       # @warrior.rest!
      if previous_orders?
        enact_orders
      elsif outnumbered? && trapped?
      #elsif trapped?
        if surrounded?
          bind_closest_enemy
        else
          if warrior_has_yet_to_move
            bind_closest_enemy
          else
            move_away_to_throw_bombs
          end
        end
      # elsif outnumbered?
      #   if @warrior.feel(towards_captive).empty?
      #     walk_towards(:captive)
      #   else
      #     bind_closest_enemy
      #   end
      else # not outnumbered or trapped, and no previous orders
        if @direction_of_enemies_in_attack_range.size == 1
          if severely_wounded? && enemies_in_room?
          #if @warrior.health < 5 && enemies_in_room?
            @warrior.rest!
          elsif how_far_to('Captive') != 2
            if @warrior.feel(towards_captive).empty?
              walk_towards(:captive)
            elsif multiple_enemies_ahead?
              @warrior.detonate!(towards_captive)
            else
              walk_towards(:captive)
            end
          else
            walk_towards(:captive)
          end
        elsif @warrior.health < 10 && enemies_in_room?
          @warrior.rest!
        elsif how_far_to('Captive') != 2
          if @warrior.feel.enemy? || @blocked
            @warrior.detonate!(towards_captive)
            @blocked = false
          elsif @warrior.feel(towards_captive).enemy?
            @blocked = true
            move_to_safety
          elsif @warrior.feel(towards_captive).captive?
            @warrior.rescue!(towards_captive)
          else
            walk_towards(:captive)
          end
        elsif @warrior.feel(towards_captive).empty?
          walk_towards(:captive)
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
