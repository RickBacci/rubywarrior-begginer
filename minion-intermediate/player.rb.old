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
    p "direction to captive locations: #{@direction_to_captive_locations}"
    p "total enemies in attack range: #{@total_enemies_in_attack_range}"
    p "direction of enemies in attack range: #{@direction_of_enemies_in_attack_range}"

     p "ticking captives: #{ticking_captives?}"
     p "bound enemies: #{@bound_enemies}"
     p "multiple enemies ahead: #{multiple_enemies_ahead?}"
     p "direction to captive: #{towards_captive}"
     #p "captive in danger: #{@captive_in_danger}"
     p "outnumbered: #{outnumbered?}"
     p "path to captives blocked: #{path_to_captives_blocked?}"
     p "path clear towards captive: #{path_clear?(towards_captive)}"
     p "warrior health #{@warrior.health}"
     #p "path traveled last #{@path_traveled.last}"
     #p "serverely wounded: #{severely_wounded?}"
    
    if ticking_captives?
      if !@warrior.feel(towards_captive).empty?#path_to_captives_blocked? #multiple_enemies and trapped
        if outnumbered?
          if @warrior.health <= 4
              retreat_to_safety
          else
            bind_closest_enemy
          end
        else # not outnumbered
          if !@direction_of_enemies_in_attack_range.empty?
            if @warrior.health < 4
              retreat_to_safety
            else
              @warrior.attack!(towards_captive)
            end
          elsif @warrior.health < 14
            if path_clear?(towards_captive)
              @warrior.walk!(towards_captive)
            else
              @warrior.rest!
            end
          
            #free_captives
          elsif @warrior.feel(towards_captive).empty?
            @warrior.walk!(towards_captive)
            @path_traveled << towards_captive
          else
            #bind_closest_enemy
            @warrior.attack!(towards_captive)
          end
          #p "here"
           #kill_enemies
           #bind_closest_enemy
           #@warrior.walk!(towards_captive)
           #@warrior.attack!(towards_captive)
        end
      else # clear space towards captive
        
        #free_captives
        if @warrior.feel(towards_captive).empty?
          if @warrior.health < 10 && @retreat == true
            @warrior.rest!
            # if path_clear?(towards_captive)
            #   @warrior.walk!(towards_captive)
            #   @path_traveled << towards_captive
            # else
            #   @warrior.rest!
            # end
          else
            @retreat = false
            @warrior.walk!(towards_captive)
            @path_traveled << towards_captive
          end
        else
          bind_closest_enemy
          #@warrior.attack!(towards_captive)
        end
      end
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
