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


    scout_area = []

    scout_area << warrior.look[0] << warrior.look[1] << warrior.look[2]
    
    @intel = []
    scout_area.each do |space|
      @intel << space.to_s
    end
    p @intel
    p "captive ahead" if @intel[0] == 'Captive'
    p "wizards present" if @intel.include?('Wizard')

    def wizard?
      @intel[1] == 'Wizard'
      #@intel.include?('Wizard')
    end

    def captive?
      @intel[1] == 'Captive'
      #@intel.include?('Captive')
    end

    def trapped?
      @warrior.feel(:backward).wall?
    end


  	if warrior.feel.empty? # feel nothing near me

      if under_attack?
        if severely_wounded?
          if trapped?
            p 'shoot from severely_wounded and trapped?'
            @warrior.shoot!
          else
            p 'retreat because severely_wounded'
            retreat!
          end
        else
          p 'walk while under attack and not severely_wounded'
          warrior.walk!
        end
      else # not under attack
        if wounded?
          warrior.rest!
        else
          if captive?
            p 'not under attack - see captive 2 spaces away'
            warrior.walk!
          else
            if @intel.include?('Wizard')
              warrior.shoot!
            else
              warrior.walk!
            end 
          end
        end
      end
    elsif warrior.feel.captive?
    	warrior.rescue!
    elsif warrior.feel.wall?
      warrior.pivot!
    else
      p 'What do you feel?'
    end

  	@health = warrior.health
	
	end # end method
end # end class
