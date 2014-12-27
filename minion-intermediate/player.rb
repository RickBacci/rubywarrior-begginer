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
    look_for_intel # do not comment out!

    #p "direction of all enemies: #{@directions_to_all_enemies}"
    # p "direction to captive locations: #{@direction_to_captive_locations}"
    # p "total enemies in attack range: #{@total_enemies_in_attack_range}"
     #p "direction of enemies in attack range: #{@direction_of_enemies_in_attack_range}"
  #   p "trapped? #{trapped?}"
  #    p "ticking captives: #{ticking_captives?}"
  #    p "bound enemies: #{@bound_enemies}"
    #  p "multiple enemies ahead: #{multiple_enemies_ahead?}"
  #    p "direction to captive: #{towards_captive}"
    #  #p "captive in danger: #{@captive_in_danger}"
    #  p "outnumbered: #{outnumbered?}"
    #  p "path to captives blocked: #{path_to_captives_blocked?}"
    #  p "path clear towards captive: #{path_clear?(towards_captive)}"
    #  p "warrior health #{@warrior.health}"
     p "path traveled last #{@path_traveled.last}"
     #p "serverely wounded: #{severely_wounded?}"
     #p look_for_enemies_towards_captives
     #p "distance to captive #{how_far_to('Captive')}"
     #p too_close_to_captive_for_bombs('Captive')
     #p @warrior.health

     @blocked = false if @blocked.nil?

    
  	if ticking_captives?
      if @warrior.health < 4
        @warrior.rest!
      elsif outnumbered? && trapped?
        bind_closest_enemy
      elsif outnumbered?
        p 'outnumbered'
        if @warrior.feel(towards_captive).empty?
          @warrior.walk!(towards_captive)
          @path_traveled << towards_captive
        else
          @warrior.attack!(towards_captive)
        end
      else # not outnumbered
        if @direction_of_enemies_in_attack_range.size == 1
          if @warrior.health < 4
            @warrior.rest!
          elsif how_far_to('Captive') != 2
            @warrior.detonate!(towards_captive)
          else
            p 'not outnumbered'
            @warrior.walk!(towards_captive)
            @path_traveled << towards_captive
          end
        elsif @warrior.health < 10
          @warrior.rest!
        elsif how_far_to('Captive') != 2
          #kill_enemies
          p 'bomb in here?'
          if @warrior.feel.enemy? || @blocked
            @warrior.detonate!(towards_captive)
            @blocked = false
          elsif @warrior.feel(towards_captive).enemy?
            @blocked = true
            retreat_to_safety
          elsif @warrior.feel(towards_captive).captive?
            @warrior.rescue!(towards_captive)
          else
            @warrior.walk!(towards_captive)
            @path_traveled << towards_captive
          end
        elsif @warrior.feel(towards_captive).empty?
          @warrior.walk!(towards_captive)
          @path_traveled << towards_captive
          #@warrior.detonate!(towards_captive)
        else
          #
        end
      end





    elsif next_to_warrior?(:enemy) ### none of this will happen
      if outnumbered?              ### until captive saved!
        bind_closest_enemy
      elsif severely_wounded?
        retreat_to_safety
      elsif multiple_enemies_ahead?
        p "in multiple_enemies_ahead"
        if captives_in_room?
          @warrior.attack!(towards_captive)
        else
          @warrior.attack!(next_to_warrior?(:enemy))
        #kill_enemies ## can't be just captive
        end
        
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
