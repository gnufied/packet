require File.join(File.dirname(__FILE__) + "/spec_helper")

context "Packet Core in general when mixed inside a class" do
  xspecify "allow the class to act as a reactor" do
  end

  xspecify "should start a server on specified port" do
  end

  xspecify "should let clients connect to the server" do
  end

  xspecify "should be able to connect to external servers" do
  end

  xspecify "should be able to read data from clients when socket is ready" do
  end

  xspecify "should be able to write data to clients when socket is ready for write" do
  end

  xspecify "should invoke receive_data method data is receieved from clients" do
  end

  xspecify "should invoke post_init when client connects" do
  end

  xspecify "should invoke unbind when a client disconnects" do
  end

  xspecify "should invoke connection_completed when connection to external server is connected." do
  end

  xspecify "should check for ready timers on each iteration" do
  end

  xspecify "should run proper timer on each iteration." do
  end
end
