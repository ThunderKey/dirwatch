class Regexp
  unless //.respond_to?(:match?)
    def match? string, pos = 0
      match(string, pos)
    end
  end
end
