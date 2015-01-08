def count_objects
  @warrior.listen.size
end

def create_objects
  if @warrior_hears.nil?
    p "this only happens when new objects generated !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

    @warrior_hears = [] 
    @warrior.listen.size.times do
      @warrior_hears << Space.new
    end
    @warrior_hears
  end
end