

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
  end
end

def walk_towards_stairs
  towards_stairs = @warrior.direction_of_stairs
  @path_traveled << towards_stairs
  @warrior.walk!(towards_stairs)
end

def retreat_to_safety
    direction_to_safety = retrace_footsteps(@path_traveled.last)
    @path_traveled << direction_to_safety
    @warrior.walk!(direction_to_safety)
end

def walk_towards_captive
  @path_traveled << direction_to_captive
  @warrior.walk!(direction_to_captive)
end

