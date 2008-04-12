PACKET_APP = File.expand_path(File.join(File.dirname(__FILE__) + "/.."))
["lib"].each { |x| $LOAD_PATH.unshift(EVAL_APP_ROOT + "/#{x}")}
require "packet" 
require "rubygems" 
require "test/spec" 
require "mocha" 




