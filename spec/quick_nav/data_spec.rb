require 'quick_nav'

describe QuickNav::Data do
  include QuickNav
  
  before(:each) do
    Data::init_all
  end
  
  describe "#push" do
    it "should raise an error if given <2 arguments" do
      lambda { Data.push(:settings) }.should raise_error
      lambda { Data.push }.should raise_error
    end
    
    it "should raise an error if given <2 arguments and a hash" do
      lambda { Data.push(:settings, {:parent => "parent"}) }.should raise_error
      lambda { Data.push({:parent => "parent"}) }.should raise_error
    end
  end
  
  describe "#unshift" do
    it "should raise an error if given <2 arguments" do
      lambda { Data.unshift(:settings) }.should raise_error
      lambda { Data.unshift }.should raise_error
    end
    
    it "should raise an error if given <2 arguments and a hash" do
      lambda { Data.unshift(:settings, {:parent => "parent"}) }.should raise_error
      lambda { Data.unshift({:parent => "parent"}) }.should raise_error
    end
  end
end