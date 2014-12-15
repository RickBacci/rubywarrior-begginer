

def possible_directions
  [:forward, :backward, :left, :right]
end

def retrace_footsteps(direction)
  case direction
  when :forward
    :backward
  when :backward
    :forward
  when :left
    :right
  when :right
    :left
  else
    nil
  end
end

def retreat_to_safety
  direction_to_safety = retrace_footsteps(@path_traveled.last)
  @path_traveled << direction_to_safety
  @warrior.walk!(direction_to_safety)
end

def towards_stairs
  @warrior.direction_of_stairs
end

def walk_towards_stairs
  if room_clear?
    @warrior.walk!(towards_stairs)
    @path_traveled << towards_stairs
  else
    new_direction = walk_around_object
    @warrior.walk!(new_direction)
    @path_traveled << new_direction
  end
end

def walk_towards_captive
  if @warrior.feel(direction_to_captive).stairs?
    @path_traveled << walk_around_object
    @warrior.walk!(walk_around_object)
  elsif @warrior.feel(direction_to_captive).enemy?
    @path_traveled << (walk_around_object)
    @warrior.walk!(walk_around_object)
  else
    @path_traveled << direction_to_captive
    @warrior.walk!(direction_to_captive)
  end
end


def previous_location
  retrace_footsteps(@path_traveled.last)
end
 
def walk_around_object
  new_direction = nil

  possible_directions.each do |direction|
    next if direction == previous_location
    new_direction = direction if @warrior.feel(direction).empty?
  end
  new_direction
end

