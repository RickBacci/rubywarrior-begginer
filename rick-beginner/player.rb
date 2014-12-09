class Player
  def play_turn(warrior)
  	@found_a_wall = false if @found_a_wall.nil?

  	if @found_a_wall
  		direction = :forward
  	else
  		direction = :backward
  	end

    if @health.nil? || warrior.health >= @health
    	i_am_being_attacked = false
    else
			i_am_being_attacked = true
    end

  	if warrior.feel(direction).empty?
  		# there is nothing in front of me
  		if warrior.health < 20 && i_am_being_attacked == false
  			warrior.rest!
  		else
  			if warrior.health < 10
  				if direction == :forward
  					warrior.walk!(:backward)
  				else
  				  warrior.walk!(:forward)
  				end
  			else
	     	  warrior.walk!(direction)
	     	end
  		end
    else
    	#check to see if this is a captive or sludge
    	if warrior.feel(direction).captive? == true
    		warrior.rescue!(direction)
    	elsif warrior.feel(direction).wall?
    		@found_a_wall = true
    	else
        warrior.attack!(direction)
      end
    end

  	@health = warrior.health
	
	end # end method
end # end class