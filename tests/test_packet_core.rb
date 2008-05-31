require File.join(File.dirname(__FILE__),"spec_helper")

context "For Packet Core" do 
  setup do 
    class Foo
      include Packet::Core
    end
  end
  
  specify "should implement after_connection callback working" do
    Foo.respond_to?(:after_connection).should == true
    Foo.respond_to?(:after_unbind).should == true
    Foo.respond_to?(:before_unbind).should == true
  end
  
  specify "accept connection should invoke corresponding callback" do
    a = Foo.new
    p a.connection_callbacks
    socket_obj = mock()
    client_socket = mock()
    socket_obj.stubs(:accept_nonblock).returns(client_socket)
    client_socket.stubs(:setsockopt).returns(true)
    module_obj = mock()
    
    sock_opts = {:socket => socket_obj,:module => module_obj}
    a.accept_connection(sock_opts)
  end
end

