
def debugging
  puts "There are #{count_objects} objects in the room"
  puts "Last turn there were #{@objectives.size} objectives"
  puts
  puts warrior_feels
  puts
  warrior_looks.each do |direction|
    puts "#{direction[0]} --- #{direction[1][0][0]} #{direction[1][0][1]}," << 
                          "#{direction[1][1][0]} #{direction[1][1][1]}," <<
                          "#{direction[1][2][0]} #{direction[1][2][1]}"
  end

  puts
  puts 'path traveled'
  puts @path_traveled
  puts
  puts "Direction to stairs: #{@warrior.direction_of_stairs}"
  puts
  puts 'objectives'
  @objectives.each do |objective|
    puts
    puts "Name: #{objective.name}"
    puts "Direction: #{objective.direction}"
    puts "Distance: #{objective.distance}"
    puts "Ticking: #{objective.ticking}"
    puts "Enemy threat: #{objective.enemy_threat}"
    puts "Captive: #{objective.captive}"
    puts "Enemy bound: #{objective.enemy_bound}"
    puts "Enemy: #{objective.enemy}"
    puts "Counted: #{objective.counted}"
  end
  puts
end


def what_warrior_hears
  puts
  warrior_listens.each do |sound|
    string = ''; t = ''; s = 'space'

    t = 'ticking ' if sound.ticking
    s = 'spaces' if sound.distance > 1

    string << "There is a #{t}#{sound.name} #{sound.distance} "
    string << "#{s} #{sound.direction} --- "

    if sound.captive && !sound.enemy     
      string << "captive: #{sound.captive} ticking:#{sound.ticking}"
    else
      string << "threat: #{sound.enemy_threat} bound: #{sound.enemy_bound}"
    end
    puts string
  end
  puts
end



