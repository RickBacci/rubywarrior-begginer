
def captives_in_room?
  listen_for_intel.include?('Captive')
end

def towards_captive
  #p 'in towards captive'
  @warrior.listen.each do |square|

    next if square.to_s != 'Captive'

    if ticking_captives?
      return @warrior.direction_of(square) if square.ticking?
    else 
      return @warrior.direction_of(square)
    end
  end
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
  #p 'in found a captive -------------------------'
  
  possible_directions.each do |direction|
    
    bound_enemy = @warrior.feel(direction).enemy?
    captive = @warrior.feel(direction).captive?
    ticking = @warrior.feel(direction).ticking?
   
    #p "direction to bound enemy #{bound_enemy}"
    if ticking_captives?
      if captive && ticking
        #p 'found ticking captive!'
        return true
      else
        return false
      end
    else 
      if captive && bound_enemy
        p 'found bound captive!'
        return true
      elsif captive && bound_enemy == false
        p 'found captive!'
        return true
      else
        p "no captive"
        false
        #return false needed for level 9?
      end
    end 
  end
  false # needed for no captives
end

def free_captives
  if found_a_captive
    rescue_captive
  else
    walk_towards(:captive)
  end
end
