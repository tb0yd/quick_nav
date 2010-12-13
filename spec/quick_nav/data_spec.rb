require 'quick_nav'

describe QuickNav::Data do
  include QuickNav

  before(:each) do
    QuickNav::Data::init_all
  end
  
  describe "#push" do
    it "should raise an error if given <2 arguments" do
      lambda { QuickNav::Data.push(:settings) }.should raise_error
      lambda { QuickNav::Data.push }.should raise_error
    end
    
    it "should raise an error if given <2 arguments and a hash" do
      lambda { QuickNav::Data.push(:settings, {:parent => "parent"}) }.should raise_error
      lambda { QuickNav::Data.push({:parent => "parent"}) }.should raise_error
    end
    
    it "should allow you to choose where to put it in the list" do
      QuickNav::Data.select :settings
      QuickNav::Data.push(:settings, "/settings")
      QuickNav::Data.push(:help, "/help")
      QuickNav::Data.push(:logout, "/logout", :after => :settings)

      QuickNav::Data.get_row[1][0].should == :logout
    end
  end

  describe "#update" do
    it "should not reset the options if you don't provide any" do
      QuickNav::Data.select :settings
      QuickNav::Data.push(:settings, "/settings", :display => "Test")
      QuickNav::Data.update(:settings)
      QuickNav::Data.get_row[0][1].should == "/settings"
      QuickNav::Data.get_row[0][2].should == {:display => "Test"}
    end
  end
  
  describe "#unshift" do
    it "should raise an error if given <2 arguments" do
      lambda { QuickNav::Data.unshift(:settings) }.should raise_error
      lambda { QuickNav::Data.unshift }.should raise_error
    end
    
    it "should raise an error if given <2 arguments and a hash" do
      lambda { QuickNav::Data.unshift(:settings, {:parent => "parent"}) }.should raise_error
      lambda { QuickNav::Data.unshift({:parent => "parent"}) }.should raise_error
    end
  end
  
  describe "#get_selected" do
    it "should return the selected node info that was provided" do
      QuickNav::Data.select :settings2a
      QuickNav::Data.get_selected.should == :settings2a
    end
  end
  
  describe "#get_all_selected" do
    describe "given a symbol" do
      before(:each) do
        QuickNav::Data.select :settings2a
        QuickNav::Data.push(:settings, "/settings")
        QuickNav::Data.push(:settings1, "/settings1", :parent => :settings)
        QuickNav::Data.push(:settings2, "/settings2", :parent => :settings)
        QuickNav::Data.push(:settings2a, "/settings2a", :parent => :settings2)
        QuickNav::Data.push(:help, "/help")
      end
      
      it "should return the selected node" do
        QuickNav::Data.get_all_selected.include?(:settings2a).should == true
      end
      
      it "should return all parents" do
        QuickNav::Data.get_all_selected.include?(:settings2).should == true
        QuickNav::Data.get_all_selected.include?(:settings).should == true
        QuickNav::Data.get_all_selected.size.should == 3
      end
      
      it "should return them in order" do
        QuickNav::Data.get_all_selected.first.should == :settings
        QuickNav::Data.get_all_selected.last.should == :settings2a
      end
    end
    
    describe "given a url string" do
      before(:each) do
        QuickNav::Data.select "/settings2a"
        QuickNav::Data.push(:settings, "/settings")
        QuickNav::Data.push(:settings1, "/settings1", :parent => :settings)
        QuickNav::Data.push(:settings2, "/settings2", :parent => :settings)
        QuickNav::Data.push(:settings2a, "/settings2a", :parent => :settings2)
        QuickNav::Data.push(:help, "/help")
      end
      
      it "should return the selected node" do
        QuickNav::Data.get_all_selected.include?(:settings2a).should == true
      end
      
      it "should return all parents" do
        QuickNav::Data.get_all_selected.include?(:settings2).should == true
        QuickNav::Data.get_all_selected.include?(:settings).should == true
        QuickNav::Data.get_all_selected.size.should == 3
      end
      
      it "should return them in order" do
        QuickNav::Data.get_all_selected.first.should == :settings
        QuickNav::Data.get_all_selected.last.should == :settings2a
      end
    end
  end
  
  describe "#reset" do
    it "should reset all class variables used" do
      QuickNav::Data.select "/settings2a"
      QuickNav::Data.push(:settings, "/settings")
      QuickNav::Data.push(:settings1, "/settings1", :parent => :settings)
      QuickNav::Data.push(:settings2, "/settings2", :parent => :settings)
      QuickNav::Data.push(:settings2a, "/settings2a", :parent => :settings2)
      QuickNav::Data.push(:help, "/help")
      
      QuickNav::Data.reset
      
      QuickNav::Data.get_selected.should be_nil
      QuickNav::Data.get_all_selected.should be_empty
      QuickNav::Data.get_row.should be_empty
    end
  end
end