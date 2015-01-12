
def warrior_walk(direction)

  if !action
    record_action
    warrior.walk!(direction)
    @action = true
    path_traveled << direction
  end
end

def unbind_captive(direction)

  if !action
    record_action
    warrior.rescue!(direction)
    @action = true
  end 
end

def blow_stuff_up(direction)

  if !action
    record_action
    warrior.detonate!(direction)
    @action = true
  end
end

def attack_any_remaining_enemy

  if !action
    record_action
    warrior.attack!(towards_objective)
    @action = true
  end
end

def warrior_rest

  if !action
    record_action
    warrior.rest!
    @action = true
  end
end


def bind_enemy(direction)

  if !action
    record_action
    warrior.bind!(direction)
    @action = true
  end 
end

def bind_enemies
  
  objectives.each do |space|
    next if space.distance != 1

    if space.enemy_threat && (space.direction != towards_objective)

      unless action # one action per turn
        bind_enemy(space.direction)
        space.enemy_threat = false
        space.enemy_bound = true
      end
    end
  end
end

def walk_towards_objective
  record_action

  if path_towards_objective_clear
    warrior_walk(towards_objective)  
  elsif next_to_next_objective
    # don't bump into it like a dumb warrior would
  else
    warrior_walk(alternate_direction)
  end
end
