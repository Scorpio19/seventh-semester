# Domain-Specific Language Pattern
# Date: 16-Oct-2015
# Authors:
#   A01370815 Diego Galíndez Barreda
#   A01169999 Rodrigo Villalobos Sánchez

# File name: jankenpon.rb

def show(res)
  puts "Result = #{res}"
end

class HandPosture
  def self.compare(name, o, c1, c2, s, l1, e1, e2, e3, e4)
    name_condition = name.to_s == "+"
    winner = name_condition ?
      o == c1 || o == c2 ? s : o :
      o == c1 || o == c2 ? o : s
    winner_self = winner == s

    if (s == o)
      result = "#{s.to_s} tie"
    elsif (winner_self  && !name_condition) || (!winner_self && name_condition)
      result = "#{o.to_s} #{o == l1 ? e3 : e4} #{s.to_s}"
    else
      result = "#{s.to_s} #{o == c1 ? e1 : e2} #{o.to_s}"
    end
    result += " #{name_condition ? "(winner" : "(loser"} #{winner_self ? s.to_s : o.to_s})"
    puts result

    winner
  end
end


class Scissors
  def self.method_missing(name, *args)
    HandPosture.compare(name, args[0], Paper, Lizard, Scissors, Rock,
                        "cut", "decapitate", "crushes", "smashes")
  end
end

class Paper
  def self.method_missing(name, *args)
    HandPosture.compare(name, args[0], Rock, Spock, Paper, Scissors,
                        "covers", "disproves", "cut", "eats")
  end
end

class Rock
  def self.method_missing(name, *args)
    HandPosture.compare(name, args[0], Lizard, Scissors, Rock, Paper,
                        "crushes", "crushes", "covers", "vaporizes")
  end
end

class Lizard
  def self.method_missing(name, *args)
    HandPosture.compare(name, args[0], Spock, Paper, Lizard, Scissors, 
                        "poisons", "eats", "decapitate", "crushes")
  end
end

class Spock
  def self.method_missing(name, *args)
    HandPosture.compare(name, args[0], Scissors, Rock, Spock, Paper, 
                        "smashes", "vaporizes", "disproves", "poisons")
  end
end
