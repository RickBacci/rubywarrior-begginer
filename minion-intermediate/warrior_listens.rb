
def warrior_listens # updates values of everything in room
  #record_action
  # @total_enemies = 0
  # @total_captives = 0 # 1 or 2 distance only
  # @captives_in_range = false

  warrior.listen.each_with_index do |square, index|
    

          space = warrior_heard[index]
           name = square.to_s
       distance = warrior.distance_of(square)
      direction = warrior.direction_of(square)
    

    space[:name] = square.to_s
    space[:direction] = direction
    space[:distance] = distance
    space[:ticking] = square.ticking?
    space[:enemy] = true if name == enemies
    space[:captive] = square.captive? ? true : false
    space[:enemy_bound] = ((space[:enemy] && space[:captive]) ? true : false)
    space[:enemy_threat] = square.enemy?

    # @total_enemies += 1 if square.enemy? && distance <= 2
    # @total_captives += 1 if square.captive?
    # @captives_in_range = true if distance <= 2 && (!square.enemy? && square.captive?)
  end
  warrior_heard
end

def enemies
  'Sludge' || 'Thick Sludge'
end


def perfect_bomb_location
  
  total_enemies2 = 0
  captives_near = false
  warrior_heard.each do |space|
    if space.enemy_threat
      total_enemies2 += 1 if space.distance <= 2
    end
    captives_near = true if (space.captive && space.distance <=2) && !space.enemy
  end
    if total_enemies2 > 1 && captives_near == false
      record_action
      return true
    end
  false
end


def any_captives?
 captives = 0
  warrior_heard.each do |square|
    captives += 1 if (square.captive && !square.enemy) 
  end

    if captives >= 1
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
