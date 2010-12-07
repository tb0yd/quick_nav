module QuickNav
  class Sugar
    def initialize(context)
      @context = context
    end

    def method_missing(sym, *args, &block)
      @context.send sym, *args, &block
    end

    # this method is complex so we can have the simple 'item x x' DSL.
    def setup(parent=nil)
      if parent.nil?   # reset base_nav only at beginning
        Data.init_all
      end

      # use procs to retain access to parent variable and setup method and
      # redirect the control flow
      old_addition = @@addition if defined?(@@addition)
      old_recursion = @@recursion if defined?(@@recursion)
      @@addition = lambda { |k, v, h| Data.push(k, v, h, parent) }
      @@recursion = lambda { |next_parent, sub_block| setup(next_parent, &sub_block) }

      def item(*args, &sub_block)
        k, v, h = *args
        @@addition[k, v, h]
        if sub_block
          @@recursion[k, sub_block]
        end
      end

      # setup is called from itself unless it's going down one level, so
      # it should always have a block
      yield

      # restore old methods so the recursion can go up one level
      @@recursion = old_recursion if defined?(old_recursion)
      @@addition = old_addition if defined?(old_addition)
    end

    def transformation(&block)
      # DSL must be set up before the block is passed on again
      def push(*args); Data.push(*args) end
      def rm(name); Data.rm(name) end

      Transformations.add(block)
    end
  end
end
