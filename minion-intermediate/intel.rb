
def towards_stairs
  record_action

  warrior.direction_of_stairs
end


def danger_close

  return false if next_objective.nil?

  if next_objective.enemy_threat && next_objective.distance == 1
    return true
    record_action
  end
  false
end


def next_to_captive
  
  if next_objective.captive && next_objective.distance == 1
    record_action
    return true
  end
  false
end


def danger_far

  return false if next_objective.nil?

  if next_objective.enemy_threat && next_objective.distance > 1
    record_action
    return true
  end
end
    

def retrace_footsteps(direction)
  #record_action

  return :forward if direction == :backward
  return :backward if direction == :forward
  return :left if direction == :right
  return :right if direction == :left
  nil
end

def initial_location
  record_action
  retrace_footsteps(path_traveled.first)
end

def previous_location
  record_action

  retrace_footsteps(path_traveled.last)
end


def warrior_critical
  if warrior.health <= 4
    record_action 
    return true
  end
  false
end


def warrior_wounded
  if warrior.health < 14
    record_action 
    return true
  end
  false
end


def bound_enemy_close

  return false if next_objective.nil?

  if (next_objective.enemy && next_objective.captive) && next_objective.distance == 1
    record_action
    return true
  end
end


def warrior_should_rest?
  (warrior_wounded && safe_to_rest) && !any_captives?
end
