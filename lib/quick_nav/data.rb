
module QuickNav
  module Data
    def self.init_all
      @@base = [] # the info for each item in the base nav
      @@parents = {} # hash to store the parent node of each item (if there is one)
    end

    def self.push(k, v, h={}, parent=nil)
      @@base << [k, v, h]
      @@parents.store(k, parent)
    end

    def self.unshift(k, v, h={}, parent=nil)
      @@base.unshift([k, v, h])
      @@parents.store(k, parent)
    end

    def self.rm(k)
      @@base.delete_if { |item| item[0] == k }
      @@parents.delete(k)
      get_row(k).each do |item|
        rm(item)
      end
    end

    def self.get_row(parent=nil)
      @@base.select { |item| @@parents[item[0]] == parent }
    end

    # called from the controller
    def self.select_before_setup(item)
      raise "cannot select >1 item" if item.respond_to?(:include?)
      @@selected = []
      select(item, :before_setup) unless is_selected?(item)
    end

    # called from the setup metod
    def self.reselect(item=get_selected[0])
      select_r(item)
    end

    def self.is_selected?(item)
      defined?(@@selected) and @@selected.include?(item)
    end

    def self.get_selected
      @@selected
    end

    protected

    # there's no use case in server-side code for manually selecting a node after setup.
    def self.select(item, option=nil)
      unless item.nil?
        @@selected.unshift item
        unless option == :before_setup
          select(@@parents[item]) if @@parents.has_key?(item) # also select each parent
        end
      end
    end
    
    def self.select_r(item)
      select(@@parents[item]) if @@parents.has_key?(item) # also select each parent
    end
  end
end
