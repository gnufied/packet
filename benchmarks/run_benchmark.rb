require "socket"

threads = []
500.times do
  threads << Thread.new do
    sock = TCPSocket.open("localhost",11006)
    100.times do
      sock.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1)
      sock.puts("Hello World")
      sock.gets
    end
  end
end

threads.each { |thr| thr.join }


=begin
 with packet:
real    0m14.973s
user    0m10.805s
sys     0m3.404s

With EM:

real    0m11.105s
user    0m8.253s
sys     0m2.780s


== With 500 sockets each posting 10000 requests
with packet:

real    25m15.002s
user    21m37.621s
sys     2m49.967s

with EM

real    25m6.502s
user    21m46.370s
sys     2m48.983s

=end
