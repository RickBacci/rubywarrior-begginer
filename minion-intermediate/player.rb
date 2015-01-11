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

      rescue_captive if !action && next_to_captive # level 3
      bind_enemies if !action && multiple_enemies_next_to_warrior? # level 9
    end
      

    blow_stuff_up(look_for_direction) if !action && perfect_bomb_location 


    if any_captives?
      rescue_captive if !action && next_to_captive
    end


    warrior_rest if !action && warrior_should_rest?
      

    walk_towards_objective if !action
  

    attack_enemy if !action
  
    


    @warrior_health = warrior.health

    print_log
  end
end
