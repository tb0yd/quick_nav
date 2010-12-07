require 'quick_nav'

describe QuickNav do
  
  before(:each) do
    @sugar = QuickNav::Sugar.new(self)
  end

  def run(&block)
    @sugar.instance_eval &block
  end

  describe "#render_navigation_stuf" do
    it "should generate nav html based on a hash it already knows" do
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

      QuickNav::Display.nav.should == nav_html.split(/>\s+</).join("><").strip
    end

    it "should make the selected item have the selected template" do
      nav_html = <<-HTML_END
<div class="menu_wrapper_bg">
  <div class="menu_wrapper">
    <ul class="column span-48 menu main_menu">
      <li id="menu_nav_item_1">
        <a href="/home">Item 1</a>
      </li>
      <li id="menu_nav_item_2" class="selected">
        <a class="selected" href="/help">Item 2</a>
      </li>
    </ul>
  </div>
</div>
HTML_END

      QuickNav::Data.select_before_setup(:item_2)

      run do
        setup do
          item :item_1, "/home"
          item :item_2, "/help"
        end
      end

      QuickNav::Display.nav.should == nav_html.split(/>\s+</).join("><").strip
    end

    it "should QuickNav::Display the items in the order they were written in" do
      nav_html = <<-HTML_END
<div class="menu_wrapper_bg">
  <div class="menu_wrapper">
    <ul class="column span-48 menu main_menu">
      <li id="menu_nav_item_2" class="selected">
        <a class="selected" href="/help">Item 2</a>
      </li>
      <li id="menu_nav_item_4">
        <a href="/email">Item 4</a>
      </li>
      <li id="menu_nav_item_3">
        <a href="/support">Item 3</a>
      </li>
      <li id="menu_nav_item_1">
        <a href="/home">Item 1</a>
      </li>
    </ul>
  </div>
</div>
HTML_END

      QuickNav::Data.select_before_setup(:item_2)

      run do
        setup do
          item :item_2, "/help"
          item :item_4, "/email"
          item :item_3, "/support"
          item :item_1, "/home"
        end
      end

      QuickNav::Display.nav.should == nav_html.split(/>\s+</).join("><").strip
    end

    it "should allow you to specify your own item QuickNav::Display name" do
      nav_html = <<-HTML_END
<div class="menu_wrapper_bg">
  <div class="menu_wrapper">
    <ul class="column span-48 menu main_menu">
      <li id="menu_nav_item_2" class="selected">
        <a class="selected" href="/help">Item 2</a>
      </li>
      <li id="menu_nav_item_4">
        <a href="/email">Email</a>
      </li>
      <li id="menu_nav_item_3">
        <a href="/support">Item 3</a>
      </li>
      <li id="menu_nav_item_1">
        <a href="/home">Item 1</a>
      </li>
    </ul>
  </div>
</div>
HTML_END

      QuickNav::Data.select_before_setup(:item_2)

      run do
        setup do
          item :item_2, "/help"
          item :item_4, "/email", :display => "Email"
          item :item_3, "/support"
          item :item_1, "/home"
        end
      end

      QuickNav::Display.nav.should == nav_html.split(/>\s+</).join("><").strip
    end

    it "should render the parents of the selected node as selected" do
      nav_html = <<-HTML_END
<div class="menu_wrapper_bg">
  <div class="menu_wrapper">
    <ul class="column span-48 menu main_menu">
      <li id="menu_nav_item_1" class="selected">
        <a class="selected" href="/home">Item 1</a>
      </li>
      <li id="menu_nav_item_4">
        <a href="/email">Email</a>
      </li>
      <li id="menu_nav_item_3">
        <a href="/support">Item 3</a>
      </li>
    </ul>
  </div>
</div>
<div class="sub_menu_wrapper_bg">
  <div class="sub_menu_wrapper">
    <ul class="menu sub_menu">
      <li id="menu_nav_settings" class="selected">
        <a class="selected" href="/settings">Settings</a>
      </li>
      <li id="menu_nav_sign_out">
        <a href="/sign_out">Sign out</a>
      </li>
    </ul>
  </div>
</div>
HTML_END

      QuickNav::Data.select_before_setup(:settings)

      run do
        setup do
          item :item_1, "/home" do
            item :settings, "/settings"
            item :sign_out, "/sign_out"
          end
          item :item_4, "/email", :display => "Email"
          item :item_3, "/support"
        end
      end

      QuickNav::Display.nav.should == nav_html.split(/>\s+</).join("><").strip
    end
      
    it "should not render the children of the selected node as selected" do
      nav_html = <<-HTML_END
