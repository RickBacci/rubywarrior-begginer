def closest_captive
  @captive_locations[0]
end

def rescue_closest_captive
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
    next if square.to_s != 'Captive'
    if ticking_captives? && square.ticking?
      direction = @warrior.direction_of(square)
    else 
      direction = @warrior.direction_of(square)# square.to_s == 'Captive'
    end
  end
  direction
end

# def direction_to_ticking_captive
#   direction = ''
#   @warrior.listen.each do |square|
#     if square.ticking? && square.to_s == 'Captive'
#       direction = @warrior.direction_of(square) 
#     end
#   end
#   direction
# end

def ticking_captives?
  bomb = false
  @warrior.listen.each do |square|
    bomb = true if square.ticking?
  end
  bomb
end


