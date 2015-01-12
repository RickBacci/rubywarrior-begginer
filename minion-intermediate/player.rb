require 'objectives'

require 'intel'
require 'warrior_actions'

require 'warrior_listens'
require 'warrior_looks'
require 'warrior_feels'

require 'debugging'


class Player

  attr_reader :warrior, :possible_directions, :path_traveled, :action,
              :objectives, :look_for_direction, :looks, :feels

  def initialize
    @possible_directions = [:forward, :right, :backward, :left]
    @path_traveled ||= []
    @ok = true
  end


  def play_turn(warrior)
    @warrior = warrior

    record_action

    reset_variables # @action and @path_blocked

    warrior_listens
    warrior_looks
    warrior_feels

    #debugging
  
 

    walk_towards_stairs if objectives_accomplished?
           
    rescue_captive if next_to_captive?
   
    bind_enemies if nowhere_to_move?

    warrior_rest if close_to_death?
                                            
    bomb_enemies if warrior_should_stay_and_bomb? || perfect_bombing_location?

    warrior_rest if wounded_with_no_captives?
      
    walk_towards_objective
  
    attack_any_remaining_enemy
  

    print_log
  end
end
