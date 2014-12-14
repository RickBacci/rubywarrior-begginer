def closest_captive
  @captive_locations[0]
end

def rescue_closest_captive
  p 'stuck in here?'
  if @bound_enemies.empty?
    @warrior.rescue!(closest_captive) 
  else
    bound_enemy = @bound_enemies.shift
    @warrior.attack!(bound_enemy)

  end
end

def captives_in_room?
  listen_for_intel.include?('Captive')
end

def direction_to_captive
  direction = ''
  @warrior.listen.each do |square|
    #direction = square.to_s
    direction = @warrior.direction_of(square) if square.to_s == 'Captive'
  end
  direction
end



