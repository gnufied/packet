require File.join(File.dirname(__FILE__) + "/runner")

class Foo
  def receive_data data
    send_data data
  end
  
  def post_init
    puts "Post Init test on server : passed"
  end
  
  def unbind
    puts "Unbind test on server: passed" 
  end
end

class Bar
  def receive_data data
    if data == "fuck\n"
      puts "Echo Server test passed" 
    else
      puts "Echo Server test failed" 
    end
    close_connection
  end
  
  def post_init
    puts "post init test on client: passed" 
  end
  
  def connection_completed
    send_data "fuck\n"
  end
  
  def unbind
    puts "server dropped connection" 
  end
end

Packet::Reactor.run do |t_reactor|
  t_reactor.start_server("0.0.0.0",11007,Foo)
  t_reactor.connect("0.0.0.0",11007,Bar)
end



