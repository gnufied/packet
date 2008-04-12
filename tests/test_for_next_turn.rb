require File.join(File.dirname(__FILE__) + "/runner")

Packet::Reactor.run do |t_reactor|
  t_reactor.next_turn { puts "Hello World" }
end
