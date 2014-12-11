class Player
	

  def enemies_are_near?(warrior)
  	directions = [:forward, :backward, :left, :right]

  	directions.each do |direction|
  		return direction if warrior.feel(direction).enemy?
  	end
  	nil
  end

  def fully_recovered?(warrior)
  	warrior.health == 20
  end

  def severely_wounded?(warrior)
  	warrior.health < 10
  end

  def stop_to_rest(warrior)
  	warrior.rest!
  end

  def play_turn(warrior)
  	towards_stairs = warrior.direction_of_stairs
  	towards_enemy = enemies_are_near?(warrior)
  	severe_wounds = severely_wounded?(warrior)
  	
  	if enemies_are_near?(warrior)
  		warrior.attack!(towards_enemy)
  	elsif severe_wounds
  		stop_to_rest(warrior)
  	elsif !fully_recovered?(warrior)
  		stop_to_rest(warrior)
  	else
  	  warrior.walk!(towards_stairs)
  	end
  end
end
