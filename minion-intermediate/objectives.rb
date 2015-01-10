
def reset_objectives

  if warrior.listen.size < objectives.size
    record_action
    @warrior_heard = nil # leave instance variable
    @objectives = []     # leave instance variable
   
    @path_blocked = false
   
  end
end

def build_objectives
  #record_action

  possible_objectives.each do |objective|
    warrior_heard.each_with_index do |space, index|

      case objective

      when :ticking_captive
        if space.ticking && space.counted.nil?
          space.counted = true
          objectives << space
        end
      when :captive
        if (space.captive && space.counted.nil?) && !space.enemy
          space.counted = true
          objectives << space
        end
      when :enemy_threat
        if space.enemy_threat && space.counted.nil?
          space.counted = true
          objectives << space
        end
      when :enemy_bound
        if (space.captive && space.counted.nil?) && space.enemy
          space.counted = true
          objectives << space
        end
      else
      p 'Error in build_objectives!'
    end
  end
end
objectives
end

def next_objective
  objectives.first
end

def ticking_captives?
  next_objective.ticking
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

