["lib","extras"].each { |x| $:.unshift(File.join(File.dirname(__FILE__),"..",x))}

require "packet"
require "buftok"

class EchoServer
  def receive_data(p_data)
    @buf_tok.extract(p_data).each do |data|
      puts data
      send_data(data + "\n")
    end
  end

  def connection_completed
    add_timer(3) { say_hello }
  end
  def say_hello
    send_data("Hello \n")
  end

  def post_init
    @buf_tok = BufferedTokenizer.new
  end
end

Packet::Reactor.run do |t_reactor|
  t_reactor.start_server("localhost",11001,EchoServer)
end
