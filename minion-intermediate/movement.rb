

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
  p 'in retreat to safety'
  @retreat = true
  direction_to_safety = retrace_footsteps(@path_traveled.last)
  @path_traveled << direction_to_safety
  @warrior.walk!(direction_to_safety)
end

def towards_stairs
  @warrior.direction_of_stairs
end

def path_clear?(direction)
  @warrior.feel(direction).empty?
end

def walk_towards(object)
  case object
  when :stairs
    if path_clear?(towards_stairs)
      @warrior.walk!(towards_stairs)
      @path_traveled << towards_stairs
    else
      @warrior.walk!(walk_around_object)
      @path_traveled << (walk_around_object)
    end
  when :captive 
    if path_clear?(towards_captive)
      @warrior.walk!(towards_captive)
      @path_traveled << towards_captive
    elsif trapped?
      if outnumbered?
        unless enemies_to_bind.empty?
          @warrior.bind!(enemies_to_bind.first)
          @bound_enemies << enemies_to_bind.first
        end
      else
        @warrior.attack!(towards_captive)
      end
    else
      @warrior.walk!(walk_around_object)
      @path_traveled << walk_around_object
    end
  else
    p 'walking in circles!'
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

def trapped?
  possible_directions.each do |direction|
    return false if @warrior.feel(direction).empty?
  end
  true
end

def enemies_to_bind
  @nearby_enemy_locations - [towards_captive] - @bound_enemies
end

