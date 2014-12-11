class Player


	# change enemies are near to return an array of enemy
	# directions. If there are more than 1 enemy then he
	# needs to bind some to survive.
  def gather_intel
  	@enemy_locations = enemies_are_near?
  	@captive_locations = captives_are_near?
  end
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

  def fully_recovered?
  	@warrior.health == 20
  end

  def severely_wounded?
  	@warrior.health < 10
  end

  def stop_to_rest
  	@warrior.rest!
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

  def no_enemies_found
  	@enemy_locations.nil?
  end

  def bind_closest_enemy
  	@warrior.bind!(closest_enemy)
  end

  def rescue_closest_captive
  	@warrior.rescue!(closest_captive)
  end

  def outnumbered?
  	number_of_enemies > 1
  end

  def attack_closest_enemy
		@warrior.attack!(closest_enemy)
  end

  def walk_towards_stairs
  	towards_stairs = @warrior.direction_of_stairs
  	@warrior.walk!(towards_stairs)
  end

  def play_turn(warrior)
  	@warrior = warrior

  	gather_intel
  	

  	
  	if enemies_are_near?
  		if outnumbered?
  			bind_closest_enemy
  		else
  		  attack_closest_enemy
  		end
  	elsif severely_wounded?
  		stop_to_rest
  	elsif captives_are_near?
  		rescue_closest_captive
  	else
  	  walk_towards_stairs
  	end
  end
end
