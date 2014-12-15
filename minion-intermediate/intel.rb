
def listen_for_intel # finds everything in room
  @enemy_locations = []
  @captive_locations = []
  @enemies_near_warrior = 0
  @nearby_enemy_locations = []


  squares = []
  @warrior.listen.each do |square|
    direction = @warrior.direction_of(square)
    enemy = @warrior.feel(direction).enemy?

    case square.to_s

    when 'Captive'
      @captive_locations << direction
    when 'Sludge'
      @enemy_locations << direction  
      record_nearby_enemy_intel(direction) if enemy
    when 'Thick Sludge'
      @enemy_locations << direction
      record_nearby_enemy_intel(direction) if enemy
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
      p 'error'
    end
  end
  nil
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

def record_nearby_enemy_intel(direction)
  @enemies_near_warrior += 1
  @nearby_enemy_locations << direction
end
