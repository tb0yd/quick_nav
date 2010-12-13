require File.join(File.dirname(__FILE__), '../../lib/quick_nav/display')
require File.join(File.dirname(__FILE__), '../spec_helper.rb')

describe QuickNav::Display do
  it "should load an erb template" do
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

    QuickNav::Display.select(:item_1)

    run do
      setup do
        item :item_1, "/home"
        item :item_2, "/help"
      end
    end

    QuickNav::Display.load_template(SAMPLE_TEMPLATE)
    QuickNav::Display.nav.should roughly_match(nav_html)
  end

  describe "#selected" do
    it "should return the selected node" do
      QuickNav::Display.select(:item_1)
      QuickNav::Display.selected.should == :item_1
    end
  end

  describe "#reset" do
    it "should reset the selected node to nil" do
      QuickNav::Display.select(:item_1)
      QuickNav::Display.reset
      QuickNav::Display.selected.should be_nil
    end
  end
end
