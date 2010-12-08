
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
    
    def self.get_selected
      defined?(@@selected) ? @@selected : nil
    end
    
    def self.get_all_selected(items=[])
      raise "cannot be called before setup because information has not been loaded yet" if !defined?(@@base)
      return [] if @@base == [] # after reset
      
      if items.empty?
        if @@selected.is_a?(Symbol)
          get_all_selected([@@selected])
        else
          get_all_selected([url_to_codeword(@@selected)])
        end
      elsif @@parents.has_key?(items.first) and @@parents[items.first].nil? == false
        get_all_selected([@@parents[items.first]] + items)
      else
        items
      end
    end

    # called from the controller
    def self.select_before_setup(item)
      raise "cannot select >1 item" if item.respond_to?(:each)
      @@selected = item
    end
    
    def self.reset
      @@base = []
      @@parents = {}
      @@selected = nil
    end
    
    def self.url_to_codeword(url)
      @@base.select { |item| item[1] == url }.first[0]
    end
    
    private_class_method :url_to_codeword
  end
end
