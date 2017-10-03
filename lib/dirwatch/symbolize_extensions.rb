class Object
  def symbolize_keys
    self
  end
end

class Hash
  def symbolize_keys
    inject({}) do |hash,(k,v)|
      hash[k.to_sym] = v.symbolize_keys
      hash
    end
  end
end

class Array
  def symbolize_keys
    map &:symbolize_keys
  end
end
