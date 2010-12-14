require 'delegate'
module QuickNav
  class DSL
    def initialize(context)
      @context = context
    end

    def method_missing(sym, *args, &block)
      @context.send sym, *args, &block
    end

    # this method is complex so we can have the simple 'item x x' DSL.
    def setup(parent=nil)
      if parent.nil?   # reset base_nav only at beginning
        Data.reset
      end

      # use procs to retain access to parent variable and setup method and
      # redirect the control flow
      old_addition = @@addition if defined?(@@addition)
      old_recursion = @@recursion if defined?(@@recursion)
      @@addition = lambda { |k, v, h| Data.push(k, v, h.merge(:parent => parent)) }
      @@recursion = lambda { |next_parent, sub_block| setup(next_parent, &sub_block) }

      def item(*args, &sub_block)
        k, v, h = *(include_omitted_hash_key(*args))
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
      @@parents = []

      # DSL must be set up before the block is passed on again
      def push(*args)
        args = include_omitted_hash_key(*args)
        unless @@parents.empty?
          Data.push(*(args.with_options(:parent => @@parents.last)))
        else
          Data.push(*args)
        end
        if block_given?
          @@parents << args[0]
          yield
          @@parents.pop
        end
      end

      def unshift(*args)
        args = include_omitted_hash_key(*args)
        unless @@parents.empty?
          Data.unshift(*(args.with_options(:parent => @@parents.last)))
        else
          Data.unshift(*args)
        end
        if block_given?
          @@parents << args[0]
          yield
          @@parents.pop
        end
      end

      def update(*args, &block)
        args = include_omitted_hash_key(*args)
        Data.update(*args)
        if block_given?
          @@parents << args[0]
          yield
          @@parents.pop
        end
      end

      def rm(name); Data.rm(name) end

      Transformations.add(block)
    end

    def default_display_method=(method)
      Display.default_method = method
    end

    private

    def include_omitted_hash_key(*args)
      if args[2] and args[2].respond_to?(:gsub)
        [args[0], args[1], {:display => args[2]}]
      else
        args
      end
    end
  end
end
