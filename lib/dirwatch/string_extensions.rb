class String
  RESET_KEY = "\033[0m".freeze
  {
    bold:   "\033[1m",
    green:  "\033[32m",
    red:    "\033[31m",
    yellow: "\033[33m",
  }.each do |name, color_key|
    define_method(name) do
      "#{color_key}#{self}#{RESET_KEY}"
    end
  end
end
