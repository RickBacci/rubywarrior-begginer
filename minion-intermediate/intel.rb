
def possible_directions
  [:forward, :right, :backward, :left]
end

def warrior_feels
  #@warrior_feels = {forward: '', right: '', backward: '', left: ''}
  @warrior_feels = {}
  possible_directions.each do |direction|

    square = @warrior.feel(direction).to_s
    if square == 'nothing'
      square = 'stairs' if @warrior.feel(direction).stairs?
    end
    @warrior_feels[direction] = square
  end
  @warrior_feels
end

def warrior_looks
  @warrior_sees = {}
 
  #p 'look for intel 2'
  possible_directions.each do |direction|

    squares = []
    @warrior.look(direction).each do |square|
      distance = @warrior.distance_of(square)
      squares << [square.to_s, distance]
    end

    @warrior_sees[direction] = squares
  end
  @warrior_sees
end

def warrior_listens # updates values of everything in room
  p 'in here at start of every turn...................................'
  @warrior.listen.each_with_index do |square, index|
  space = @warrior_hears[index]
  name = square.to_s

  # next if space.nil? 

          space[:name] = square.to_s
     space[:direction] = @warrior.direction_of(square)
      space[:distance] = @warrior.distance_of(square)
       space[:ticking] = square.ticking?
         space[:enemy] = true if name == 'Sludge' || name == 'Thick Sludge'
       space[:captive] = square.captive? ? true : false
    #if space[:enemy_threat].nil?
       space[:enemy_bound] = ((space[:enemy] && space[:captive]) ? true : false) 
    #end
    #if space[:enemy_threat].nil?
      space[:enemy_threat] = square.enemy?
   # end
  end
  #p @warrior_hears.each { |v| puts "Name: #{v.name} counted: #{v.counted}" }
  @warrior_hears
end
