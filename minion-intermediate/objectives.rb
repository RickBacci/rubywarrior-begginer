
def reset_variables
  @action = false
  @path_blocked == false
end

def next_objective
  objectives.first
end

def ticking_captives?
  next_objective.ticking
end

def towards_objective
  if objectives.empty?
    warrior.direction_of_stairs
  else
    next_objective.direction
  end
end

def objectives_accomplished?
  objectives.empty?
end

def next_to_next_objective
  !next_objective.nil? && next_objective.distance == 1
end
