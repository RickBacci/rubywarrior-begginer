Space = Struct.new(:name, :direction, :distance,
                   :ticking, :enemy_threat, :captive,
                   :enemy_bound, :enemy, :counted)

def create_objects
  record_action

  if @warrior_hears.nil?
    p "New objects generated !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

    @warrior_hears = [] 
    @warrior.listen.size.times do
      @warrior_hears << Space.new
    end
  end
  @warrior_hears
end