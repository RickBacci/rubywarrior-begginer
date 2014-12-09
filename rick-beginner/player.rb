class Player
  def play_turn(warrior)
    @warrior = warrior
    @health = 20 if @health.nil?
    
    def under_attack?
      @warrior.health < @health
    end
    
    def wounded?
      @warrior.health != 20 
    end

    def severely_wounded?
      @warrior.health <= 10
    end

    def retreat!
      @warrior.walk!(:backward)
    end

    
  	if warrior.feel.empty? # feel nothing near me
      if under_attack?
        if severely_wounded?
          retreat!
        else
          warrior.walk!
        end
      else # not under attack
        if wounded?
          warrior.rest!
        else
          warrior.walk!
        end
      end
    else # feel something near me
    	if warrior.feel.captive?
    		warrior.rescue!
    	elsif warrior.feel.wall?
        warrior.pivot!
    	else
        warrior.attack!
      end
    end

  	@health = warrior.health
	
	end # end method
end # end class
