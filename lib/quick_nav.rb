require 'quick_nav/data'
require 'quick_nav/display'
require 'quick_nav/sugar'
require 'quick_nav/transformations'
require 'quick_nav/railtie' if Rails::VERSION::MAJOR == 3

module QuickNav
  def self.init_rails
    ActionController::Base.send(:include, QuickNav::Controller::InstanceMethods)
    ActionController::Base.send(:extend, QuickNav::Controller::ClassMethods)
  end

  module Controller
    module InstanceMethods
      def self.included(base) #:nodoc:
        base.class_eval do
          include QuickNav::Helpers
          base.helper_method :render_navigation
        end
      end
    end

    module ClassMethods
      def navigation(item)
        Data.select_before_setup(item) # must be called before setup, because this is here, and setup is in the helper
      end
    end
  end

  module Helpers
    def render_navigation(*args)
      sugar = QuickNav::Sugar.new(self)
      sugar.instance_eval(IO.read(File.join(RAILS_ROOT, "config", "navigation.rb")))
      Transformations.go!
      Display.nav
    end
  end
end