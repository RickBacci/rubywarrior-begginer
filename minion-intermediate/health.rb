def fully_recovered?
  @warrior.health == 20
end

def severely_wounded?
  @warrior.health < 4
end

def stop_to_rest
  @warrior.rest!
end

# battle with Think Sludge requires 15hp
# battle with Sludge requires 9hp.