<div class="menu_wrapper_bg">
  <div class="menu_wrapper">
    <ul class="column span-48 menu main_menu">
      <li id="menu_nav_item_1" class="selected">
        <a class="selected" href="/home">Item 1</a>
      </li>
      <li id="menu_nav_item_4">
        <a href="/email">Email</a>
      </li>
      <li id="menu_nav_item_3">
        <a href="/support">Item 3</a>
      </li>
    </ul>
  </div>
</div>
<div class="sub_menu_wrapper_bg">
  <div class="sub_menu_wrapper">
    <ul class="menu sub_menu">
      <li id="menu_nav_settings">
        <a href="/settings">Settings</a>
      </li>
      <li id="menu_nav_sign_out">
        <a href="/sign_out">Sign out</a>
      </li>
    </ul>
  </div>
</div>
HTML_END

      QuickNav::Data.select_before_setup(:item_1)

      run do
        setup do
          item :item_1, "/home" do
            item :settings, "/settings"
            item :sign_out, "/sign_out"
          end
          item :item_4, "/email", :display => "Email"
          item :item_3, "/support"
        end
      end

      QuickNav::Display.nav.should == nav_html.split(/>\s+</).join("><").strip
    end
  end

  describe "#transform" do
    it "should transform the menu from signed out to signed in" do
      QuickNav::Data.select_before_setup :search_careers

      run do
        setup do
          item :careers, "/search_occupations" do
            item :search_careers, "/search_occupations", :display => "Careers"
            item :search_industries, "/industries", :display =>  "Industries"
          end
          item :communities, "/communities"
          item :js_advice, "/js_resources", :display => "Career Advice"
          item :em_advice, "/em_resources", :display => "Employer Advice"
          item :ed_advice, "/ed_resources", :display => "Educator Advice"
          item :search, "/search_job_posts", :display => "Advanced Search"
        end
      end

      # transform :signed_in
      QuickNav::Data.add(:connections, "/connections")
      QuickNav::Data.add(:inbox, "/messages")
      QuickNav::Data.add(:portfolio, "/new_portfolio_setup")
      QuickNav::Data.add(:dashboard, "/dashboard")
      QuickNav::Data.rm(:js_advice)
      QuickNav::Data.rm(:em_advice)
      QuickNav::Data.rm(:ed_advice)

      QuickNav::Data.get_row.collect { |i| i[0] }.should == [:careers, :communities, :search, :connections, :inbox, :portfolio, :dashboard]
    end
  end

  describe "#transformation" do
    it "should let you define a transformation applied to the menu if a condition is met" do
      nav_html = <<-HTML_END
<div class="menu_wrapper_bg">
  <div class="menu_wrapper">
    <ul class="column span-48 menu main_menu">
      <li id="menu_nav_careers" class="selected">
        <a class="selected" href="/search_occupations">Careers</a>
      </li>
      <li id="menu_nav_communities">
        <a href="/communities">Communities</a>
      </li>
      <li id="menu_nav_search">
        <a href="/search_job_posts">Advanced Search</a>
      </li>
      <li id="menu_nav_connections">
        <a href="/connections">Connections</a>
      </li>
      <li id="menu_nav_inbox">
        <a href="/messages">Inbox</a>
      </li>
      <li id="menu_nav_portfolio">
        <a href="/new_portfolio_setup">Portfolio</a>
      </li>
      <li id="menu_nav_dashboard">
        <a href="/dashboard">Dashboard</a>
      </li>
    </ul>
  </div>
</div>
<div class="sub_menu_wrapper_bg">
  <div class="sub_menu_wrapper">
    <ul class="menu sub_menu">
      <li id="menu_nav_search_careers" class="selected">
        <a class="selected" href="/search_occupations">Careers</a>
      </li>
      <li id="menu_nav_search_industries">
        <a href="/industries">Industries</a>
      </li>
    </ul>
  </div>
</div>
HTML_END

      signed_in = false

      run do
        transformation do
          if signed_in == true
            add :connections, "/connections"
            add :inbox, "/messages"
            add :portfolio, "/new_portfolio_setup"
            add :dashboard, "/dashboard"
            rm :js_advice
            rm :em_advice
            rm :ed_advice
          end
        end

        QuickNav::Data.select_before_setup :search_careers

        setup do
          item :careers, "/search_occupations" do
            item :search_careers, "/search_occupations", :display => "Careers"
            item :search_industries, "/industries", :display =>  "Industries"
          end
          item :communities, "/communities"
          item :js_advice, "/js_resources", :display => "Career Advice"
          item :em_advice, "/em_resources", :display => "Employer Advice"
          item :ed_advice, "/ed_resources", :display => "Educator Advice"
          item :search, "/search_job_posts", :display => "Advanced Search"
        end
      end

      signed_in = true
      QuickNav::Transformations.go!
      QuickNav::Display.nav.should == nav_html.split(/>\s+</).join("><").strip
    end
  end
end
