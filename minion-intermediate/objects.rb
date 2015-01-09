Space = Struct.new(:name, :direction, :distance,
                   :ticking, :enemy_threat, :captive,
                   :enemy_bound, :enemy, :counted)

def create_objects
  #record_action

  if warrior_heard.nil?
    p "New objects generated !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

    @warrior_heard = [] 
    warrior.listen.size.times do
      @warrior_heard << Space.new
    end
  end
  warrior_heard
end