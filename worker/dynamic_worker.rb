class DynamicWorker < Packet::Worker
  set_worker_name :dynamic_worker
  set_no_auto_load true
  def worker_init
    p "Starting dynamic worker"
    p worker_options
  end

  def receive_data data_obj
    eval_data = eval(data_obj[:data])
    data_obj[:data] = eval_data
    data_obj[:type] = :response
    send_data(data_obj)
  end
end
