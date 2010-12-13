module QuickNav
  module Transformations
    @@transformations = []

    def self.add(block)
      @@transformations << block
    end

    def self.go!
      @@transformations.each do |block|
        block.call
      end

      @@transformations = []
    end
  end
end


