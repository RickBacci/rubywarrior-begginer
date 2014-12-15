def number_of_enemies_next_to_warrior
 # return 0 if @enemy_locations.empty?
 # @enemy_locations.size
   total = 0

  # possible_directions.each do |direction|
  #   total = 0
  #   if @warrior.feel(direction) == 'Sludge' || @warrior.feel(direction) == 'Thick Sludge'
  #     total += 1
  #   end
  #   total
  # end
  # total
end

def closest_enemy
  @enemy_locations.first
end

def outnumbered?
  number_of_enemies_next_to_warrior > 1
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
