EVAL_APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__) + "/.."))
["extras","bin","worker","lib"].each { |x| $LOAD_PATH.unshift(EVAL_APP_ROOT + "/#{x}")}

WORKER_ROOT = EVAL_APP_ROOT + "/worker"

require "packet"
#require "buftok"

class Foo
  def receive_data p_data
    p p_data
    # @tokenizer.extract(p_data).each do |t_data|
    # send_data(p_data)
    #     end

#     data_callback = Packet::Callback.new { |data| show_result(data) }
#     workers[:no_proxy_worker].send_request(:data => p_data,:callback => data_callback)
    ask_worker(:no_proxy_worker,:data => p_data, :type => :request)
    p reactor.live_workers
    # ask_worker(:dynamic_worker,:job_key => :hello_world, :data => p_data, :type => :request)
  end

  def worker_receive p_data
    send_data "#{p_data[:data]}\n"
  end

  def show_result p_data
    send_data("#{p_data[:data]}\n")
  end

  def connection_completed
    puts "calling connection completed" 
    #add_periodic_timer(4) { send_data("hello\n")}
    start_worker(:worker => :dynamic1_worker, :job_key => :hello_world)
#     100.times do |i|
#       thread_pool.defer(i) do |j|
#         puts "Starting work for #{j} : #{j.class}"
#         sleep(1)
#         puts "Work done for #{j}"
#       end
#     end
  end

  def post_init
    # @tokenizer = BufferedTokenizer.new
  end

  def wow
    #puts "Wow"
  end
end

Packet::Reactor.run do |t_reactor|
  t_reactor.start_server("0.0.0.0", 11007,Foo)
  #t_reactor.next_turn { a = 10 }
end

