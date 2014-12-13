
def possible_directions
  [:forward, :backward, :left, :right]
end

def walk_towards_stairs
  towards_stairs = @warrior.direction_of_stairs
  @warrior.walk!(towards_stairs)
end
