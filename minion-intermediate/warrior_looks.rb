
def warrior_looks
  #record_action
  p @look_for_direction = nil # this is for bombing

  possible_directions.each do |direction|

    squares = []
    warrior.look(direction).each do |square|
      distance = warrior.distance_of(square)
      squares << [square.to_s, distance]
      if distance < 2 && square.enemy?
        p @look_for_direction ||= direction
      elsif distance < 3 && square.enemy?
        p @look_for_direction ||= direction
      end
    end
    warrior_saw[direction] = squares
  end
  @warrior_saw
end
