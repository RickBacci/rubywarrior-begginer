
# def possible_directions
#   record_action

#   [:forward, :right, :backward, :left]
# end


def towards_stairs
  record_action

  @warrior.direction_of_stairs
end


def danger_close
  record_action

  next_objective.enemy_threat && next_objective.distance == 1
end


def next_to_captive
  record_action

  next_objective.captive && next_objective.distance == 1
end


def danger_far
  record_action

  next_objective.enemy_threat && next_objective.distance > 1
end
    

def retrace_footsteps(direction)
  record_action

  return :forward if direction == :backward
  return :backward if direction == :forward
  return :left if direction == :right
  return :right if direction == :left
  nil
end


def previous_location
  record_action

  retrace_footsteps(@path_traveled.last)
end


def warrior_critical
  record_action

  @warrior.health <= 4
end


def warrior_wounded
  record_action

  @warrior.health < 13
end


def bound_enemy_close
  record_action

  unless next_objective.nil?
    (next_objective.enemy && next_objective.captive) && next_objective.distance == 1
  end
end
