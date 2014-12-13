def number_of_enemies
  return 0 if @enemy_locations.nil?
  @enemy_locations.size
end

def closest_enemy
  @enemy_locations[0]
end

def outnumbered?
  number_of_enemies > 1
end

def attack_closest_enemy
  @warrior.attack!(closest_enemy)
end

def no_enemies_found
  @enemy_locations.nil?
end

def bind_closest_enemy
  @warrior.bind!(closest_enemy)
end
