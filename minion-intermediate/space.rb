
def what_warrior_hears
  @warrior_hears.each do |sound|
    string = ''; t = ''; s = 'space'

    t = 'ticking ' if sound.ticking
    s = 'spaces' if sound.distance > 1

    string << "There is a #{t}#{sound.name} #{sound.distance} "
    string << "#{s} #{sound.direction} --- "

    if sound.captive && !sound.enemy     
      string << "captive: #{sound.captive} ticking:#{sound.ticking}"
    else
      string << "threat: #{sound.enemy_threat} bound: #{sound.enemy_bound}"
    end
    puts string
  end
end