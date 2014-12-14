
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
  @warrior.rescue!(direction_to_captive)
end



