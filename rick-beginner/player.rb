class Player
  def play_turn(warrior)
    
    @warrior = warrior
    @health = 20 if @health.nil?
    
    define_singleton_method('under_attack?') { warrior.health < @health }

    # def under_attack?
    #   @warrior.health < @health
    # end
    
    def wounded?
      @warrior.health != 20 
    end

    def severely_wounded?
      @warrior.health <= 9
    end

    def retreat!
      @warrior.walk!(:backward)
    end


    scout_ahead = []
    scout_ahead << warrior.look[0] << warrior.look[1] << warrior.look[2]
    
    @intel_ahead = []
    scout_ahead.each do |space|
      @intel_ahead << space.to_s
    end

    scout_behind = []
    scout_behind << warrior.look(:backward)[0] << warrior.look(:backward)[1] << warrior.look(:backward)[2]

    @intel_behind = []
    scout_behind.each do |space|
      @intel_behind << space.to_s
    end

    # p "Intel_ahead: #{@intel_ahead}"
    # p "Intel_behind: #{@intel_behind}"

    # p "wizards ahead" if @intel_ahead.include?('Wizard')
    # p "Archer ahead" if @intel_ahead.include?('Archer')
    # p "Captive ahead" if @intel_ahead.include?('Captive')

    # p "wizards behind" if @intel_behind.include?('Wizard')
    # p "Archer behind" if @intel_behind.include?('Archer')
    # p "Captive behind" if @intel_behind.include?('Captive')
    def sludge_ahead?
      @intel_ahead[1] == 'Sludge' || @intel_ahead[2] == 'Sludge'
    end

    def thick_sludge_ahead?
      @intel_ahead[1] == 'Thick Sludge' || @intel_ahead[2] == 'Thick Sludge'
    end

    def wizard_ahead?
      @intel_ahead[1] == 'Wizard' || @intel_ahead[2] == 'Wizard'
    end

    def wizard_behind?
      @intel_behind[1] == 'Wizard' || @intel_behind[2] == 'Wizard'
    end

    def captive_ahead?
      @intel_ahead[1] == 'Captive'
    end

    def captive_behind?
      @intel_behind[1] == 'Captive'
    end

    def archer_ahead?
      @intel_ahead[1] == 'Archer' || @intel_ahead[2] == 'Archer'
    end

    def archer_behind?
      @intel_behind[1] == 'Archer' || @intel_behind[2] == 'Archer'
    end

    def wall?
      @intel_ahead[1] == 'wall'
    end

    def wall_behind?
      @intel_behind[1] == 'wall'
    end

    def trapped?
      @warrior.feel(:backward).wall?
    end

    def can_see_wall
      @intel_ahead[0] == 'nothing' && @intel_ahead[1] == 'wall'
    end


    p warrior.feel.stairs?

  	if warrior.feel.empty?

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
          if wizard_ahead? || archer_ahead?
            warrior.shoot!
          elsif wizard_behind? || archer_behind?
            warrior.shoot!(:backward)
          elsif warrior.feel.enemy?
            warrior.attack!
          else
            warrior.walk!
          end
        end
      else # warrior not under attack
        if wounded?
          if @intel_ahead.include?('Wizard') || archer_ahead? || sludge_ahead?
            warrior.shoot!
          else
            warrior.rest!
          end
        else
          if captive_ahead?
            p 'not under attack - see captive 2 spaces away'
            if warrior.feel.enemy?
              warrior.attack!
            elsif warrior.feel.captive?
              warrior.rescue!
            else
              warrior.walk!
            end
          elsif captive_behind?
            warrior.pivot!
          else
            if wizard_ahead? || archer_ahead?
              warrior.shoot!
            elsif wizard_behind? || archer_behind?
              warrior.shoot!(:backward)
            elsif sludge_ahead? || thick_sludge_ahead?
              warrior.shoot!
            elsif warrior.feel.enemy?
              warrior.attack!
            elsif can_see_wall
              if warrior.feel.stairs?
                warrior.walk!
              else
                warrior.pivot!
              end
            else
              warrior.walk!
            end 
          end
        end
      end
    elsif warrior.feel.captive?
    	warrior.rescue!
    elsif warrior.feel(:backward).captive?
      warrior.rescue!(:backward)
    elsif warrior.feel.wall?
      warrior.pivot!
    elsif can_see_wall
      warrior.pivot!
    elsif warrior.feel.enemy?
      p 'close quarters fighting'
      warrior.attack!
    else
      warrior.walk!
    end

  	@health = warrior.health
	
	end # end method
end # end class
