
def warrior_walk(direction)
  if @action == false
    record_action
    warrior.walk!(direction) 
  
    path_traveled << direction
  end
  @action = true
end

def rescue_captive
  if @action == false
    record_action
    warrior.rescue!(towards_objective)
  end 
  @action = true
end

def blow_stuff_up(direction)
  if @action == false
    record_action
    warrior.detonate!(direction)
  end
  @action = true
end

def attack_enemy
  if @action == false
    record_action
    warrior.attack!(towards_objective)
  end
  @action = true
end

def warrior_rest
  if @action == false
    record_action
    warrior.rest!
  end
  @action = true
end

def bind_enemy(direction)
  if @action == false
    record_action
    warrior.bind!(direction)
  end 
  @action = true
end

def walk_towards_objective
  record_action

  if path_clear
    warrior_walk(towards_objective)
  else

    if path_totally_blocked
      blow_stuff_up(towards_objective) # this is for level 8
    else
      warrior_walk(alternate_direction)
    end
  end
end


