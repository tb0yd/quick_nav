
module QuickNav
  module Data
    def self.init_all
      @@base = [] # the info for each item in the base nav
      @@parents = {} # hash to store the parent node of each item (if there is one)
    end

    def self.push(k, v, h={})
      raise "you must provide a symbol id and a url for a new item" if !k or !v or v.respond_to?(:merge)
      parent = h.delete(:parent)
      @@base << [k, v, h]
      @@parents.store(k, parent)
    end

    def self.unshift(k, v, h={})
      raise "you must provide a symbol id and a url for a new item" if !k or !v or v.respond_to?(:merge)
      parent = h.delete(:parent)
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

    def self.update(*args)
      @@base.collect! { |item| item[0] == args[0] ? args : item }
    end

    def self.get_row(parent=nil)
      @@base.select { |item| @@parents[item[0]] == parent }
    end
    
    def self.get_all_selected(items=[])
      if items.empty?
        get_all_selected(@@selected)
      elsif @@parents.has_key?(items.last)
        get_all_selected(items + [@@parents[items.last]])
      else
        items
      end
    end

    # called from the controller
    def self.select_before_setup(item)
      raise "cannot select >1 item" if item.respond_to?(:each)
      @@selected = []
      if item.is_a?(Symbol)
        @@selected.unshift item unless is_selected?(item)
      elsif item.is_a?(String)
        @@selected.unshift(node_with_url(item)) unless is_selected?(item)
      end
    end

    def self.get_selected
      select(@@selected[0]) if defined?(@@parents) # lazily select all parent nodes
      @@selected
    end
    
    def self.node_with_url(url)
      @@base.select { |item| item[1] == url }.first[0]
    end

    def self.is_selected?(item)
      defined?(@@selected) and @@selected.include?(item)
    end

    # there's no use case in server-side code for manually selecting a node after setup.
    def self.select(item, option=nil)
      unless item.nil?
        @@selected.unshift item unless is_selected?(item)
        select(@@parents[item]) if @@parents.has_key?(item) # also select each parent
      end
    end
    
    private_class_method :is_selected?, :select
  end
end
