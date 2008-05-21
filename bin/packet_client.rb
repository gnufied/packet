require "socket"
require "../lib/packet/packet_parser"

class PacketClient
  def create_huge_message
    string = "hello"
    message = []
    packet_size = (500*1024)/5
    packet_size.times { message << string}
    message
  end

  def dump_object data
    object_dump = Marshal.dump(data)
    dump_length = object_dump.length.to_s
    length_str = dump_length.rjust(9,'0')
    final_data = length_str + object_dump
    @message_size = final_data.size
    write_data(final_data)
  end

  def initialize
    @tokenizer = Packet::BinParser.new
    @connection = TCPSocket.open("localhost",11007)
    @connection.setsockopt(Socket::IPPROTO_TCP,Socket::TCP_NODELAY,1)
  end

  def write_data data
    begin
      flush_in_loop(data)
    rescue Errno::EAGAIN
      return
    rescue Errno::EPIPE
      puts "pipe error"
    rescue
      puts "some other error"
    end
  end

  def flush_in_loop(data)
    t_length = data.length
    loop do
      break if t_length <= 0
      written_length = @connection.write(data)
      raise "Error writing to socket" if written_length <= 0
      result = @connection.flush
      data = data[written_length..-1]
      t_length = data.length
    end
  end


  def dump_and_wait
    dump_object(create_huge_message)
    ret_data = @connection.read(@message_size)

    raw_response = nil
    @tokenizer.extract(ret_data) { |x| raw_response = x}
    final_object = Marshal.load(raw_response)
    p final_object.join.size
  end
end

100.times do
  a = PacketClient.new
  a.dump_and_wait
  sleep 0.5
end



