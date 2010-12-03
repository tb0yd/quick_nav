module QuickNav
  module Transformations
    def self.add(block)
      @@transformations ||= []
      @@transformations << block
    end

    def self.go!
      @@transformations.each do |block|
        block.call
      end

      # a good place to reset (FIXME)
      @@transformations = []
    end
  end
end


