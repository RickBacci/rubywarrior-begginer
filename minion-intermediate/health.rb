
def severely_wounded? 
  enemies_in_room? && @warrior.health < 4 
end

def stop_to_rest
  @warrior.rest!
end

def hit_points_needed?
  # battle with Think Sludge requires 15hp
  # battle with Sludge requires 9hp.

  return true if next_enemy? == 'Sludge' && @warrior.health < 10
  return true if next_enemy? == 'Thick Sludge' && @warrior.health < 16
  false
end

def recover_from_battle
  if next_enemy? == 'Sludge'
    stop_to_rest if @warrior.health < 10
  elsif next_enemy? == 'Thick Sludge'
    stop_to_rest if @warrior.health < 16
  else
    p "next enemy is #{next_enemy?}"
  end
end
