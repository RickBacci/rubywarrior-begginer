
def captives_in_room?
  listen_for_intel.include?('Captive')
end

def towards_captive
    direction = nil
  @warrior.listen.each do |square|

    next if square.to_s != 'Captive'

    if ticking_captives?
      direction = @warrior.direction_of(square) if square.ticking?
    else 
      direction = @warrior.direction_of(square)
    end
  end
  p direction
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

def found_a_captive ### make feel_for_intel?

  possible_directions.each do |direction|

    captive = @warrior.feel(direction).captive?
    ticking = @warrior.feel(direction).ticking?

    if ticking_captives?
      return true if captive && ticking
    else 
      return true if captive
    end 
    return false   
  end
end

def free_captives
  if found_a_captive
    rescue_captive
  else
    walk_towards(:captive)
  end
end
