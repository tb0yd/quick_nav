module QuickNav
  module Display
    def self.default_method=(method); @@default_method = method end
    
    def self.nav
      # do the primary nav
      result = line(
        '<div class="menu_wrapper_bg"><div class="menu_wrapper"><ul class="column span-48 menu main_menu">',
        Data.get_row,
        '</ul></div></div>')

      # do the sub navs
      Data.get_all_selected.each do |selected|
        result += line(
          '<div class="sub_menu_wrapper_bg"><div class="sub_menu_wrapper"><ul class="menu sub_menu">',
          Data.get_row(selected),
          '</ul></div></div>')
      end

      result
    end

    def self.line(tstart, items, tend)
      if items[0]
        result = tstart
        items.each do |item|
          result += item(item)
        end
        result + tend
      else
        ""
      end
    end

    def self.item(item)
      sym_name, url, opts = *item
      opts ||= {}
      name = opts[:display] || @@default_method[sym_name]

      if Data.get_all_selected.include?(sym_name)
        %(<li id="menu_nav_#{sym_name}" class="selected"><a class="selected" href="#{url}">#{name}</a></li>)
      else
        %(<li id="menu_nav_#{sym_name}"><a href="#{url}">#{name}</a></li>)
      end
    end

  end
end