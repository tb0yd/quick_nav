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
  
  describe "#node_with_url" do
    it "should should return the correct node" do
      Data.push(:settings, "/settings")
      Data.push(:help, "/help")
      Data.node_with_url("/help").should == :help
    end
  end
  
  describe "#get_all_selected" do
    before(:each) do
      Data.select_before_setup :settings2a
      Data.push(:settings, "/settings")
      Data.push(:settings1, "/settings1", :parent => :settings)
      Data.push(:settings2, "/settings2", :parent => :settings)
      Data.push(:settings2a, "/settings2a", :parent => :settings2)
      Data.push(:help, "/help")
    end
    
    it "should return the selected node" do
      Data.get_all_selected.include?(:settings2a).should == true
    end
    
    it "should return all parents" do
      Data.get_all_selected.include?(:settings2).should == true
      Data.get_all_selected.include?(:settings).should == true
      Data.get_all_selected.size.should == 3
    end
    
    it "should return them in order" do
      Data.get_all_selected.include?(:settings2).should == true
      Data.get_all_selected.include?(:settings).should == true
    end
  end
end