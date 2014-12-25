
def captives_in_room?
  listen_for_intel.include?('Captive')
end

def towards_captive 
  direction = nil
  @warrior.listen.each do |square|

    next if square.to_s != 'Captive'

    if ticking_captives? #&& square.ticking?
      direction = @warrior.direction_of(square) if square.ticking?
    else 
      direction = @warrior.direction_of(square) if !ticking_captives?
    end
  end
  direction
end

def ticking_captives?
  bomb = false
  @warrior.listen.each do |square|
    bomb = true if square.ticking?
  end
  bomb
end

def rescue_captive
  @warrior.rescue!(towards_captive)
end

def found_a_captive
  @warrior.feel(towards_captive).captive?
end

def free_captives
  if found_a_captive
    rescue_captive
  else  
    walk_towards(:captive)
  end
end

def path_to_captives_blocked?
  multiple_enemies_ahead? && trapped?
end  



