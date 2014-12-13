def fully_recovered?
  @warrior.health == 20
end

def severely_wounded?
  @warrior.health < 12
end

def stop_to_rest
  @warrior.rest!
end
