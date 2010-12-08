class Array
  def with_options(hash)
    if last.respond_to?(:merge)
      self + [pop.merge(hash)]
    else
      self + [hash]
    end
  end
end
