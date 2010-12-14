require 'quick_nav/data'
require 'quick_nav/display'
require 'quick_nav/dsl'
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
          base.helper_method :quick_nav
        end
      end
      
      def quick_nav(item)
        QuickNav::Display.select(item)
      end
    end

    module ClassMethods
      def quick_nav(item)
        QuickNav::Display.select(item)
      end
    end
  end

  module Helpers
    def quick_nav(*args)
      QuickNav::Display.select(request.env['PATH_INFO']) if QuickNav::Display.selected.nil?
      QuickNav::Display.default_translation_method = method(:t)
      QuickNav::Display.load_template(IO.read(File.join(RAILS_ROOT, "app", "views", "layouts", "quick_nav.html.erb")))

      dsl = QuickNav::DSL.new(self)
      dsl.instance_eval(IO.read(File.join(RAILS_ROOT, "config", "quick_nav.rb")))
      
      Transformations.go!
      
      QuickNav::Display.nav
    end
  end
end