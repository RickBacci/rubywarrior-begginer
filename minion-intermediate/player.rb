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
  end


  def play_turn(warrior)
  	@warrior = warrior

    def count_objects
      @warrior.listen.size
    end

    # p "There are #{count_objects} objects in the room"
    # p "Last turn there were #{@objectives.size} objectives"

    # this will need more logic when multiple enemies are killed.

    if count_objects < @objectives.size
      @warrior_hears.shift
      @objectives.shift
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

    def nobody_in_sight
      warrior_listens.empty?
    end

    def towards_stairs
      @warrior.direction_of_stairs
    end

    def next_objective
      @objectives.first
    end


    
    

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


   
    if @objectives.empty?
      @warrior.walk!(towards_stairs)
    

    else

    end
      
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
