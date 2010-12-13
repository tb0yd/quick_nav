require File.join(File.dirname(__FILE__), '../../lib/quick_nav/new_display')
require File.join(File.dirname(__FILE__), '../spec_helper.rb')

SAMPLE_TEMPLATE = <<HTML_END
<div class="menu_wrapper_bg">
  <div class="menu_wrapper">
    <ul class="column span-48 menu main_menu">
      <% Data.get_row.each do |item| %>
        <% sym_name, url, opts = *item %>
        <% if Data.get_all_selected.include?(sym_name) %>
          <li id="menu_nav_<%= sym_name %>" class="selected">
            <a class="selected" href="<%= url %>"><%= name %></a>
          </li>
        <% else %>
          <li id="menu_nav_<%= sym_name %>">
            <a href="<%= url %>"><%= name %></a>
          </li>
        <% end %>
      <% end %>
    </ul>
  </div>
</div>
<% Data.get_all_selected.each do |selected| %>
  <div class="sub_menu_wrapper_bg">
    <div class="sub_menu_wrapper">
      <ul class="menu sub_menu">
        <% Data.get_row(selected).each do |item| %>
          <% sym_name, url, opts = *item %>
          <% if Data.get_all_selected.include?(sym_name) %>
            <li id="menu_nav_<%= sym_name %>" class="selected">
              <a class="selected" href="<%= url %>"><%= name %></a>
            </li>
          <% else %>
            <li id="menu_nav_<%= sym_name %>">
              <a href="<%= url %>"><%= name %></a>
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

    @dsl.default_display_method = method(:mock_translation_method)
    @dsl.instance_eval &block
  end

  it "should load an erb template" do
    QuickNav::Data.select_before_setup(:item_1)

    run do
      setup do
        item :item_1, "/home"
        item :item_2, "/help"
      end
    end

    QuickNav::NewDisplay.load_template(SAMPLE_TEMPLATE)
    QuickNav::NewDisplay.nav.should =~ /sub_menu/
  end
end
