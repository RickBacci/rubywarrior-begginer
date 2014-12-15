

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


def walk_towards_stairs
  towards_stairs = @warrior.direction_of_stairs
  if @everything_in_room.empty?
    p "everything should be empty!"
    @path_traveled << towards_stairs
    @warrior.walk!(towards_stairs)
  else
    p 'in walk towards stairs room not empty'
    new_direction = walk_around_stairs
    @path_traveled << new_direction
    @warrior.walk!(new_direction)
  end
end


def walk_towards_captive
  if @warrior.feel(direction_to_captive).stairs?
    @path_traveled << walk_around_object
    @warrior.walk!(walk_around_object)
  else
    @path_traveled << direction_to_captive
    @warrior.walk!(direction_to_captive)
  end
end

def walk_towards_ticking_captive
  if @warrior.feel(direction_to_captive).stairs?
    @path_traveled << walk_around_object#walk_around_stairs
    @warrior.walk!(walk_around_object)#(walk_around_stairs)
  elsif @warrior.feel(direction_to_captive).enemy?
    @path_traveled << (walk_around_object)#walk_around_enemy
    @warrior.walk!(walk_around_object)#(walk_around_enemy)
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
    next if @warrior.feel(direction).stairs?
    next if @warrior.feel(direction).enemy?
    next if @warrior.feel(direction).captive?
    next if @warrior.feel(direction).wall?
    next if direction == previous_location
  
    new_direction = direction
  end
  new_direction
end


# def walk_around_enemy
#   new_direction = nil
#   possible_directions.each do |direction|

#     if @warrior.feel(direction).empty?
#       if @path_traveled.length >= 1
#         new_direction = direction if direction != retrace_footsteps(@path_traveled.last)
#       else
#         new_direction = direction
#       end
#     end

#   end
#   new_direction
# end

# def walk_around_stairs
#   new_direction = nil
#   possible_directions.each do |direction|

#     if @warrior.feel(direction).empty? && !@warrior.feel(direction).stairs?
#       if @path_traveled.length > 1
#         new_direction = direction if direction != retrace_footsteps(@path_traveled.last)
#       else
#         new_direction = direction
#       end
#     end

#   end
#   new_direction
# end
