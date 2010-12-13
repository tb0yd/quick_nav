require File.join(File.dirname(__FILE__), '../../lib/quick_nav/display')
require File.join(File.dirname(__FILE__), '../spec_helper.rb')

describe QuickNav::Display do
NAV_HTML = <<-HTML_END
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

  describe "#nav" do
    before(:each) do
      QuickNav::Display.select(:item_1)
      run do
        setup do
          item :item_1, "/home"
          item :item_2, "/help"
        end
      end
    end

    it "should load an erb template" do
      QuickNav::Display.load_template(SAMPLE_TEMPLATE)
      QuickNav::Display.nav.should roughly_match(NAV_HTML)
    end

    # the logic here is that the nav will only be rendered once per controller action.
    it "should reset the selected node to nil" do
      QuickNav::Display.selected.should == :item_1
      QuickNav::Display.nav
      QuickNav::Display.selected.should be_nil
    end
  end
end
