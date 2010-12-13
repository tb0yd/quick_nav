require File.join(File.dirname(__FILE__), '../../lib/quick_nav/new_display')
require File.join(File.dirname(__FILE__), '../spec_helper.rb')

describe QuickNav::NewDisplay do
  it "should load an erb template" do
    QuickNav::NewDisplay.load_template("<%= 2 + 2 %>")
    QuickNav::NewDisplay.nav.should =~ /4/
  end
end