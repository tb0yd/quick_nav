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
      @@addition = lambda { |k, v, h| Data.push(k, v, h.merge(:parent => parent)) }
      @@recursion = lambda { |next_parent, sub_block| setup(next_parent, &sub_block) }

      def item(*args, &sub_block)
        k, v, h = *args
        @@addition[k, v, h || {}]
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
      @@parent = nil
      
      # DSL must be set up before the block is passed on again
      def item(name, &block)
        if block_given?
          @@parent = name
          yield
          @@parent = nil
        end
      end
      
      def push(*args)
        if @@parent
          Data.push(*(args.with_options(:parent => @@parent)))
        else
          Data.push(*args)
        end
      end
      
      def unshift(*args)
        if @@parent
          Data.unshift(*(args.with_options(:parent => @@parent)))
        else
          Data.unshift(*args)
        end
      end
      
      def rm(name); Data.rm(name) end
      def update(*args); Data.update(*args) end

      Transformations.add(block)
    end
    
    def default_display_method=(method)
      Display.default_method = method
    end
  end
end
