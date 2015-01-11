
def warrior_feels
  #record_action
  @enemies_next_to_warrior = 0
  @total_empty_spaces = 0
  @possible_paths = []
  @direction_to_retreat = nil

  @safe_to_rest = false
  @nowhere_to_move == false

  possible_directions.each do |direction|
    empty_space = false

    square = warrior.feel(direction).to_s
    square = 'stairs' if warrior.feel(direction).stairs?
    empty_space = true if square.eql?('nothing')

    warrior_felt[direction] = square

    @enemies_next_to_warrior += 1 if warrior.feel(direction).enemy?
    @total_empty_spaces += 1 if empty_space
    @possible_paths << direction if empty_space
    @direction_to_retreat ||= direction if empty_space
  end

  @safe_to_rest = true if @enemies_next_to_warrior == 0
  #@nowhere_to_move == true if @total_empty_spaces == 0 # why?

  warrior_felt
end


def path_clear
  
  if warrior.feel(towards_objective).empty? && !warrior.feel(towards_objective).stairs?
    #record_action
    return true
  end
  false
end


def possible_paths_towards_objective
  @possible_paths - [previous_location]
end

def alternate_direction
  possible_paths_towards_objective.first
end

def path_totally_blocked
  alternate_direction.nil?
end


def safe_to_rest
  @safe_to_rest
end


def direction_to_retreat
  @direction_to_retreat
end


def count_enemies_in_range
  @enemies_next_to_warrior
end

def nowhere_to_move
  return false if @total_empty_spaces != 0
  record_action
  true
end

