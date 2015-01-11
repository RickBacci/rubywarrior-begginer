Space = Struct.new(:name, :direction, :distance,
                   :ticking, :enemy_threat, :captive,
                   :enemy_bound, :enemy, :priority)


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

def objectives_accomplished
  objectives.empty?
end

