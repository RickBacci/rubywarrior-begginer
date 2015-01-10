require 'objects'
require 'objectives'

require 'intel'
require 'warrior_actions'

require 'warrior_listens'
require 'warrior_looks'
require 'warrior_feels'

require 'debugging'


class Player

  attr_reader :warrior, :path_traveled, :possible_objectives, :possible_directions,
              :objectives, :warrior_heard, :warrior_saw, :warrior_felt, :look_for_direction,
              :total_enemies, :total_captives, :captives_in_range

  def initialize
    @possible_objectives ||= [:ticking_captive, :captive, :enemy_threat,:enemy_bound]
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
  end


  def play_turn(warrior)
    record_action

    @warrior = warrior
    @action = false



    reset_objectives
    create_objects

    warrior_listens
    warrior_looks
    warrior_feels

    build_objectives

    #debugging
    #what_warrior_hears
  
    
    warrior_walk(towards_stairs) if objectives_accomplished

       
    if nowhere_to_move

      rescue_captive if next_to_captive
      bind_enemies if multiple_enemies_near?
        
      blow_stuff_up(towards_objective)
    end
      

    if perfect_bomb_location

      warrior_rest if warrior_critical
      blow_stuff_up(look_for_direction)
    end

    if any_captives?

      rescue_captive if next_to_captive
      attack_enemy if next_to_last_enemy

    elsif warrior_wounded && safe_to_rest

      warrior_rest

    elsif warrior_critical && !one_enemy_left?

      warrior_walk(direction_to_retreat)
    end





    if danger_far

      walk_towards_objective if path_clear
      blow_stuff_up(towards_objective)
    end

    if danger_close

      blow_stuff_up(towards_objective) if multiple_enemies_near?
      attack_enemy
    end

    if bound_enemies?
      attack_enemy if bound_enemy_close
    end

    walk_towards_objective



    @warrior_health = warrior.health

    # print_log
  end
end
