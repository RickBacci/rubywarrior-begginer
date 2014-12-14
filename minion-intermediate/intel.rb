
def listen_for_intel
  @enemy_locations ||= []
  @captive_locations ||= []
  @everything_in_room ||= []

  squares = []
  @warrior.listen.each do |square|
    case square.to_s

    when 'Captive'
      @captive_locations << @warrior.direction_of(square)
    when 'Sludge'
      @enemy_locations << @warrior.direction_of(square)
    when 'Thick Sludge'
      @enemy_locations << @warrior.direction_of(square)
    else
      p 'in listen for intel'
    end
    squares << square.to_s
  end
  squares
end

def next_to_warrior?(object)
  possible_directions.each do |direction|
    case object
    when :captive
      return direction if @warrior.feel(direction).captive?
    when :enemy
      return direction if @warrior.feel(direction).enemy?
    when :stairs
      return direction if @warrior.feel(direction).stairs?
    else
      nil
    end
  end
end

def room_clear?
  listen_for_intel.empty?
end

def next_enemy?
    @warrior.listen.each do |square|
      return square.to_s unless square.to_s == 'Captive'
    end
  nil
end

def found_a_captive
  @warrior.feel(direction_to_captive).captive?
end

# def enemies_are_near?
#   enemy_locations = []

#     possible_directions.each do |direction|
#       enemy_locations << direction if @warrior.feel(direction).enemy?
#     end

#   return nil if enemy_locations.empty?
#   enemy_locations
# end

# def captive_near?
#   captive_direction = ''
#     possible_directions.each do |direction|
#       captive_direction = direction if @warrior.feel(direction).captive?
#     end
#   return nil if captive_direction == ''
#   captive_direction
# end



