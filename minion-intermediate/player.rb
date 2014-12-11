class Player


	# change enemies are near to return an array of enemy
	# directions. If there are more than 1 enemy then he
	# needs to bind some to survive.

	def possible_directions
		[:forward, :backward, :left, :right]
	end

  def enemies_are_near?
  	enemy_locations = []

	  	possible_directions.each do |direction|
	  		enemy_locations << direction if @warrior.feel(direction).enemy?
	  	end

  	return nil if enemy_locations.empty?
  	enemy_locations
  end

  def captives_are_near?
  	captive_locations = []

	  	possible_directions.each do |direction|
	  		captive_locations << direction if @warrior.feel(direction).captive?
	  	end

  	return nil if captive_locations.empty?
  	captive_locations
  end

  def fully_recovered?(warrior)
  	warrior.health == 20
  end

  def severely_wounded?
  	@warrior.health < 10
  end

  def stop_to_rest(warrior)
  	warrior.rest!
  end

  def number_of_enemies
  	return 0 if @enemy_locations.nil?
  	@enemy_locations.size
  end

  def closest_enemy
  	@enemy_locations[0]
  end

  def closest_captive
  	@captive_locations[0]
  end

  def play_turn(warrior)
  	@warrior = warrior
  	towards_stairs = warrior.direction_of_stairs

  	enemy_locations = enemies_are_near?
  	captive_locations = captives_are_near?

  	@captive_locations = captive_locations
  	@enemy_locations = enemy_locations

  	#severe_wounds = severely_wounded?(warrior)


  	
  	#p enemy_locations
  	if enemies_are_near?
  		if number_of_enemies > 1
  			warrior.bind!(closest_enemy)
  		else
  		  warrior.attack!(closest_enemy) unless enemy_locations.nil?
  		end
  	elsif severely_wounded?
  		stop_to_rest(warrior)
  	# elsif !fully_recovered?(warrior)
  	# 	stop_to_rest(warrior)
  	elsif captives_are_near?
  		warrior.rescue!(closest_captive)
  	else
  	  warrior.walk!(towards_stairs)
  	end
  end
end
