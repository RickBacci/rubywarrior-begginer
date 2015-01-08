
def possible_directions
  [:forward, :right, :backward, :left]
end

def warrior_feels
  warrior_feels = {}
  possible_directions.each do |direction|

    square = @warrior.feel(direction).to_s
    square = 'stairs' if @warrior.feel(direction).stairs?

    warrior_feels[direction] = square
  end
  warrior_feels
end

def warrior_looks
  warrior_sees = {}
 
  possible_directions.each do |direction|

    squares = []
    @warrior.look(direction).each do |square|
      distance = @warrior.distance_of(square)
      squares << [square.to_s, distance]
    end

    warrior_sees[direction] = squares
  end
  warrior_sees
end

def warrior_listens # updates values of everything in room
  @warrior.listen.each_with_index do |square, index|
  space = @warrior_hears[index]
  name = square.to_s


          space[:name] = square.to_s
     space[:direction] = @warrior.direction_of(square)
      space[:distance] = @warrior.distance_of(square)
       space[:ticking] = square.ticking?
         space[:enemy] = true if name == 'Sludge' || name == 'Thick Sludge'
       space[:captive] = square.captive? ? true : false
   space[:enemy_bound] = ((space[:enemy] && space[:captive]) ? true : false) 
  space[:enemy_threat] = square.enemy?
  end
  @warrior_hears
end


