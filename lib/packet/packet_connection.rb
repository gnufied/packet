# FIMXE: following class must modify the fd_watchlist thats being monitored by
# main eventloop.

module Packet
  module Connection
    attr_accessor :outbound_data,:connection_live

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
      connection.flush
      close_connection
    end

    def send_object p_object
      dump_object(p_object,connection)
    end

  end # end of class Connection
end # end of module Packet
