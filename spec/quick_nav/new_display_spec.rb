require File.join(File.dirname(__FILE__), '../../lib/quick_nav/new_display')
require File.join(File.dirname(__FILE__), '../spec_helper.rb')

SAMPLE_TEMPLATE = <<HTML_END
<div class="menu_wrapper_bg">
  <div class="menu_wrapper">
    <ul class="column span-48 menu main_menu">
      <% main_menu do |code_name, word_name, url, selected| %>
        <% if selected %>
          <li id="menu_nav_<%= code_name %>" class="selected">
            <a class="selected" href="<%= url %>"><%= word_name %></a>
          </li>
        <% else %>
          <li id="menu_nav_<%= code_name %>">
            <a href="<%= url %>"><%= word_name %></a>
          </li>
        <% end %>
      <% end %>
    </ul>
  </div>
</div>
<% sub_menus do |item| %>
    <div class="sub_menu_wrapper_bg">
      <div class="sub_menu_wrapper">
        <ul class="menu sub_menu">
          <% each_row_in item do |code_name, word_name, url, selected| %>
            <% if selected %>
              <li id="menu_nav_<%= code_name %>" class="selected">
                <a class="selected" href="<%= url %>"><%= word_name %></a>
              </li>
            <% else %>
              <li id="menu_nav_<%= code_name %>">
                <a href="<%= url %>"><%= word_name %></a>
              </li>
            <% end %>
          <% end %>
        </ul>
      </div>
    </div>
<% end %>
HTML_END

describe QuickNav::NewDisplay do
  
  before(:each) do
    @dsl = QuickNav::DSL.new(self)
  end

  def run(&block)
    def mock_translation_method(sym)
      sym.to_s.humanize
    end

    QuickNav::NewDisplay.default_method = method(:mock_translation_method)
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

    QuickNav::NewDisplay.load_template(SAMPLE_TEMPLATE)
    QuickNav::NewDisplay.nav.split(/>\s+</).join("><").strip.should == 
                    nav_html.split(/>\s+</).join("><").strip
  end
end
