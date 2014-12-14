def number_of_enemies
  return 0 if @enemy_locations.nil?
  @enemy_locations.size
end

def closest_enemy
  @enemy_locations.first
end

def outnumbered?
  number_of_enemies > 1
end

def attack_closest_enemy
  
  if enemies_are_near?
    @warrior.attack!(closest_enemy)
  elsif @bound_enemies.length >= 1
    @warrior.attack!(@bound_enemies.first)
  else
    p 'Why are you here?'
  end
end

def no_enemies_found
  @enemy_locations.nil?
end

def bind_closest_enemy
  @bound_enemies << closest_enemy
  @warrior.bind!(closest_enemy)
end
