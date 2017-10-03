class Object
  def symbolize_keys
    self
  end
end

class Hash
  def symbolize_keys
    each_with_object({}) do |(k, v), hash|
      hash[k.to_sym] = v.symbolize_keys
    end
  end
end

class Array
  def symbolize_keys
    map(&:symbolize_keys)
  end
end
