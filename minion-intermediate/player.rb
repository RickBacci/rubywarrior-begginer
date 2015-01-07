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
    #@objectives ||= []
    @objectives ||= []
    @stairs ||= false
    @warrior_health ||= 20
  end


  def play_turn(warrior)
  	@warrior = warrior

    #p @objectives

    def count_objects
      @warrior.listen.size
    end

    # p "There are #{count_objects} objects in the room"
    # p "Last turn there were #{@objectives.size} objectives"

    # this will need more logic when multiple enemies are killed.

    if count_objects < @objectives.size
      @warrior_hears = nil
      #@warrior_hears.shift
      #@objectives.shift
      @objectives = []
    end

    def create_objects
      @warrior_hears = []
      p "this only happens once !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      @warrior.listen.size.times do
        @warrior_hears << Space.new
      end
      @warrior_hears
    end
    create_objects if @warrior_hears.nil?

    puts
    warrior_feels # do not comment out!
    puts
    warrior_looks # do not comment out!
    puts
    warrior_listens# do not comment out!
   
    puts
    what_warrior_hears
    puts
    p "Direction to stairs: #{@warrior.direction_of_stairs}"
    puts

    # def nobody_in_sight
    #   warrior_listens.empty?
    # end

    

    
    

    def build_objectives
      
      @possible_objectives.each do |objective|
        @warrior_hears.each_with_index do |space, index|
        
          case objective

          when :ticking_captive
            if space.ticking && space.counted.nil?
              space.counted = true
              # @objectives << :ticking_captive 
              @objectives << space
            end
          when :captive
            if space.captive && space.counted.nil?
              space.counted = true
              # @objectives << :captive 
              @objectives << space

            end
          when :enemy_threat
            if space.enemy_threat && space.counted.nil?
              space.counted = true
              # @objectives << :enemy_threat 
              @objectives << space

            end
          when :enemy_bound
            # 
          # when :stairs
          #   @objectives << :stairs unless @stairs
          #   @stairs = true
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
      @objectives.empty?
    end

    p "remaining objectives"
    puts
    @objectives.each do |s|
      puts s.name
    end
    puts

    # p @total_objectives = @warrior_hears.length
    # p @warrior_feels.has_value?("wall")
    # p @warrior_hears[0].name
    # p @warrior_hears.each {|x| puts x}

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
      if @warrior.feel(towards_objective).empty? 
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
      case direction
      when :forward
        :backward
      when :backward
        :forward
      when :left
        :right
      when :right
        :left
      else
        nil
      end
    end


    def blow_stuff_up
      @warrior.detonate!(towards_objective)
    end

    def attack_enemy
      @warrior.attack!(towards_objective)
    end

    def warrior_critical
      @warrior_health <= 5
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
      @warrior_hears.each do |space|
        total_enemies += 1 if space.distance == 2 || space.distance == 1
      end
      # return true if total_enemies == 3
      return true if total_enemies > 1

      false
    end

    def look_for_direction
      @warrior_sees.each do |direction, squares|

        if squares[0][0] == 'Thick Sludge' || squares[0][0] == 'Sludge'
          return direction 
        elsif squares[1][0] == 'Thick Sludge' || squares[1][0] == 'Sludge'
          return direction
        end
      end
    end

    def count_enemies_in_range
      total_enemies = 0

      warrior_feels.each do |direction, space|
        total_enemies += 1 if space.eql?('Thick Sludge') || space.eql?('Sludge')
      end
      total_enemies
    end

    def any_captives?
      @warrior_hears.each { |square| return true if square.captive }
      false
    end
    # p @warrior_sees
    # p warrior_feels
    
    #p
    # count_enemies_in_range
    p next_objective.ticking unless next_objective.nil?
    #p @path_traveled
    #p warrior_feels
    p possible_paths_towards_objective
    #p next_objective.distance unless next_objective.nil?
   #p warrior_feels
   puts
    if objectives_accomplished
      walk_to_stairs
    elsif any_captives?
      if next_objective.ticking
        if next_to_captive
          rescue_captive
        else
          walk_towards_objective
        end
      elsif next_to_captive
        rescue_captive
      else
        walk_towards_objective
      end
    elsif three_front_war
      warrior_retreat

    elsif warrior_wounded && safe_to_rest
      warrior_rest
    elsif perfect_bomb_location
      @warrior.detonate!(look_for_direction)
    
    elsif warrior_critical
      warrior_retreat
    elsif danger_far
      if path_clear
        walk_towards_objective
      else
        blow_stuff_up
      end
    elsif danger_close
      if count_enemies_in_range > 1
        blow_stuff_up
      else
        attack_enemy
      end
    else
      walk_towards_objective
    end
      
    @warrior_health = warrior.health






























      # if @warrior.feel(towards_stairs).empty?
      #   @warrior.walk!(towards_stairs)

      # elsif @warrior_feels.has_value?("Sludge")
      #   @warrior.attack!(towards_stairs)
      # elsif nobody_in_sight
      #   @warrior.walk!(towards_stairs)
        
      # end






# listen_for_intel  # do not comment out!
    

   #  if previous_orders?
   #    enact_orders
   #  elsif next_to_warrior?(:enemy)
   #    engage_enemy
  	# elsif hit_points_needed?
   #    recover_from_battle
   #  elsif captives_in_room?
   #    free_captives
   #  elsif bound_enemy?
   #    kill_bound_enemies
   #  elsif enemies_in_room?
   #    kill_enemies
   #  elsif room_clear?
   #    #towards_stairs
   #    walk_towards(:stairs)
  	# else
   #    p 'Warrior doing nothing'
  	# end
  end
end
