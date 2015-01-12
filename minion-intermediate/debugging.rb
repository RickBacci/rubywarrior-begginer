
def debugging
  @debugging = true
  
  puts "There are #{@warrior.listen.size} objects in the room"
  puts
  puts feels
  puts
  puts looks
  puts
  puts 'path traveled'
  p path_traveled
  puts
  puts "Direction to stairs: #{@warrior.direction_of_stairs}"
  puts
  puts 'objectives'
  objectives.each do |objective|
    puts
    puts "Name: #{objective.name}"
    puts "Priority: #{objective.priority}"
    puts "Direction: #{objective.direction}"
    puts "Distance: #{objective.distance}"
    puts "Ticking: #{objective.ticking}"
    puts "Enemy threat: #{objective.enemy_threat}"
    puts "Captive: #{objective.captive}"
    puts "Enemy bound: #{objective.enemy_bound}"
    puts "Enemy: #{objective.enemy}"
  end
  puts
end

def record_action
  @log = [] if caller[0][/`.*'/][1..-2] == 'play_turn'
  @log << caller[0][/`.*'/][1..-2]  
  # @log << __callee__
end

def print_log
  @log ||= []
  puts
  @log.each { |val| p val } if @debugging
  puts
end
