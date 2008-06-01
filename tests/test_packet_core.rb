require File.join(File.dirname(__FILE__),"spec_helper")

context "For Packet Core" do 
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
end

