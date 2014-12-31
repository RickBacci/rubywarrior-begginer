
def captives_in_room?
  listen_for_intel.include?('Captive')
end

def towards_captive # direction set either way
  p 'towards captive needs fixed!!!!'
  direction = :right
  #direction = :problem_in_towards_captive
  @warrior.listen.each do |square|

    next if square.to_s != 'Captive'

    if ticking_captives?
      direction = @warrior.direction_of(square) if square.ticking?
    else 
      #p "towards captive not ticking !!!!!!!!!!!!!!!!!!!!!!!"
      #p square.to_s
      direction = @warrior.direction_of(square)
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
  #p 'in rescue captive!!!!!!!'
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
