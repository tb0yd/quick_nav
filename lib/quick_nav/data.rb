
module QuickNav
  module Data
    def self.reset
      @@base = [] # the info for each item in the base nav
      @@parents = {} # hash to store the parent node of each item (if there is one)
    end

    def self.push(k, v, h={})
      raise "you must provide a symbol id and a url for a new item" if !k or !v or v.respond_to?(:merge)
      parent = h.delete(:parent)
      preceding_item_id = h.delete(:after)
      
      if preceding_item_id
        @@base.insert(@@base.collect(&:first).index(preceding_item_id) + 1, [k, v, h])
      else
        @@base << [k, v, h]
      end
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
      @@base.collect! do |item|
        if item[0] == args[0]
          [ args[0], args[1] || item[1], args[2] || item[2] ]
        else
          item
        end
      end
    end

    def self.get_row(parent=nil)
      @@base.select { |item| @@parents[item[0]] == parent }
    end
    
    def self.ancestors_for(items)
      raise "cannot be called before setup because information has not been loaded yet" if !defined?(@@base)
      return [] if @@base == [] # after reset
      
      if items.is_a?(String)
        ancestors_for([url_to_codeword(items)])
      elsif items.is_a?(Symbol)
        ancestors_for([items])
      elsif @@parents.has_key?(items.first) and @@parents[items.first].nil? == false
        ancestors_for([@@parents[items.first]] + items)
      else
        items
      end
    end
    
    def self.url_to_codeword(url)
      @@base.select { |item| item[1] == url }.first[0]
    end
    
    private_class_method :url_to_codeword
  end
end
