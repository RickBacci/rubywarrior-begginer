
Feel = Struct.new(:name, :direction, :captive, :enemy, :bound_enemy, :stairs, :wall, :priority) do
         def initialize(priority: 5); self.priority = 5 ; end
       end

def warrior_feels
  @feels = []

  @possible_directions_to_objective = []
  @total_empty_spaces = 0
  @enemies_next_to_warrior = 0
  @multiple_enemies_next_to_warrior = 0
  @direction_to_retreat = nil

  possible_directions.each_with_index do |direction, index|

    @feels << Feel.new

         square = warrior.feel(direction)
        squares = @feels[index]
           name = square.to_s
    enemy_names = true if name == 'Sludge' || name == 'Thick Sludge'
    bound_enemy = true if enemy_names && square.captive?

             squares[:name] = square.to_s
        squares[:direction] = direction
          squares[:captive] = square.captive? && !enemy_names
            squares[:enemy] = square.enemy?
      squares[:bound_enemy] = bound_enemy
           squares[:stairs] = square.stairs?
             squares[:wall] = square.wall?

         squares[:priority] = 1 if square.captive? && !enemy_names
         squares[:priority] = 2 if square.enemy?
         squares[:priority] = 3 if bound_enemy
         squares[:priority] = 4 if square.stairs?

    empty_space = square.empty? && !square.stairs? 

    @possible_directions_to_objective << direction if empty_space
    @total_empty_spaces += 1 if empty_space
    @enemies_next_to_warrior += 1 if square.enemy?
    @multiple_enemies_next_to_warrior += 1 if square.enemy?
    @direction_to_retreat ||= direction if empty_space

    @nowhere_to_move = @total_empty_spaces != 0 ? false : true
    @safe_to_rest = @enemies_next_to_warrior != 0 ? false : true

  end
  @feels.sort! { |x, y| x.priority <=> y.priority }
end

def path_towards_objective_clear
  warrior.feel(towards_objective).empty? && !warrior.feel(towards_objective).stairs?
end


def alternate_direction
  (@possible_directions_to_objective - [previous_location]).first
end

def path_totally_blocked
  alternate_direction.nil?
end

def surrounded_on_three_sides?
  if @enemies_next_to_warrior == 3 && @total_empty_spaces != 0
    @path_blocked = true # this is to prevent warrior from walking forward the next turn
   
    warrior_walk(direction_to_retreat)
    return false
  end
end

def safe_to_rest
  @safe_to_rest
end

def direction_to_retreat
  @direction_to_retreat
end

def nowhere_to_move?
  @nowhere_to_move
end

def next_to_captive?
  feels.each do |space|
    return true if space.captive
  end
  false
end

def rescue_captive
  feels.each do |space|
    unbind_captive(space.direction) if space.captive
  end
end
