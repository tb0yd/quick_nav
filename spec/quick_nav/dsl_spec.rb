require 'quick_nav'
require File.join(File.dirname(__FILE__), '../spec_helper')

describe QuickNav::DSL do
  include QuickNav

  before(:each) do
    @dsl = QuickNav::DSL.new(self)
  end
  
  def run(&block)
    def mock_translation_method(sym)
      sym.to_s.humanize
    end
    @dsl.default_display_method = method(:mock_translation_method)
    @dsl.instance_eval &block
  end

  describe "#setup" do
    it "should understand the omitted option key :display" do
      QuickNav::Data.select_before_setup(:item_1)

      run do
        setup do
          item :item_1, "/home"
          item :item_2, "/help", "Test"
        end
      end

      QuickNav::Data.get_row[1][2][:display].should == "Test"
    end
  end

  describe "#transformation" do
    before(:each) do
      run do
        setup do
          item :item_1, "/home"
        end
      end
    end
 
    describe "#push" do
      it "should understand the omitted option key :display" do
        run do
          transformation do
            push :item_2, "/help", "Test"
          end
        end
  
        QuickNav::Transformations.go!
        QuickNav::Data.get_row[1][2][:display].should == "Test"
      end
    end

    describe "#unshift" do
      it "should add items to the beginning of the nav" do
        run do
          transformation do
            unshift :dashboard, "/dashboard"
          end
        end
        
        QuickNav::Transformations.go!
        QuickNav::Data.get_row.collect { |i| i[0] }.should == [:dashboard, :item_1]
      end

      it "should understand the omitted option key :display" do
        run do
          transformation do
            unshift :item_2, "/help", "Test"
          end
        end
  
        QuickNav::Transformations.go!
        QuickNav::Data.get_row[0][2][:display].should == "Test"
      end
    end

    describe "#update" do
      it "should have an 'update' method for changing nav items' content" do
        run do
          transformation do
            update :item_1, "/home", :display => "Test"
          end
        end
  
        QuickNav::Transformations.go!
        QuickNav::Data.get_row[0][2][:display].should == "Test"
      end
      
      it "should understand the omitted option key :display" do
        run do
          transformation do
            update :item_1, "/help", "Test"
          end
        end
  
        QuickNav::Transformations.go!
        QuickNav::Data.get_row[0][2][:display].should == "Test"
      end
    end
    
    it "should let you define a transformation applied to the menu if a condition is met" do
      signed_in = false

      run do
        transformation do
          if signed_in == true
            push :links, "/links"
          end
        end
      end

      signed_in = true
      QuickNav::Transformations.go!
      QuickNav::Data.get_row.collect { |i| i[0] }.should == [:item_1, :links]
    end

    it "should let you add a sub-menu in a transformation" do
      run do
        transformation do
          update :item_1 do
            push :password, "/password"
          end
        end
      end

      QuickNav::Transformations.go!
      QuickNav::Data.get_row.collect { |i| i[0] }.should == [:item_1]
      QuickNav::Data.get_row(:item_1).collect { |i| i[0] }.should == [ :password ]
    end

    it "should allow multiple subnavs in transformations" do
      run do
        transformation do
          update :item_1 do
            push :privacy_settings, "/privacy" do
              push :email, "/email"
              push :profile, "/profile"
            end
          end
        end
      end

      QuickNav::Transformations.go!
      QuickNav::Data.get_row.collect { |i| i[0] }.should == [:item_1]
      QuickNav::Data.get_row(:item_1).collect { |i| i[0] }.should == [ :privacy_settings ]
      QuickNav::Data.get_row(:privacy_settings).collect { |i| i[0] }.should == [ :email, :profile ]
    end
  end
end
