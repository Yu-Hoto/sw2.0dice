def diceroll (event)
  if event.channel.name != 'general'
    event.send_message("Dice rolls in 'general' only'")
  else
    d = "#{event.content}".match(/\A([0-9]*)[Dd]([0-9]+)(?:\+([0-9]*))?(?: .*)?\z/)
    if d.nil?
    else
      puts d.inspect

      dice = []
      dicesum = 0
        
      d[1].to_i.times { |num| dicesum += (dice[num] = rand(d[2].to_i)+1)}
        
      if d[3].nil?
        event.respond "( #{dice.join(', ')} ) → #{dice.join('+')} = #{dicesum}"
      else
        event.respond "( #{dice.join(', ')} ) → #{dice.join('+')}+#{d[3].to_i} = #{dicesum+d[3].to_i}"
      end
    end
    
    k = "#{event.content}".match(/\Ak([0-9]+)@([0-9]+)(?:\+([0-9]*))?\z/)
    
    if k.nil?
        
      else
      puts k.inspect
      roll = (1..2).inject(0){|sum| sum += rand(1..6)}
        
      puts roll
      if roll == 2
        event.respond"威力表:#{k[1]}(C値#{k[2]}) 出目 = #{roll}  結果 = 自動失敗"
      else
        rating = open("rating.txt", "r")
        damage = (rating.readlines[(k[1].to_i)*10+roll-3]).to_i
        rating.close
        if roll < k[2].to_i
          event.respond"威力表:#{k[1]}(C値#{k[2]}) 出目 = #{roll}  結果 = #{damage} 合計 = #{(damage+k[3].to_i)}"
        else
          event.respond"威力表:#{k[1]}(C値#{k[2]}) 出目 = #{roll}  結果 = #{damage} 合計 = #{(damage+k[3].to_i)} Critical!"
        end
      end
    end
  end
  nil
end