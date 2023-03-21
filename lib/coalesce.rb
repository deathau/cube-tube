# Handy null coalesing operator, taken from
# https://github.com/kibiz0r/coalesce/blob/bc4389ae8a8bb456cd10ec8a3523df1fc775124f/lib/coalesce.rb

class Object
  def _?(x = nil)
    self
  end
end

class NilClass
  def _?(x = nil)
    if block_given?
      yield
    else
      x
    end
  end
end
