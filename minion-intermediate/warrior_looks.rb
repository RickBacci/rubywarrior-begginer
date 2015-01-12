Look = Struct.new(:direction, :space1, :space2, :space3)
        

def warrior_looks
  @looks = []
  
  @look_for_direction = nil # this is for bombing

  possible_directions.each_with_index do |direction, index|

    @looks << Look.new

      squares = @looks[index]
      distance = index += 1

      squares[:direction] = direction
         squares[:space1] = warrior.look(direction)[0].to_s
         squares[:space2] = warrior.look(direction)[1].to_s
         squares[:space3] = warrior.look(direction)[2].to_s

    if warrior.look(direction)[0].enemy?      # only want enemies
      @look_for_direction = direction         # within 2 spaces
    elsif warrior.look(direction)[1].enemy?   # always use 1 space
      @look_for_direction ||= direction       # if possible
    end
  end
  @looks
end

def warrior_should_stay_and_bomb?
  return false if look_for_direction.nil?
  warrior.look(look_for_direction)[0].enemy? && warrior.look(look_for_direction)[1].enemy?
end
