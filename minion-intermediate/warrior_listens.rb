
def warrior_listens # updates values of everything in room
  #record_action
  @total_enemies = 0 # 1 or 2 distance only
  @total_captives = 0 
  @captives_in_range = false
  @warrior_heard = []


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

    space[:priority] = 1 if square.captive? && square.ticking?          # ticking captive
    space[:priority] = 2 if square.captive? && !square.ticking?         # captive
    space[:priority] = 3 if square.enemy?                               # enemy
    space[:priority] = 4 if (space[:enemy] && space[:captive])          # bound enemy

    @total_captives += 1 if space.captive && !space.enemy
    @captives_in_range = true if distance <= 2 && (!space[:enemy] && square.captive?)


   
  end
  warrior_heard.sort! { |x, y| x.priority <=> y.priority }
end


def perfect_bomb_location
 
  total_enemies2 = 0
  escape_route = false

  @warrior_felt.each do |direction, space|
    total_enemies2 += 1 if space.eql?('Thick Sludge') || space.eql?('Sludge')
    escape_route = true if space.eql?('nothing')
  end

  if total_enemies2 == 3 && escape_route == true
    record_action
    @path_blocked = true
   
    warrior_walk(direction_to_retreat)
    return false
  end
    
  return false if @captives_in_range == true # this needed for level 9

  if (total_enemies > 1 && !@objectives.first.ticking) || @path_blocked == true
      record_action
      return true
  end
  false
end


def any_captives?

  if @total_captives > 0
    record_action
    return true 
  end
  false
end


def bind_enemies
  
  action = false
  warrior_heard.each do |space|
    if (space.enemy_threat && (space.direction != towards_objective)) && space.distance == 1
      unless action
        record_action
        bind_enemy(space.direction)
        space.enemy_threat = false
        space.enemy_bound = true
        action = true
      end
    end
  end
end


def multiple_enemies_near?

  total_enemies = 0

  warrior_heard.each do |space|
    next if space.distance != 1
    total_enemies += 1 if space.enemy_threat
  end
    if total_enemies > 1
      record_action
      return true
    end
  false
end


def bound_enemies?
  
  warrior_heard.each do |square|
    if (square.captive && square.enemy)
      record_action
      return true
    end
  end
  false
end

def multiple_bound_enemies_in_range?
  total = 0
  range = 0
  in_range = false
  warrior_heard.each do |square|
    if (square.captive && square.enemy)
      record_action
      range = square.distance
      total += 1 if range == 2
    end
  end
  
  if total > 1 #&& range == 2
    return true
  end
  false
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
