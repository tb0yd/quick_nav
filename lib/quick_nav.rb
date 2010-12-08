require 'quick_nav/data'
require 'quick_nav/display'
require 'quick_nav/sugar'
require 'quick_nav/transformations'
require 'quick_nav/core_ext'
require 'quick_nav/railtie' if defined?(Rails) and Rails::VERSION::MAJOR == 3

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
      
      def current_navigation(item)
        QuickNav::Data.select_before_setup(item)
      end
    end

    module ClassMethods
      def navigation(item)
        QuickNav::Data.select_before_setup(item)
      end
    end
  end

  module Helpers
    def render_navigation(*args)
      QuickNav::Data.select_before_setup(request.env['PATH_INFO']) if QuickNav::Data.get_selected.nil?

      sugar = QuickNav::Sugar.new(self)
      sugar.default_display_method = method(:t)
      sugar.instance_eval(IO.read(File.join(RAILS_ROOT, "config", "navigation.rb")))
      
      Transformations.go!
      result = Display.nav
      QuickNav::Data.reset
      result
    end
  end
end