require 'quick_nav'
require File.join(File.dirname(__FILE__), '../spec_helper')

describe QuickNav::Sugar do
  include QuickNav

  before(:each) do
    @sugar = QuickNav::Sugar.new(self)
  end
  
  def run(&block)
    def mock_translation_method(sym)
      sym.to_s.humanize
    end
    @sugar.default_display_method = method(:mock_translation_method)
    @sugar.instance_eval &block
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
    describe "#push" do
      it "should understand the omitted option key :display" do
        QuickNav::Data.select_before_setup(:item_1)
  
        run do
          setup do
            item :item_1, "/home"
          end
          transformation do
            push :item_2, "/help", "Test"
          end
        end
  
        QuickNav::Transformations.go!
        QuickNav::Data.get_row[1][2][:display].should == "Test"
      end
    end

    describe "#unshift" do
      it "should understand the omitted option key :display" do
        QuickNav::Data.select_before_setup(:item_1)
  
        run do
          setup do
            item :item_1, "/home"
          end
          transformation do
            unshift :item_2, "/help", "Test"
          end
        end
  
        QuickNav::Transformations.go!
        QuickNav::Data.get_row[0][2][:display].should == "Test"
      end
    end

    describe "#update" do
      it "should understand the omitted option key :display" do
        QuickNav::Data.select_before_setup(:item_1)
  
        run do
          setup do
            item :item_1, "/home"
          end
          transformation do
            update :item_1, "/help", "Test"
          end
        end
  
        QuickNav::Transformations.go!
        QuickNav::Data.get_row[0][2][:display].should == "Test"
      end
    end
  end
end
