require File.join(File.dirname(__FILE__), '../../lib/quick_nav/display')
require File.join(File.dirname(__FILE__), '../spec_helper.rb')

describe QuickNav::Display do

  before(:each) do
    @dsl = QuickNav::DSL.new(self)
  end

  def run(&block)
    def mock_translation_method(sym)
      sym.to_s.humanize
    end

    QuickNav::Display.default_method = method(:mock_translation_method)
    @dsl.instance_eval &block
  end

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

    QuickNav::Data.select_before_setup(:item_1)

    run do
      setup do
        item :item_1, "/home"
        item :item_2, "/help"
      end
    end

    QuickNav::Display.load_template(SAMPLE_TEMPLATE)
    QuickNav::Display.nav.split(/>\s+</).join("><").strip.should ==
                    nav_html.split(/>\s+</).join("><").strip
  end
end