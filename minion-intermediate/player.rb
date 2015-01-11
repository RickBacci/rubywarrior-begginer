require 'objectives'

require 'intel'
require 'warrior_actions'

require 'warrior_listens'
require 'warrior_looks'
require 'warrior_feels'

require 'debugging'


class Player

  attr_reader :warrior, :path_traveled, :possible_directions,
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
    @path_blocked == false

    @objectives = warrior_listens

    warrior_looks
    warrior_feels

    #debugging

    
    warrior_walk(towards_stairs) if objectives_accomplished
    #walk_towards_objective if next_objective.priority == 1 && ((@action == false) && path_clear)

       
    if (@action == false) && nowhere_to_move

      rescue_captive if (@action == false) && next_to_captive
      bind_enemies if (@action == false) && multiple_enemies_near?
        
      blow_stuff_up(towards_objective) if (@action == false)
    end
      

    if (@action == false) && perfect_bomb_location 

      warrior_rest if (@action == false) && warrior_critical
      blow_stuff_up(look_for_direction) if (@action == false) && !look_for_direction.nil?
      #blow_stuff_up(initial_location)
    end

     
    if (@action == false) && any_captives?
      rescue_captive if (@action == false) && next_to_captive
      attack_enemy if (@action == false) && next_to_last_enemy
    end

    if (@action == false) && ((warrior_wounded && safe_to_rest) && !any_captives?)
      warrior_rest
    end


    if (@action == false) && danger_far

      walk_towards_objective if (@action == false) && path_clear
      blow_stuff_up(towards_objective) if (@action == false)
    end


    if (@action == false) && danger_close

      blow_stuff_up(towards_objective) if (@action == false) && multiple_enemies_near?
      attack_enemy if (@action == false)
    end


    if (@action == false) && bound_enemies?
      warrior_rest if (@action == false) && warrior_critical


      #blow_stuff_up(initial_location) if multiple_bound_enemies_in_range? && (!multiple_enemies_near? && !any_captives?)
      #warrior_walk(initial_location) if !initial_location.nil? && !any_captives?
      attack_enemy if (@action == false) && bound_enemy_close
    end


    walk_towards_objective if (@action == false)

    @warrior_health = warrior.health

     print_log
  end
end
