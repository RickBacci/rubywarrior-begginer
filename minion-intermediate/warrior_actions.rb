
def warrior_walk(direction)
  record_action

  @warrior.walk!(direction)
  @path_traveled << direction
end

def rescue_captive
  record_action

  @warrior.rescue!(towards_objective)
end

def blow_stuff_up(direction)
  record_action

  @warrior.detonate!(direction)
end

def attack_enemy
  record_action

  @warrior.attack!(towards_objective)
end

def warrior_rest
  record_action

  @warrior.rest!
end

def bind_enemy(direction)
  record_action

  @warrior.bind!(direction)
end

def walk_towards_objective
  record_action

  if path_clear
    direction = towards_objective
    warrior_walk(direction)
  else
    direction = possible_paths_towards_objective.first
    warrior_walk(direction)
  end
end


