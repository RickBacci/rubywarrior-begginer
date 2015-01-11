
def warrior_listens # updates values of everything in room
  #record_action
  @total_enemies = 0 # 1 or 2 distance only
  @total_captives = 0 
  @captives_in_range = false
  @warrior_heard = []
  @multiple_bound_enemies_in_range = 0
  @bound_enemies = false
  @multiple_enemies_next_to_warrior = 0


  warrior.listen.each_with_index do |square, index|

    @warrior_heard << Space.new

          space = warrior_heard[index]
           name = square.to_s
       distance = warrior.distance_of(square)
      direction = warrior.direction_of(square)
      @total_enemies += 1 if square.enemy? && distance < 3

  
    space[:name] = square.to_s
    space[:direction] = direction
    space[:distance] = distance
    space[:ticking] = square.ticking?
    space[:enemy] = (name == 'Sludge' || name == 'Thick Sludge') ? true : false
    space[:captive] = square.captive? ? true : false
    space[:enemy_bound] = ((space[:enemy] && space[:captive]) ? true : false)
    space[:enemy_threat] = square.enemy?

    space[:priority] = 1 if square.captive? && square.ticking?       # ticking captive
    space[:priority] = 2 if square.captive? && !square.ticking?      # captive
    space[:priority] = 3 if square.enemy?                            # enemy
    space[:priority] = 4 if (space[:enemy] && space[:captive])       # bound enemy

    @total_captives += 1 if space.captive && !space.enemy
    @captives_in_range = true if distance <= 2 && (!space[:enemy] && square.captive?)

    @bound_enemies = space[:enemy_bound]
    @multiple_enemies_next_to_warrior += 1 if square.enemy? && distance == 1

  end
  warrior_heard.sort! { |x, y| x.priority <=> y.priority }
end


def perfect_bomb_location
 
  surrounded_on_three_sides? # warrior retreats to bomb
    
  return false if @captives_in_range == true # this needed for level 9

    if no_ticking_captives || path_blocked?
       
      if one_or_two_enemies_ahead && multiple_enemies_within_two_spaces
        record_action
        return true
      end
    end
  false
end

def surrounded_on_three_sides?
  if @enemies_next_to_warrior == 3 && @total_empty_spaces != 0
    @path_blocked = true
   
    warrior_walk(direction_to_retreat)
    return false
  end
end

def no_ticking_captives
  return false if next_objective.nil?
  !@objectives.first.ticking
end

def path_blocked?
  return true if @path_blocked == true
  false
end

def multiple_enemies_within_two_spaces
  total_enemies > 1 # total enemies?
end


def one_or_two_enemies_ahead
  !look_for_direction.nil?
end


def any_captives?

  if @total_captives > 0
    record_action
    return true 
  end
  false
end


def multiple_enemies_next_to_warrior?

    if @multiple_enemies_next_to_warrior > 1
      record_action
      return true
    end
  false
end


def bound_enemies?
  @bound_enemies
end


def one_enemy_left?
  
  total_enemies2 = 0
  warrior_heard.each do |space|
    total_enemies2 += 1 if space.enemy
  end
    if total_enemies2 == 1
      record_action
      return true 
    end
  false
end


def next_to_last_enemy
  
  if one_enemy_left? && count_enemies_in_range == 1
    record_action
    return true
  end
  false
end
