class Regexp
  def match?(string, pos = 0)
    !!match(string, pos)
  end unless //.respond_to?(:match?)
end
