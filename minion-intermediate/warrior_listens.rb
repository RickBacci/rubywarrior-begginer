Listen = Struct.new(:name, :direction, :distance,
                   :ticking, :enemy_threat, :captive,
                   :enemy_bound, :enemy, :priority)


def warrior_listens # updates values of everything in room
  @objectives = []
  
  @total_captives = 0 
  @captives_in_range = false
  
  @bound_enemies = false
  @total_enemies_in_bomb_range = 0 # 1 or 2 distance only
  @any_enemies = false

  warrior.listen.each_with_index do |square, index|

    @objectives << Listen.new

          space = @objectives[index]
           name = square.to_s
       distance = warrior.distance_of(square)
      direction = warrior.direction_of(square)
    enemy_names = true if (name == 'Sludge' || name == 'Thick Sludge')
      
            space[:name] = square.to_s
       space[:direction] = direction
        space[:distance] = distance
         space[:ticking] = square.ticking?
           space[:enemy] = enemy_names ? true : false
         space[:captive] = square.captive? ? true : false
     space[:enemy_bound] = (space.enemy && space.captive) ? true : false
    space[:enemy_threat] = square.enemy?

        space[:priority] = 1 if square.captive?                 # captive
        space[:priority] = 2 if square.enemy?                   # enemy
        space[:priority] = 3 if (space.enemy && space.captive)  # bound enemy

    @total_captives += 1 if space.captive && !space.enemy
    @captives_in_range = true if distance <= 2 && (!space.enemy && space.captive)

    @bound_enemies = space.enemy_bound
    @total_enemies_in_bomb_range += 1 if space.enemy && distance < 3
    @any_enemies = true if space.enemy

  end
  @objectives.sort! { |x, y| x.priority <=> y.priority }
end


def perfect_bombing_location?
 
  surrounded_on_three_sides? # warrior retreats to bomb
    
  return false if @captives_in_range == true # this needed for level 9
  return false if !multiple_enemies_within_two_spaces

    if no_ticking_captives || path_blocked?
       
      if one_or_two_enemies_ahead && multiple_enemies_within_two_spaces
        record_action
        return true
      end
    end
  false
end

def bomb_enemies
  blow_stuff_up(look_for_direction)
end

def path_blocked?
  @path_blocked
end

def any_captives?
  @total_captives > 0
end

def no_ticking_captives
  return false if next_objective.nil?
  !objectives.first.ticking
end

def multiple_enemies_within_two_spaces
  @total_enemies_in_bomb_range > 1
end

def one_or_two_enemies_ahead
  !look_for_direction.nil?
end

def multiple_enemies_next_to_warrior?
  @multiple_enemies_next_to_warrior > 1
end

def bound_enemies?
  @bound_enemies
end

def any_enemies_left?
  @any_enemies
end

