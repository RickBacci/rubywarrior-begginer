
def closest_enemy
  @enemy_locations.first
end

def outnumbered?
  @enemies_near_warrior > 1
end

def enemy
  next_to_warrior?(:enemy)
end

def enemy?
  next_to_warrior?(:enemy)
end

def attack_closest_enemy
  
  if enemy?
    @warrior.attack!(enemy)
  elsif bound_enemy?
    @warrior.attack!(bound_enemy)
  else
    p 'Why are you here?'
  end
end

def no_enemies_found
  @enemy_locations.nil?
end

def bound_enemy
  @bound_enemies.first
end

def bound_enemy?
  @bound_enemies.length >= 1
end

def bind_closest_enemy
  @warrior.bind!(closest_enemy)
  @bound_enemies << closest_enemy
end

def found_a_bound_enemy
  @warrior.feel(@enemy_locations.first).captive?
end

def enemies_in_room?
  @enemy_locations.first
end
