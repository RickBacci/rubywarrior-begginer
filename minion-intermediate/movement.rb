

def possible_directions
  [:forward, :right, :backward, :left]
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

def direction_to_safety
  @direction_to_safety
end  

def move_to_safety
  if !@path_traveled.empty?
    @direction_to_safety = retrace_footsteps(@path_traveled.last)

    walk_towards(:safety)
  else
    #p "move to safety --------------------------------------"
    @direction_to_safety = walk_around_object
    walk_towards(:safety)
  end
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
    if path_clear?(towards_captive) && !@warrior.feel(towards_captive).stairs?
      @warrior.walk!(towards_captive)
      @path_traveled << towards_captive
    elsif trapped?
      if outnumbered?
        unless enemies_to_bind.empty?
          @warrior.bind!(enemies_to_bind.first)
          @bound_enemies << enemies_to_bind.first
        end
      else
        p "when am i in here? -----------------------------"
        @warrior.attack!(towards_captive)
      end
    else
      @warrior.walk!(walk_around_object)
      @path_traveled << walk_around_object
    end
  when :safety
    @warrior.walk!(direction_to_safety)
    @path_traveled << direction_to_safety
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

# -------------------------------------------------------------------------------

def outnumbered?
  @total_enemies_in_attack_range > 1
end

def trapped?
  #p 'in trapped..............'

  possible_directions.each do |direction|
    if found_a_captive
      #p 'captive found!'
      return false
    else
      #p 'place to run'
      return false if @warrior.feel(direction).empty?
    end
  end
  true
end

def move_away_to_throw_bombs
  #p "in move away to throw bombs"
  @queue = [:bomb, :bomb, :bomb]
  #direction = move_to_safety unless trapped?

  move_to_safety unless trapped?
end  


def warrior_has_yet_to_move
  @path_traveled.empty?
end

def enemies_to_bind
  @nearby_enemy_locations - [towards_captive] - @bound_enemies
end





