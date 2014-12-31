
def closest_enemy
  (@directions_to_all_enemies - @bound_enemies).first
end



def enemy
  next_to_warrior?(:enemy)
end

def single_enemy?
  if @total_enemies_in_attack_range == 1
    return true
  end
  false
end

def attack_closest_enemy
  if single_enemy?
    @warrior.attack!(enemy)
  elsif bound_enemy?
    @warrior.attack!(bound_enemy)
  else
    p 'Why are you here?'
  end
end

def no_enemies_found
  @directions_to_all_enemies.nil?
end

def bound_enemy
  @bound_enemies.first
end

def bound_enemy?
  @bound_enemies.length >= 1
end


def bind_enemy
  #p 'in bind enemy!!!!!!!!!!!!!!!!!!!!!!!'
  @target = @direction_of_enemies_in_attack_range - [towards_captive]

  @warrior.bind!(@target.first)
  @bound_enemies << @target.first
end

def found_a_bound_enemy
  @warrior.feel(@directions_to_all_enemies.first).captive?
end

def enemies_in_room?
  if (@directions_to_all_enemies.size - @bound_enemies.size) == 0
    return false
  end
  true
end

def kill_bound_enemies
  #p 'in kill_bound_enemies'
  if found_a_bound_enemy
    @warrior.attack!(@directions_to_all_enemies.first)
    @bound_enemies.shift
  else
    @warrior.walk!(@directions_to_all_enemies.first)
    @path_traveled << @directions_to_all_enemies.first
  end
end

def kill_enemies
 
  if multiple_enemies_ahead? && !@captive_in_danger
    bomb_enemies
  elsif single_enemy?
    attack_enemy
  else
    @warrior.walk!(closest_enemy)
    @path_traveled << closest_enemy
  end
end


def multiple_enemies_ahead?
  squares = []
  @warrior.look.each do |square|
    squares << square.enemy?
  end
  return true if squares[0] && squares[1]
  false
end

def bomb_enemies
  @warrior.detonate!(enemy)
end

def attack_enemy
  @warrior.attack!(enemy)
end

def bind_or_move_to_bomb
  #p 'in bind or move to bomb ---------------------------'
  if outnumbered?
  #if warrior_has_yet_to_move
    if found_a_captive
      rescue_captive
    elsif !single_enemy?
      #if @path_traveled.empty? # logic needed here
      if trapped?
        bind_enemy
      else
        move_away_to_throw_bombs
      end
    else
      bind_enemy
    end
  else
    move_away_to_throw_bombs
  end
end

def engage_enemy
  #p 'engage_enemy -----------------------------------------'
  if outnumbered?
    bind_or_move_to_bomb
  elsif severely_wounded?
    rest_or_flee?
  elsif ticking_captives?
    if multiple_enemies_ahead?
      @warrior.detonate!(towards_captive)
    else
      free_captives
    end
  else
    attack_closest_enemy
  end
end

def rest_or_flee?
  if next_to_warrior?(:enemy)
    move_to_safety
  else
    stop_to_rest
  end
end

