require 'health'
require 'enemies'
require 'captives'
require 'intel'
require 'movement'
require 'debugging'
require 'space'

Space = Struct.new(:name, :direction, :distance,
                   :ticking, :enemy_threat, :captive,
                   :enemy_bound, :enemy, :counted)

class Player

  def initialize
    @path_traveled ||= []
    @bound_enemies ||= []
    @queue ||= []
    @blocked = false if @blocked.nil?
    @possible_objectives ||= [:ticking_captive, :captive,
                            :enemy_threat,:enemy_bound]#,
                            #:stairs]
    @objectives ||= []
    @stairs ||= false
    @warrior_health ||= 20
  end


  def play_turn(warrior)
  	@warrior = warrior


    def count_objects
      @warrior.listen.size
    end

    # p "There are #{count_objects} objects in the room"
    # p "Last turn there were #{@objectives.size} objectives"
   
    if count_objects < @objectives.size
      @warrior_hears = nil
      @objectives = []
    end

    def create_objects
      p "this only happens when new objects generated !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      @warrior_hears = []
      @warrior.listen.size.times do
        @warrior_hears << Space.new
      end
      @warrior_hears
    end

    create_objects if @warrior_hears.nil?

    warrior_feels       # do not comment out!
    warrior_looks       # do not comment out!
    warrior_listens     # do not comment out!
    # puts
    what_warrior_hears
    # puts

    def build_objectives
      
      @possible_objectives.each do |objective|
        @warrior_hears.each_with_index do |space, index|
        
          case objective

          when :ticking_captive
            if space.ticking && space.counted.nil?
              space.counted = true
              @objectives << space
            end
          when :captive
            if (space.captive && space.counted.nil?) && !space.enemy
              space.counted = true
              @objectives << space
            end
          when :enemy_threat
            if space.enemy_threat && space.counted.nil?
              space.counted = true
              @objectives << space
            end
          when :enemy_bound
            if (space.captive && space.counted.nil?) && space.enemy
              space.counted = true
              @objectives << space
            end
          when :stairs # not sure if this is doing anything
            @objectives << :stairs unless @stairs
            @stairs = true
          else
            p 'Error in build_objectives!'
          end
        end
      end
      @objectives
    end

    build_objectives if @objectives.empty?




    def towards_stairs
      @warrior.direction_of_stairs
    end

    def next_objective
      @objectives.first
    end

    def objectives_accomplished
      count_objects == 0
    end

    def towards_objective
      next_objective.direction
    end

    def danger_close
      next_objective.enemy_threat && next_objective.distance == 1
    end

    def walk_to_stairs
      @warrior.walk!(towards_stairs)
    end

    def next_to_captive
      next_objective.captive && next_objective.distance == 1
    end

    def rescue_captive
      @warrior.rescue!(towards_objective)
    end

    def danger_far
      next_objective.enemy_threat && next_objective.distance > 1
    end

    def path_clear
      @warrior.feel(towards_objective).empty?
    end

    def walk_towards_objective

      #p 'in walk towards objective'
      if @warrior.feel(towards_objective).empty? && !@warrior.feel(towards_objective).stairs?
        @warrior.walk!(towards_objective)
        @path_traveled << towards_objective
      else # something blocking path
        @warrior.walk!(possible_paths_towards_objective.first)
        @path_traveled << possible_paths_towards_objective.first
      end
    end

    def possible_paths_towards_objective
      possible_directions = []
      warrior_feels.each do |direction, space|
        possible_directions << direction if space == 'nothing'
      end
      possible_directions - [previous_location]
    end

    def previous_location
      retrace_footsteps(@path_traveled.last)
    end

    def retrace_footsteps(direction)
      return :forward if direction == :backward
      return :backward if direction == :forward
      return :left if direction == :right
      return :right if direction == :left
      nil
    end


    def blow_stuff_up
      @warrior.detonate!(towards_objective)
    end

    def attack_enemy
      @warrior.attack!(towards_objective)
    end

    def warrior_critical
      @warrior.health <= 4
    end

    def warrior_wounded
      @warrior.health < 13
    end

    def warrior_rest
      @warrior.rest!
    end

    def safe_to_rest
      !warrior_feels.has_value?('Sludge') && 
      !warrior_feels.has_value?('Thick Sludge')
    end

    def direction_to_retreat
      warrior_feels.each { |direction, space| return direction if space == 'nothing' }
      nil
    end

    def warrior_retreat
      @warrior.walk!(direction_to_retreat)
      @path_traveled << direction_to_retreat
    end

    def three_front_war
      total_enemies = 0
      escape_route = false

      warrior_feels.each do |direction, space|
        total_enemies += 1 if space.eql?('Thick Sludge') || space.eql?('Sludge')
        escape_route = true if space.eql?('nothing')
      end
      return true if total_enemies == 3 && escape_route == true
      false
    end

    def perfect_bomb_location
      total_enemies = 0
      captives_near = false
      @warrior_hears.each do |space|
        if space.enemy_threat
          total_enemies += 1 if space.distance == 2 || space.distance == 1
        end
        captives_near = true if (space.captive && space.distance <=2) && !space.enemy
      end
      return true if total_enemies > 1 && captives_near == false

      false
    end

    def look_for_direction
      @warrior_sees.each do |direction, squares|

        if squares[0][0] == 'Thick Sludge' || squares[0][0] == 'Sludge'
          return direction 
        elsif squares[1][0] == 'Thick Sludge' || squares[1][0] == 'Sludge'
          return direction
        else
          p 'error in look_for_direction'
        end
      end
      towards_objective
    end

    def count_enemies_in_range
      total_enemies = 0

      warrior_feels.each do |direction, space|
        total_enemies += 1 if space.eql?('Thick Sludge') || space.eql?('Sludge')
      end
      
      total_enemies
    end

    def any_captives?
      @warrior_hears.each { |square| return true if (square.captive && !square.enemy) }
      false
    end

    def nowhere_to_move
      warrior_feels.each do |direction, space|
        return false if space == 'nothing'
      end
      true
    end


    def bind_enemies
      action = false
      @warrior_hears.each do |space|
        if (space.enemy_threat && (space.direction != towards_objective)) && space.distance == 1
          unless action
            @warrior.bind!(space.direction)
            space.enemy_threat = false
            space.enemy_bound = true
            action = true
          end
        end
      end
    end


    def multiple_enemies_near?
      total_enemies = 0

      @warrior_hears.each do |space|
        next if space.distance != 1
        total_enemies += 1 if space.enemy_threat
      end
      return true if total_enemies > 1
      false
    end

    def bound_enemies?
      @warrior_hears.each { |square| return true if (square.captive && square.enemy) }
      false
    end

    def bound_enemy_close
      unless next_objective.nil?
        (next_objective.enemy && next_objective.captive) && next_objective.distance == 1
      end
    end

    def one_enemy_left?
      total_enemies = 0
      @warrior_hears.each do |space|
        total_enemies += 1 if space.enemy
      end
      return true if total_enemies == 1
      false
    end
 

    if objectives_accomplished
      walk_to_stairs
    elsif nowhere_to_move
      if next_to_captive
        rescue_captive
      elsif multiple_enemies_near?
        bind_enemies
      else
        blow_stuff_up
      end
    elsif three_front_war
      warrior_retreat
    elsif perfect_bomb_location
      if warrior_critical
        warrior_rest
      else
        @warrior.detonate!(look_for_direction)
      end
    elsif any_captives?
      if next_objective.ticking
        if next_to_captive
          rescue_captive
        else
          walk_towards_objective
        end
      elsif next_to_captive
        rescue_captive
      elsif one_enemy_left? && count_enemies_in_range == 1
        attack_enemy
      else
        walk_towards_objective
      end
    elsif warrior_wounded && safe_to_rest
      warrior_rest
    elsif warrior_critical && !one_enemy_left?
      warrior_retreat
    elsif danger_far
      if path_clear
        walk_towards_objective
      else
        blow_stuff_up
      end
    elsif danger_close
      if multiple_enemies_near?
        blow_stuff_up
      else
        attack_enemy
      end
    elsif bound_enemies?
      if bound_enemy_close
        attack_enemy
      else
        walk_towards_objective
      end
    else
      walk_towards_objective
    end
    @warrior_health = warrior.health
  end
end
