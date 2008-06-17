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

context "Behaviour of receive in packet" do
  setup do
    class Foo
      include Packet::Core
    end
    module DummyConnection
    end
  end

  specify "should invoke internal data callback for data read from unix socket" do

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







