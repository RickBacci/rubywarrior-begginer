
def towards_stairs
  warrior.direction_of_stairs
end

def walk_towards_stairs
  warrior_walk(towards_stairs)
end

def retrace_footsteps(direction)

   return :forward if direction == :backward
  return :backward if direction == :forward
      return :left if direction == :right
     return :right if direction == :left
  nil
end

def previous_location
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
  if warrior.health < 13
    record_action 
    return true
  end
  false
end

def wounded_with_no_captives?
  warrior_wounded && !any_captives? && safe_to_rest
end

def close_to_death? # don't bother if no enemies left
  warrior_critical && any_enemies_left? && safe_to_rest
end
