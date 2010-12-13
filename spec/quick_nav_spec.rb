require 'quick_nav'
require File.join(File.dirname(__FILE__), 'spec_helper')

describe QuickNav do
  before(:each) do
    QuickNav::Display.load_template(SAMPLE_TEMPLATE)
  end

  describe "#nav" do
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

      QuickNav::Display.select(:item_2)

      run do
        setup do
          item :item_1, "/home"
          item :item_2, "/help"
        end
      end

      QuickNav::Display.nav.should roughly_match(nav_html)
    end

    it "should allow you to select by URL" do
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

      QuickNav::Display.select("/help")

      run do
        setup do
          item :item_1, "/home"
          item :item_2, "/help"
        end
      end

      QuickNav::Display.nav.should roughly_match(nav_html)
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

      QuickNav::Display.select(:item_2)

      run do
        setup do
          item :item_2, "/help"
          item :item_4, "/email"
          item :item_3, "/support"
          item :item_1, "/home"
        end
      end

      QuickNav::Display.nav.should roughly_match(nav_html)
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

      QuickNav::Display.select(:item_2)

      run do
        setup do
          item :item_2, "/help"
          item :item_4, "/email", :display => "Email"
          item :item_3, "/support"
          item :item_1, "/home"
        end
      end

      QuickNav::Display.nav.should roughly_match(nav_html)
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

      QuickNav::Display.select(:settings)

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

      QuickNav::Display.nav.should roughly_match(nav_html)
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

      QuickNav::Display.select(:item_1)

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

      QuickNav::Data.get_row.collect { |i| i[0] }.should == [:item_1, :item_4, :item_3]
      QuickNav::Data.get_row(:item_1).collect { |i| i[0] }.should == [:settings, :sign_out]
      QuickNav::Data.ancestors_for(:item_1).include?(:item_1).should be_true
      QuickNav::Data.ancestors_for(:item_1).include?(:settings).should_not be_true

      QuickNav::Display.nav.should roughly_match(nav_html)
    end
  end

  describe "#setup" do
    it "should behave as expected with realistic input" do
      QuickNav::Display.select :search_careers

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
      QuickNav::Data.push(:connections, "/connections")
      QuickNav::Data.push(:inbox, "/messages")
      QuickNav::Data.push(:portfolio, "/new_portfolio_setup")
      QuickNav::Data.push(:dashboard, "/dashboard")
      QuickNav::Data.rm(:js_advice)
      QuickNav::Data.rm(:em_advice)
      QuickNav::Data.rm(:ed_advice)

      QuickNav::Data.get_row.collect { |i| i[0] }.should == [:careers, :communities, :search, :connections, :inbox, :portfolio, :dashboard]
    end
  end

  describe "#transformation" do
    it "should let you define a transformation applied to the menu if a condition is met" do
      signed_in = false

      run do
        transformation do
          if signed_in == true
            push :connections, "/connections"
            push :inbox, "/messages"
            push :portfolio, "/new_portfolio_setup"
            push :dashboard, "/dashboard"
            rm :js_advice
            rm :em_advice
            rm :ed_advice
          end
        end

        QuickNav::Display.select :search_careers

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
      QuickNav::Data.get_row.collect { |i| i[0] }.should == [:careers, :communities, :search, :connections, :inbox, :portfolio, :dashboard]
      QuickNav::Data.get_row(:careers).collect { |i| i[0] }.should == [:search_careers, :search_industries]
      QuickNav::Data.ancestors_for(:search_careers).include?(:careers).should be_true
      QuickNav::Data.ancestors_for(:search_careers).include?(:search_careers).should be_true
      QuickNav::Data.ancestors_for(:search_careers).include?(:search_industries).should_not be_true
    end

    it "should have an 'unshift' method for adding items to the beginning of the nav" do
      run do
        transformation do
          push :connections, "/connections"
          push :inbox, "/messages"
          push :portfolio, "/new_portfolio_setup"
          unshift :dashboard, "/dashboard"
          rm :js_advice
          rm :em_advice
          rm :ed_advice
        end

        QuickNav::Display.select :search_careers

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

      QuickNav::Transformations.go!
      QuickNav::Data.get_row.collect { |i| i[0] }.should == [:dashboard, :careers, :communities, :search, :connections, :inbox, :portfolio]
      QuickNav::Data.get_row(:careers).collect { |i| i[0] }.should == [:search_careers, :search_industries]
      QuickNav::Data.ancestors_for(:search_careers).include?(:careers).should be_true
      QuickNav::Data.ancestors_for(:search_careers).include?(:search_careers).should be_true
      QuickNav::Data.ancestors_for(:search_careers).include?(:search_industries).should_not be_true
    end

    it "should have an 'update' method for changing nav items' content" do
      run do
        transformation do
          update :js_advice, "/js_resources", :display => "Advice"
        end

        QuickNav::Display.select :search_careers

        setup do
          item :careers, "/search_occupations" do
            item :search_careers, "/search_occupations", :display => "Careers"
            item :search_industries, "/industries", :display =>  "Industries"
          end
          item :communities, "/communities"
          item :js_advice, "/js_resources", :display => "Career Advice"
          item :search, "/search_job_posts", :display => "Advanced Search"
        end
      end

      QuickNav::Transformations.go!
      QuickNav::Data.get_row[2][2][:display].should == "Advice"
    end
    
    it "should let you add a sub-menu in a transformation" do
      run do
        QuickNav::Display.select :settings

        setup do
          item :settings, "/settings"
          item :search, "/search"
        end

        transformation do
          update :settings do
            push :privacy_settings, "/privacy"
            push :password, "/password"
          end
        end
      end

      QuickNav::Transformations.go!
      QuickNav::Data.get_row.collect { |i| i[0] }.should == [:settings, :search]
      QuickNav::Data.get_row(:settings).collect { |i| i[0] }.should == [ :privacy_settings, :password ]
    end

    it "should let you manipulate submenus in transformations" do
      run do
        QuickNav::Display.select :settings

        setup do
          item :settings, "/settings"
          item :search, "/search"
        end

        transformation do
          update :settings do
            push :privacy_settings, "/privacy"
            unshift :password, "/password"
          end
        end

        transformation do
          update :settings do
            update :privacy_settings, "/privacy_settings"
          end
          push :home, "/home"
        end
      end

      QuickNav::Transformations.go!
      QuickNav::Data.get_row.collect { |i| i[0] }.should == [:settings, :search, :home]
      QuickNav::Data.get_row(:settings).collect { |i| i[0] }.should == [ :password, :privacy_settings ]
      QuickNav::Data.get_row(:settings)[1][1].should == "/privacy_settings"
    end

    it "should allow multiple subnavs in transformations" do
      run do
        QuickNav::Display.select :settings

        setup do
          item :settings, "/settings"
          item :search, "/search"
        end

        transformation do
          update :settings do
            push :privacy_settings, "/privacy" do
              push :email, "/email"
              push :profile, "/profile"
            end
            unshift :password, "/password"
          end
        end

        transformation do
          update :settings do
            update :privacy_settings, "/privacy_settings"
          end
          push :home, "/home"
        end
      end

      QuickNav::Transformations.go!
      QuickNav::Data.get_row.collect { |i| i[0] }.should == [:settings, :search, :home]
      QuickNav::Data.get_row(:settings).collect { |i| i[0] }.should == [ :password, :privacy_settings ]
      QuickNav::Data.get_row(:privacy_settings).collect { |i| i[0] }.should == [ :email, :profile ]
      QuickNav::Data.get_row(:settings)[1][1].should == "/privacy_settings"
    end
  end
end
