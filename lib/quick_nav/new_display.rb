require 'erubis'

module QuickNav
  module NewDisplay
    def self.load_template(template)
      @@template = Erubis::Eruby.new(template)
    end
    
    def self.nav
      @@template.result(binding())
    end
  end
end