
def closest_enemy
  @enemy_locations.first
end

def outnumbered?
  @enemies_near_warrior > 1
end

def attack_closest_enemy
  
  if next_to_warrior?(:enemy)
    @warrior.attack!(next_to_warrior?(:enemy))
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
