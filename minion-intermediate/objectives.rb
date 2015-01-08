
def reset_objectives
  if count_objects < @objectives.size
    @warrior_hears = nil
    @objectives = []
  end
end

def build_objectives

  @possible_objectives.each do |objective|
    warrior_listens.each_with_index do |space, index|

      case objective

      when :ticking_captive
        if space.ticking && space.counted.nil?
          space.counted = true
          @objectives << space
        end
      when :captive
        if (space.captive && space.counted.nil?) && !space.enemy
          space.counted = true
          @objectives << space
        end
      when :enemy_threat
        if space.enemy_threat && space.counted.nil?
          space.counted = true
          @objectives << space
        end
      when :enemy_bound
        if (space.captive && space.counted.nil?) && space.enemy
          space.counted = true
          @objectives << space
        end
      # when :stairs # not sure if this is doing anything
      #   @objectives << :stairs unless @stairs
      #   @stairs = true
      else
        p 'Error in build_objectives!'
      end
    end
  end
  @objectives
end

