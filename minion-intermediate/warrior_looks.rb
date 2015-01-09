
def warrior_looks
  record_action

  @warrior_sees = {}
  
  possible_directions.each do |direction|

    squares = []
    warrior.look(direction).each do |square|
      distance = @warrior.distance_of(square)
      squares << [square.to_s, distance]
    end

    @warrior_sees[direction] = squares
  end
  @warrior_sees
end


def look_for_direction
  record_action

  @warrior_sees.each do |direction, squares|

    if squares[0][0] == 'Thick Sludge' || squares[0][0] == 'Sludge'
      return direction 
    elsif squares[1][0] == 'Thick Sludge' || squares[1][0] == 'Sludge'
      return direction
    else
      towards_objective
    end
  end
end
