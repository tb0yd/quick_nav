$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'quick_nav'
require 'rspec'

Spec::Runner.configure do |config|
  
end
