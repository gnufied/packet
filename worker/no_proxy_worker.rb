class NoProxyWorker < Packet::Worker
  set_worker_name :no_proxy_worker
  #set_no_auto_load(true)
  def worker_init
    p "Starting no proxy worker"
  end

  def receive_data data_obj
    eval_data = eval(data_obj[:data])
    data_obj[:data] = eval_data
    data_obj[:type] = :response
    send_data(data_obj)
  end
end
