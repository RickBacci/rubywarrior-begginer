
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

def continue_bombing?
  direction = nil
  if @path_traveled.empty?
    direction = :forward
  else
    direction = retrace_footsteps(@path_traveled.last)
  end
  #p "direction in continue_bombing #{direction}"

  spaces = []
  @warrior.look(direction).each do |space|
    spaces << space.enemy?
  end
  if spaces[0] == true || spaces[1] == true
    return true
  end
  false
end

def surrounded? ## this is wrong too!!!!
  (@direction_of_enemies_in_attack_range == [:forward, :left, :right]) && @path_traveled.empty?
end

def previous_orders?
  !@queue.empty?
end

def enact_orders
  # bombing directions will only pass
  # for specific cases in this level
  # needs more intelligence.

  if severely_wounded?
    rest_or_flee?
  elsif continue_bombing?
    action = @queue.shift
    if action == :bomb
      if captives_in_room?
        @warrior.detonate!(towards_captive)
      else
        @warrior.detonate!(towards_stairs)
      end
    else
      p 'error in queue.'
    end
  else
    #p 'in enact orders -----------------------------------'
    @queue = []
    #@warrior.walk!
    #@path_traveled << :forward
  end
end

def warrior_feels
  #@warrior_feels = {forward: '', right: '', backward: '', left: ''}
  @warrior_feels = {}
  possible_directions.each do |direction|

    square = @warrior.feel(direction).to_s
    if square == 'nothing'
      square = 'stairs' if @warrior.feel(direction).stairs?
    end
    @warrior_feels[direction] = square
  end
  @warrior_feels
end

def warrior_looks
  @warrior_sees = {}
 
  #p 'look for intel 2'
  possible_directions.each do |direction|

    squares = []
    @warrior.look(direction).each do |square|
      distance = @warrior.distance_of(square)
      squares << [square.to_s, distance]
    end

    @warrior_sees[direction] = squares
  end
  @warrior_sees
end

def warrior_listens # updates values of everything in room
  p 'in here at start of every turn...................................'
  @warrior.listen.each_with_index do |square, index|
  space = @warrior_hears[index]
  name = square.to_s

  # next if space.nil? 

          space[:name] = square.to_s
     space[:direction] = @warrior.direction_of(square)
      space[:distance] = @warrior.distance_of(square)
       space[:ticking] = square.ticking?
         space[:enemy] = true if name == 'Sludge' || name == 'Thick Sludge'
       space[:captive] = square.captive? ? true : false
    #if space[:enemy_threat].nil?
       space[:enemy_bound] = ((space[:enemy] && space[:captive]) ? true : false) 
    #end
    #if space[:enemy_threat].nil?
      space[:enemy_threat] = square.enemy?
   # end
  end
  #p @warrior_hears.each { |v| puts "Name: #{v.name} counted: #{v.counted}" }
  @warrior_hears
end
