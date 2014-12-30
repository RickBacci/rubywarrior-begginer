
def listen_for_intel # finds everything in room
  @directions_to_all_enemies = []
  @direction_to_captive_locations = []
 
  squares = []
  @warrior.listen.each do |square|
    direction = @warrior.direction_of(square)

    case square.to_s

    when 'Captive'
      @direction_to_captive_locations << direction
    when 'Sludge'
      @directions_to_all_enemies << direction  
    when 'Thick Sludge'
      @directions_to_all_enemies << direction
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
  @total_enemies_in_attack_range += 1
  @direction_of_enemies_in_attack_range << direction
end


def look_for_intel
  @total_enemies_in_attack_range = 0
  @direction_of_enemies_in_attack_range = []
  @captive_in_danger = false


  possible_directions.each do |direction|
    enemy = @warrior.feel(direction).enemy?
    record_nearby_enemy_intel(direction) if enemy
    @warrior.look(direction).each do |square|
      @captive_in_danger = true if square.captive?
    end
    
  end
  @direction_of_enemies_in_attack_range
end



def how_far_to(subject) # should not count enemy captives

  distance = 0
  @warrior.listen.each do |space|
    if space.to_s == subject
      distance = @warrior.distance_of(space)
      #p "The #{space.to_s} is #{distance} spaces away."
      return distance
    end
  end
  distance
end 


def continue_bombing?
  spaces = []
  @warrior.look.each do |space|
    spaces << space.enemy?
  end
  if spaces[0] == true || spaces[1] == true
    return true
  end
  false
end

def surrounded?
  (@direction_of_enemies_in_attack_range == [:forward, :left, :right]) && @path_traveled.empty?
end

def previous_orders?
  !@queue.empty?
end

def enact_orders
  if continue_bombing?
    action = @queue.shift
    if action == :bomb
      @warrior.detonate!
    else
      p 'error in queue.'
    end
  else
    @queue = []
    @warrior.walk!
    @path_traveled << :forward
  end
end


