
def warrior_walk(direction)
  if !action
    record_action
    warrior.walk!(direction) 
  
    path_traveled << direction
  end
  @action = true
end

def rescue_captive
  if !action
    record_action
    warrior.rescue!(towards_objective)
  end 
  @action = true
end

def blow_stuff_up(direction)
  if !action
    record_action
    warrior_rest if !action && (warrior_critical && safe_to_rest)

    warrior.detonate!(direction) if !action
  end
  @action = true
end

def attack_enemy
  if !action
    record_action
    #warrior_rest if !action && (warrior_critical && safe_to_rest)

    warrior.attack!(towards_objective) if !action
  end
  @action = true
end

def warrior_rest
  if !action
    record_action
    warrior.rest!
  end
  @action = true
end


def bind_enemy(direction)
  if !action
    record_action
    warrior.bind!(direction)
  end 
  @action = true
end


def bind_enemies
  
  action = false
  warrior_heard.each do |space|
    next if space.distance != 1

    if space.enemy_threat && (space.direction != towards_objective)

      unless action # one action per turn
        record_action
        bind_enemy(space.direction)
        space.enemy_threat = false
        space.enemy_bound = true
        action = true
      end
    end
  end
end


def walk_towards_objective
  record_action

  if path_clear
    warrior_walk(towards_objective)
  elsif path_totally_blocked
    blow_stuff_up(towards_objective) # this is for level 8
  elsif next_objective.distance == 1
    # don't walk
  else
    warrior_walk(alternate_direction)
  end
end


