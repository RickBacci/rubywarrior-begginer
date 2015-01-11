require 'objectives'

require 'intel'
require 'warrior_actions'

require 'warrior_listens'
require 'warrior_looks'
require 'warrior_feels'

require 'debugging'


class Player

  attr_reader :warrior, :path_traveled, :possible_directions, :action,
              :objectives, :warrior_heard, :warrior_saw, :warrior_felt, :look_for_direction,
              :total_enemies, :total_captives, :captives_in_range

  def initialize
    @possible_directions = [:forward, :right, :backward, :left]
    @path_traveled ||= []
    @objectives = []
    @stairs ||= false
    @warrior_health ||= 20
    @debugging if @debugging.nil?
    @log = []
    @next_objective = nil
    @warrior_felt = {}
    @warrior_heard = nil
    @warrior_saw = {}
    @captives_in_range if @captives_in_range.nil?
    @total_captives = 0
    @total_enemies = 0
    @distance_to_next_objective = nil
    @objectives = []
    @action = false
  end


  def play_turn(warrior)
    record_action

    @warrior = warrior
    @action = false
    @path_blocked == false

    @objectives = warrior_listens

    warrior_looks
    warrior_feels

    #debugging
    

    
    warrior_walk(towards_stairs) if objectives_accomplished
       
    if nowhere_to_move

      rescue_captive if !action && next_to_captive
      bind_enemies if !action && multiple_enemies_next_to_warrior? # level 9
        
      blow_stuff_up(towards_objective) if !action
    end
      

    if perfect_bomb_location 
      blow_stuff_up(look_for_direction) if !action
    end

     
    if any_captives?
      rescue_captive if !action && next_to_captive
      attack_enemy if !action && next_to_last_enemy # level 6
    end


    warrior_rest if !action && warrior_should_rest?
      

    if danger_far

      walk_towards_objective if !action && path_clear
      blow_stuff_up(towards_objective) if !action
    end


    if danger_close

      blow_stuff_up(towards_objective) if !action && multiple_enemies_next_to_warrior?
      attack_enemy if !action
    end


    if bound_enemies?

      attack_enemy if !action && bound_enemy_close
    end


    walk_towards_objective if !action

    @warrior_health = warrior.health

    print_log
  end
end
