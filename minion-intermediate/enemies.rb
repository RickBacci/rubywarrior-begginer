def number_of_enemies
  #return 0 if @enemy_locations.nil?
  #@enemy_locations.size
  total = 0
  @warrior.listen.each do |square|
    next if square.to_s != 'Sludge'
    next if square.to_s != 'Thick Sludge'

    possible_directions.each do |direction|
      if @warrior.feel(direction) == 'Sludge' || @warrior.feel(direction) == 'Thick Sludge'
        total += 1
      end
    end
  end
  total
end

# def captives_in_room?
#   listen_for_intel.include?('Captive')
# end

def closest_enemy
  @enemy_locations.first
end

def outnumbered?
  number_of_enemies > 1
end

def attack_closest_enemy
  
  if next_to_warrior?(:enemy)
    #@warrior.attack!(closest_enemy)
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
