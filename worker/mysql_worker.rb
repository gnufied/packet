class MysqlWorker < Packet::Worker
  set_worker_name :mysql_worker
  set_no_auto_load(true)
  def worker_init
    p "***************** : starting mysql worker"
  end

  # this is the place where a query will be received.
  def receive_data data_ob

  end
end

