module Packet
  class InvalidWorker < RuntimeError
    attr_accessor :worker_name
    def initialize worker_name
      @worker_name = worker_name
    end
  end
end
