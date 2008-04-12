APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__) + "/.."))
["lib"].each { |x| $LOAD_PATH.unshift(APP_ROOT + "/#{x}")}
require "packet"
require "rubygems" 
require "mocha" 
