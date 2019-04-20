def diceroll (event)
  a = "#{event.content}".scan(/[+-]*[0-9]*[Dd][0-9]+/)
  if a[0].nil?
  else
    sum = "#{event.content}".match(/[+-][0-9]$/).to_s.to_i
    respondtext = ""
    dicesum = 0

    a.each do |dicecode|
      opsymbol = dicecode.match(/[+-]/).to_s
      respondtext << " #{opsymbol} ( "
      opsymbol << "1"
      d = dicecode.match(/([0-9]*)[Dd]([0-9]+)/)
      diceresult = []
      d[1].to_i.times do |num|
        dice = rand(d[2].to_i)+1
        respondtext << dice.to_s << ", "
        dicesum += dice * opsymbol.to_i
      end
      respondtext.slice!(-2..-1)
      respondtext << " )"
    end

    if sum < 0
      opsymbol = " - "
    else 
      opsymbol = " + "
    end
    respondtext << "#{opsymbol}#{sum.abs}" if sum != 0
    event.respond"#{respondtext} → #{dicesum + sum}"
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
        event.respond"威力表:#{k[1]}(C値#{k[2]}) 出目 = #{roll}  結果 = #{damage} 合計 = #{(damage+k[3].to_i)} Critical!\nnext: `k#{k[1]}@#{k[2]}+#{damage+k[3].to_i}`"
      end
    end
  end
end

def cocroll(event, percent, skillname)
  roll = rand(1..100)
  if percent >= roll
    result = "success!"
    result = "special!" if percent / 5 >= roll
    result = "決定的成功" if roll <= 5
  elsif percent < roll
    if roll >= 96
      result = "ファンブル"
    else
      result = "failed..."
    end
  end
  event.respond"#{skillname} ( #{roll} ) → **#{result}**"
end

def coccharacter(event)
  str = [rand(1..6), rand(1..6), rand(1..6)]
  con = [rand(1..6), rand(1..6), rand(1..6)]
  pow = [rand(1..6), rand(1..6), rand(1..6)]
  dex = [rand(1..6), rand(1..6), rand(1..6)]
  app = [rand(1..6), rand(1..6), rand(1..6)]
  siz = [rand(1..6), rand(1..6)]
  int = [rand(1..6), rand(1..6)]
  edu = [rand(1..6), rand(1..6), rand(1..6)]

  respondText = """
STR: (#{str}) = #{str.inject(:+)}
CON: (#{con}) = #{con.inject(:+)}
POW: (#{pow}) = #{pow.inject(:+)}
DEX: (#{dex}) = #{dex.inject(:+)}
APP: (#{app}) = #{app.inject(:+)}
SIZ: (#{siz}) +6 = #{siz.inject(:+)+6}
INT: (#{int}) +6 = #{int.inject(:+)+6}
EDU: (#{edu}) +3 = #{edu.inject(:+)+3}
"""
  respondText.delete!("[")
  respondText.delete!("]")
  event.respond"#{respondText}"
end

def plot(event, plotNum, name)
  if plotNum == "reset"
    event.respond"reset plot number."
    @users.clear
  end
  if plotNum.to_i > 0
    userName = event.channel.name
    userName = name if name != nil
    @users[userName] = plotNum.to_i
    
    event.respond"set #{userName} plot number \"#{plotNum}\"."
  end

  if plotNum == "open" && event.channel.name == "session"
    respondText = ""
    (1..6).reverse_each do |i|
      respondText << i.to_s + ": "
      @users.each{|name, plot| respondText << name + ", " if plot == i}
      @users.reject!{|name, plot| plot == i}
      respondText << "\n"
    end
    event.respond"```\n#{respondText}```"
  end
end
