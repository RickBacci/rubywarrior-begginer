def fully_recovered?
  @warrior.health == 20
end

def severely_wounded?
  @warrior.health < 4
end

def severely_wounded_with_enemies_in_room?
  severely_wounded? && enemies_in_room?
end


def stop_to_rest
  @warrior.rest!
end

# battle with Think Sludge requires 15hp
# battle with Sludge requires 9hp.

def hit_points_needed?
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
