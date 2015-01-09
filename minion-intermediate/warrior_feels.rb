
def warrior_feels
  record_action

  @warrior_feels = {}
  possible_directions.each do |direction|

    square = warrior.feel(direction).to_s
    square = 'stairs' if warrior.feel(direction).stairs?

    @warrior_feels[direction] = square
  end
  @warrior_feels
end


def path_clear
  record_action

  warrior.feel(towards_objective).empty? && 
  !warrior.feel(towards_objective).stairs?
end


def possible_paths_towards_objective
  record_action

  possible_directions = []
  @warrior_feels.each do |direction, space|
    possible_directions << direction if space == 'nothing'
  end
  possible_directions - [previous_location]
end


def safe_to_rest
  record_action

  !@warrior_feels.has_value?('Sludge') && 
  !@warrior_feels.has_value?('Thick Sludge')
end


def direction_to_retreat
  record_action

  @warrior_feels.each { |direction, space| return direction if space == 'nothing' }
  nil
end


def three_front_war
  record_action

  total_enemies = 0
  escape_route = false

  @warrior_feels.each do |direction, space|
    total_enemies += 1 if space.eql?('Thick Sludge') || space.eql?('Sludge')
    escape_route = true if space.eql?('nothing')
  end
  return true if total_enemies == 3 && escape_route == true
  false
end


def count_enemies_in_range
  record_action

  total_enemies = 0

  @warrior_feels.each do |direction, space|
    total_enemies += 1 if space.eql?('Thick Sludge') || space.eql?('Sludge')
  end
  total_enemies
end


def nowhere_to_move
  record_action

  @warrior_feels.each do |direction, space|
    return false if space == 'nothing'
  end
  true
end
