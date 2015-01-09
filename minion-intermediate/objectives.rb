
def reset_objectives
  if warrior.listen.size < objectives.size
    record_action
    @warrior_heard = nil # leave instance variable
    @objectives = []     # leave instance variable
  end
end

def build_objectives
  record_action

  possible_objectives.each do |objective|
    warrior_heard.each_with_index do |space, index|
    #warrior_listens.each_with_index do |space, index|

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
  #record_action

  objectives.first
end

def towards_objective
  #record_action

  objectives.first.direction
end

def objectives_accomplished
  record_action if warrior.listen.size == 0
  warrior.listen.size == 0
end

