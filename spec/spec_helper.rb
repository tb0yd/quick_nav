require 'quick_nav'
require 'rspec'
require 'active_support/inflector'
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.before(:all) do
    @dsl = QuickNav::DSL.new(self)
    QuickNav::Display.load_template(SAMPLE_TEMPLATE)
  end
end

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

def run(&block)
  def mock_translation_method(sym)
    sym.to_s.humanize
  end

  QuickNav::Display.default_translation_method = method(:mock_translation_method)
  @dsl.instance_eval &block
end
