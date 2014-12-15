
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

def kill_bound_enemies
  if found_a_bound_enemy
    @warrior.attack!(@enemy_locations.first)
    @bound_enemies.shift
  else
    @warrior.walk!(@enemy_locations.first)
  end
end

def kill_enemies

  if multiple_enemies_ahead?
    @warrior.detonate!
  else
    @warrior.walk!(@enemy_locations.first)
  end
end

def number_of_enemies_ahead?
  enemies = 0
  @warrior.look.each do |space|
    enemies += 1 if space.enemy?
  end
  enemies
end

def multiple_enemies_ahead?
  squares = []
  @warrior.look.each do |square|
    squares << square
  end
  squares.each do |square|
    if squares[0].enemy? && squares[1].enemy?
      return true
    end
  end
  false
end
