def gather_intel
  @enemy_locations = enemies_are_near?
  @captive_locations = captive_near?
  @everything_in_room = listen_for_intel
  @bound_enemies ||= []
end

def listen_for_intel
  squares = []
    @warrior.listen.each do |square|
      squares << square.to_s
    end
  squares
end

def enemies_are_near?
  enemy_locations = []

    possible_directions.each do |direction|
      enemy_locations << direction if @warrior.feel(direction).enemy?
    end

  return nil if enemy_locations.empty?
  enemy_locations
end

def captive_near?
  captive_direction = ''
    possible_directions.each do |direction|
      captive_direction = direction if @warrior.feel(direction).captive?
    end
  return nil if captive_direction == ''
  captive_direction
end

def room_clear?
  listen_for_intel.empty?
end

def next_enemy?
  squares = #[]
    @warrior.listen.each do |square|
      return square.to_s unless square.to_s == 'Captive'
      #squares << square.to_s
      #p @warrior.direction_of(square)
      #p "Move #{ @warrior.direction_of(square) } to find a #{square.to_s}"
    end
  squares
end


def found_a_captive
  @warrior.feel(direction_to_captive).captive?
end



