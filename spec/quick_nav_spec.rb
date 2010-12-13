require 'quick_nav'
require File.join(File.dirname(__FILE__), 'spec_helper')

describe QuickNav do
  def sample_setup
    run do
      setup do
        item :account, "/account" do
          item :email, "/email", :display => "Email Settings"
          item :password, "/password", :display =>  "Change Password"
        end
        item :forums, "/forums"
        item :blog, "/blog"
        item :sitemap, "/sitemap"
        item :contact, "/contact"
        item :search, "/search"
      end
    end
  end

  describe do
    before(:each) do
      sample_setup
    end

    it "should make the selected item have the selected template" do
      QuickNav::Display.select(:password)
      QuickNav::Display.nav.include?(%(<a class="selected" href="/password">)).should be_true
    end

    it "should allow you to select by URL" do
      QuickNav::Display.select('/password')
      QuickNav::Display.nav.include?(%(<a class="selected" href="/password">)).should be_true
    end

    it "should display the items in the order they were written in" do
      QuickNav::Display.nav.should match(/account(.|\n)*forums(.|\n)*blog/)
      QuickNav::Display.nav.should_not match(/account(.|\n)*blog(.|\n)*forums/)
    end

    it "should allow you to specify your own item QuickNav::Display name" do
      QuickNav::Display.select(:password)
      QuickNav::Display.nav.should =~ /Change Password/
    end

    it "should render the parents of the selected node as selected" do
      QuickNav::Display.select(:password)
      QuickNav::Display.nav.include?(%(<a class="selected" href="/account">)).should be_true
    end

    it "should not render the children of the selected node as selected" do
      QuickNav::Display.select(:account)
      QuickNav::Display.nav.include?(%(<a class="selected" href="/password">)).should be_false
    end
  end

  it "should make no difference if you select the item before setup" do
    QuickNav::Display.select(:password)
    sample_setup
    QuickNav::Display.nav.include?(%(<a class="selected" href="/password">)).should be_true
  end
end
