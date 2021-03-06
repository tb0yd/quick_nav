require 'erubis'

module QuickNav
  module Display
    def self.default_translation_method=(method); @@default_translation_method = method end

    def self.load_template(template)
      @@template = Erubis::Eruby.new(template)
    end

    def self.nav
      result = @@template.result(binding())
      @@selected = nil
      result
    end

    def self.main_menu(&block)
      each_row_in(nil, &block) # top level means parent is nil
    end

    def self.sub_menus(&block)
      Data.ancestors_for(@@selected).each do |item|
        unless Data.get_row(item).empty?
          yield item
        end
      end
    end

    def self.each_row_in(parent=nil, &block)
      Data.get_row(parent).each do |item|
        code_name, url, opts = *item
        opts ||= {}
        word_name = opts[:display] || @@default_translation_method[code_name]
        selected = Data.ancestors_for(@@selected).include?(code_name)

        yield code_name, word_name, url, selected
      end
    end

    def self.select(code_name)
      @@selected = code_name
    end
    def self.selected; defined?(@@selected) ? @@selected : nil end
  end
end