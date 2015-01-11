Space = Struct.new(:name, :direction, :distance,
                   :ticking, :enemy_threat, :captive,
                   :enemy_bound, :enemy, :priority)


def next_objective
  objectives.first
end

def ticking_captives?
  next_objective.ticking unless next_objective.nil?
end

def towards_objective
  if objectives.empty? || objectives.nil?
    warrior.direction_of_stairs
  else
    objectives.first.direction
  end
end

def objectives_accomplished
  warrior.listen.empty?
end

