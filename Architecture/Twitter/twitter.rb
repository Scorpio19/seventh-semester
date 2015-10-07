#encoding: UTF-8

require 'observer'

class Twitter

  include Observable

  def initialize(name)
    @username = name
  end

  def tweet(message)
    changed
    notify_observers(@username, message)
  end

  def follow(user)
    user.add_observer(self)
    self
  end

  def update(name, message)
    puts ("#{@username} received a tweet from #{name}: #{message}")
  end
end

y = Twitter.new('Yoda')
o = Twitter.new('Obi-Wan Kenobi')
v = Twitter.new('Darth Vader')
p = Twitter.new('Padmé Amidala')

p.follow(v)
v.follow(p).follow(y).follow(v)

y.tweet 'Do or do not. There is no try.'
o.tweet 'The Force will be with you, always.'
v.tweet 'I find your lack of faith disturbing.'
o.tweet 'In my experience, there\'s no such thing as luck.'
y.tweet 'Truly wonderful, the mind of a child is.'
p.tweet 'I will not condone a course of action that will lead us to war.'
