require File.join(File.dirname(__FILE__), '../../lib/quick_nav/display')
require File.join(File.dirname(__FILE__), '../spec_helper.rb')

describe QuickNav::Display do

  describe "#nav" do
    before(:each) do
      run do
        setup do
          item :item_1, "/home"
          item :item_2, "/help"
        end
      end
    end

    it "should load an erb template" do
      QuickNav::Display.select(:item_1)
      nav_html = <<-HTML_END
      <div class="menu_wrapper_bg">
        <div class="menu_wrapper">
          <ul class="column span-48 menu main_menu">
            <li id="menu_nav_item_1" class="selected">
              <a class="selected" href="/home">Item 1</a>
            </li>
            <li id="menu_nav_item_2">
              <a href="/help">Item 2</a>
            </li>
          </ul>
        </div>
      </div>
      HTML_END
      QuickNav::Display.nav.should roughly_match(nav_html)
    end

    it "should display the base nav with no item selected" do
      nav_html = <<-HTML_END
      <div class="menu_wrapper_bg">
        <div class="menu_wrapper">
          <ul class="column span-48 menu main_menu">
            <li id="menu_nav_item_1">
              <a href="/home">Item 1</a>
            </li>
            <li id="menu_nav_item_2">
              <a href="/help">Item 2</a>
            </li>
          </ul>
        </div>
      </div>
      HTML_END
      QuickNav::Display.nav.should roughly_match(nav_html)
    end
  end

  describe "#select" do
    before(:each) do
      QuickNav::Display.select(:item_1)
    end

    # the logic here is that the nav will only be rendered once per controller action.
    it "should reset the selected node to nil" do
      QuickNav::Display.selected.should == :item_1
      QuickNav::Display.nav
      QuickNav::Display.selected.should be_nil
    end
  end

  describe "#default_translation_method" do
    it "should allow the user to set" do
      def y(s); "test123" end
      QuickNav::Display.default_translation_method = method(:y)
      QuickNav::Display.nav.include?("test123").should be_true
    end
  end
end
