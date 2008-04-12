class ProxyClient
  def recieve_data data

  end

  def connection_completed
    if @reconnect_timer
      cancel_timer(@reconnect_timer)
      @reconnect_timer = nil
    end
  end

  def unbind
    @reconnect_timer = add_timer(10) { attempt_reconnection }
  end

  def attempt_reconnection
    reconnect("localhost",port,self)
  end
end
