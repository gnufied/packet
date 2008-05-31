# FIMXE: following class must modify the fd_watchlist thats being monitored by
# main eventloop.

module Packet
  module Connection
    attr_accessor :outbound_data,:connection_live
    attr_accessor :worker,:connection,:reactor, :initialized,:signature
    include NbioHelper

    def unbind; end
    def connection_completed; end
    def post_init; end
    def receive_data data; end

    def send_data p_data
      @outbound_data << p_data
      begin
        write_and_schedule(connection)
      rescue DisconnectError => sock
        close_connection
      end
    end

    def invoke_init
      @initialized = true
      @connection_live = true
      @outbound_data = []
      post_init if respond_to?(:post_init)
    end

    def close_connection(sock = nil)
      unbind if respond_to?(:unbind)
      reactor.cancel_write(connection)
      reactor.remove_connection(connection)
    end

    def close_connection_after_writing
      connection.flush unless connection.closed?
      close_connection
    end

    def get_peername
      connection.getpeername
    end

    def send_object p_object
      dump_object(p_object,connection)
    end

    def ask_worker(*args)
      worker_name = args.shift
      data_options = *args
      worker_name_key = gen_worker_key(worker_name,data_options[:job_key])
      data_options[:client_signature] = connection.fileno
      reactor.live_workers[worker_name_key].send_request(data_options)
    end
    def start_server ip,port,t_module,&block
      reactor.start_server(ip,port,t_module,block)
    end
    
    # could have been implemented as delegators, but has been hand implemented for speed
    def start_server *args; reactor.start_server(*args); end
    def connect *args; reactor.connect(*args); end
    def add_periodic_timer *args; reactor.add_periodic_timer(*args); end
    def add_timer *args; reactor.add_timer(*args); end
    def cancel_timer *args; reactor.cancel_timer(*args); end
    def reconnect *args; reactor.reconnect(*args); end
    
    def start_worker *args; reactor.start_worker(*args); end
    def delete_worker *args; reactor.delete_worker(*args); end
  end # end of class Connection
end # end of module Packet


