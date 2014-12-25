
def closest_enemy
  (@directions_to_all_enemies - @bound_enemies).first
end

def outnumbered?
  @total_enemies_in_attack_range > 1
end

def enemy
  next_to_warrior?(:enemy)
end

def single_enemy?#(direction)
  #@warrior.feel(direction).enemy?
  @warrior.feel.enemy?
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

def bind_closest_enemy
  #@target = @directions_to_all_enemies - @bound_enemies - [towards_captive]
  #@target = @directions_to_all_enemies - [towards_captive]
  #p 'target'
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
  @directions_to_all_enemies.first
end

def kill_bound_enemies
  if found_a_bound_enemy
    @warrior.attack!(@directions_to_all_enemies.first)
    @bound_enemies.shift
  else
    @warrior.walk!(@directions_to_all_enemies.first)
  end
end

def kill_enemies
  if multiple_enemies_ahead? && !@captive_in_danger
    bomb_enemies
  elsif single_enemy?
    attack_enemy
  else
    @warrior.walk!(@directions_to_all_enemies.first)
  end
end

# def number_of_enemies_ahead?
#   enemies = 0
#   @warrior.look.each do |space|
#     enemies += 1 if space.enemy?
#   end
#   enemies
# end

def multiple_enemies_ahead?  # bad logic!
  squares = []
  @warrior.look.each do |square|
    squares << square.to_s
  end
  squares.each do |square|
    p square
    if squares[0] == 'Sludge' || squares[1] == 'Thick Sludge'
      return true
    end
  end
  false
end

def bomb_enemies
  @dir ||= [:left, :right]#, :left]
  if @dir == []
    @warrior.attack!(:left)
  else
    @warrior.detonate!(@dir.shift)
  end
end

def attack_enemy
  @warrior.attack!(enemy)
end
