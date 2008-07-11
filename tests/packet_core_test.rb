require File.join(File.dirname(__FILE__),"spec_helper")

context "For Packet Core using classes" do
  setup do
    class Foo
      include Packet::Core
    end
    class Bar
      include Packet::Core
      after_connection :say_hello
    end

    class ConnectionObj; end
  end

  specify "should implement after_connection callback working" do
    Foo.respond_to?(:after_connection).should == true
    Foo.respond_to?(:after_unbind).should == true
    Foo.respond_to?(:before_unbind).should == true
  end

  specify "accept connection should not inherit callbacks" do
    a = Foo.new
    a.connection_callbacks.should.be {}
    socket_obj = mock()
    client_socket = mock()
    socket_obj.expects(:accept_nonblock).returns(client_socket)
    client_socket.expects(:setsockopt).returns(true)
    client_socket.expects(:fileno).returns(10)

    sock_opts = {:socket => socket_obj,:module => ConnectionObj}
    a.accept_connection(sock_opts)
  end

  specify "accept_connection should invoke correspoding callbacks" do
    a = Bar.new
    a.expects(:say_hello).returns(true)
    socket_obj = mock()
    client_socket = mock()
    socket_obj.expects(:accept_nonblock).returns(client_socket)
    client_socket.expects(:setsockopt).returns(true)
    client_socket.expects(:fileno).returns(10)

    sock_opts = {:socket => socket_obj,:module => ConnectionObj}
    a.accept_connection(sock_opts)
  end

  specify "accept_connection should implement methods from Connection module" do
    a = Bar.new
    a.expects(:say_hello).returns(true)
    socket_obj = mock()
    client_socket = mock()
    socket_obj.expects(:accept_nonblock).returns(client_socket)
    client_socket.expects(:setsockopt).returns(true)
    client_socket.expects(:fileno).returns(10)

    sock_opts = {:socket => socket_obj,:module => ConnectionObj}
    d = a.accept_connection(sock_opts)
    d.respond_to?(:connection_completed).should == true
    d.respond_to?(:post_init).should == true
    d.respond_to?(:unbind).should == true
    d.respond_to?(:receive_data).should == true
    d.respond_to?(:connect).should == true
    d.respond_to?(:add_periodic_timer).should == true
    d.respond_to?(:add_timer).should == true
  end

  specify "start server should register the handle" do
    a = Foo.new
    client_connection = stub(:receive_data => "wow")
    a.start_server("localhost",11000,client_connection)
    a.listen_sockets.should.not.be.empty
    a.read_ios.should.not.be.empty
    fileno = (a.read_ios[0]).fileno
    a.listen_sockets[fileno][:module].should == client_connection
  end

  specify "for normal connect" do
    a = Foo.new
    client_connection = stub(:receive_data => "wow")
    a.connect("localhost",8765,client_connection)
    a.connection_completion_awaited.should.not.be.empty
    sock_fd = a.connection_completion_awaited.keys[0]
    a.write_ios[0].fileno == sock_fd
  end

  specify "for an external connection thats immediately completed" do
    a = Foo.new
    client_connection = stub(:receive_data => "wow")
    a.connect("localhost",8765,client_connection)
    a.connection_completion_awaited.should.not.be.empty
    sock_fd = a.connection_completion_awaited.keys[0]
    a.write_ios[0].fileno == sock_fd
  end

  specify "reconnect for a diconnected client should attempt reconnection" do

  end

  specify "for a connected connection socket fd should be there in read watchlist" do

  end

  specify "for removing an active connection socket fd should deleted from read/write watchlist" do

  end
end

context "Packet Core using modules" do
  setup do
    class Foo
      include Packet::Core
    end
    module DummyConnection
      def unbind; "unbind"; end
    end
  end

  specify "accept_connection should initialize a class instance from the supplied module" do
    a = Foo.new
    a.connection_callbacks.should.be {}
    socket_obj = mock()
    client_socket = mock()
    socket_obj.expects(:accept_nonblock).returns(client_socket)
    client_socket.expects(:setsockopt).returns(true)
    client_socket.expects(:fileno).returns(10)

    sock_opts = {:socket => socket_obj,:module => DummyConnection}
    d = a.accept_connection(sock_opts)
    d.unbind.should == "unbind"
  end
end

context "Receive in packet" do
  setup do
    class Foo
      include Packet::Core
    end
    module DummyConnection
    end
  end

  specify "should invoke internal data callback for data read from unix socket" do
    a = Foo.new
  end

  specify "should invoke external data callback for data read from tcp socket" do

  end
end

context "Write in Packet" do
  specify "should watch the socket fd if write is not complete" do

  end

  specify "fd watch should work for both unix and tcp socket" do

  end
end







