require 'erubis'

module QuickNav
  module NewDisplay
    def self.default_method=(method); @@default_method = method end

    def self.load_template(template)
      @@template = Erubis::Eruby.new(template)
    end
    
    def self.nav
      @@template.result(binding())
    end
  end
end