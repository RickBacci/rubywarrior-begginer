
def closest_enemy
  (@directions_to_all_enemies - @bound_enemies).first
end

def outnumbered?
  @total_enemies_in_attack_range > 1
end

def enemy
  #p 'in enemy'
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
    #p 'in attack closest enemy single enemy'
    #p enemy
    @warrior.attack!(enemy)
  elsif bound_enemy?
    #p 'in attack closest enemy bound enemy'
    #p @bound_enemies
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

def bind_closest_enemy
  @target = @direction_of_enemies_in_attack_range - [towards_captive]

  if @target != []
    @warrior.bind!(@target.first)
    @bound_enemies << @target.first
  else
    @bound_enemies = []
    @warrior.detonate!(towards_captive)
  end
  
end

def found_a_bound_enemy
  @warrior.feel(@directions_to_all_enemies.first).captive?
end

def enemies_in_room?
  #@directions_to_all_enemies.first
  if (@directions_to_all_enemies.size - @bound_enemies.size) == 0
    return false
  end
  true
end

def kill_bound_enemies
  p 'in kill_bound_enemies'
  if found_a_bound_enemy
    @warrior.attack!(@directions_to_all_enemies.first)
    @bound_enemies.shift
  else
    @warrior.walk!(@directions_to_all_enemies.first)
    @path_traveled << @directions_to_all_enemies.first
  end
end

def kill_enemies
  p 'in kill_enemies'
  p single_enemy?
  p @directions_to_all_enemies
  if multiple_enemies_ahead? && !@captive_in_danger
    p 'in kill enemies multiple ahead and no captives'
    bomb_enemies
  elsif single_enemy?
    p 'in kill enemies single_enemy? true'
    attack_enemy
  else
    @warrior.walk!(@directions_to_all_enemies.first)
    @path_traveled << @directions_to_all_enemies.first
  end
end


def multiple_enemies_ahead?
  squares = []
  @warrior.look.each do |square|
    squares << square.enemy?
  end
  #p 'squares in multiple_enemies_ahead'
  #p squares
  #squares.each do |square|
    if squares[0] && squares[1]
      return true
    end
  #end
  false
end

def bomb_enemies # think this logic is limited
  # @dir ||= [:left, :right]
  # if @dir == []
  #   @warrior.attack!(:left)
  # else
  #   @warrior.detonate!(@dir.shift)
  # end
  @warrior.detonate!(enemy)
end

def attack_enemy
  p 'in attack_enemy'
  @warrior.attack!(enemy)
end
