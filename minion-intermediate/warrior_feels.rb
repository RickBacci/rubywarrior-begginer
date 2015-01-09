
def warrior_feels
  #record_action

  possible_directions.each do |direction|

    square = warrior.feel(direction).to_s
    square = 'stairs' if warrior.feel(direction).stairs?

    warrior_felt[direction] = square
  end
  warrior_felt
end


def path_clear
  
  if warrior.feel(towards_objective).empty? && !warrior.feel(towards_objective).stairs?
    record_action
    return true
  end
  false
end


def possible_paths_towards_objective
  record_action

  possible_directions = []
  warrior_felt.each do |direction, space|
    possible_directions << direction if space == 'nothing'
  end
  possible_directions - [previous_location]
end


def safe_to_rest

  if !warrior_felt.has_value?('Sludge') && !warrior_felt.has_value?('Thick Sludge')
    record_action
    return true
  end
  false
end


def direction_to_retreat
  
  warrior_felt.each do |direction, space|
    if space == 'nothing'
      record_action
      return direction
    end
  end
  nil
end


def three_front_war

  total_enemies2 = 0
  escape_route = false

  warrior_felt.each do |direction, space|
    total_enemies2 += 1 if space.eql?('Thick Sludge') || space.eql?('Sludge')
    escape_route = true if space.eql?('nothing')
  end

  if total_enemies2 == 3 && escape_route == true
    record_action
    return true
  end
  false
end


def count_enemies_in_range
  record_action

  total_enemies2 = 0

  warrior_felt.each do |direction, space|
    total_enemies2 += 1 if space.eql?('Thick Sludge') || space.eql?('Sludge')
  end
  total_enemies2
end


def nowhere_to_move
  spaces = 0
  warrior_felt.each do |direction, space|
    spaces += 1 if space == 'nothing'
  end
    if spaces == 0
      record_action
      return true
    end
  false
end
