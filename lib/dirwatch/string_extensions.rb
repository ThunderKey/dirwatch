class String
  @@reset =   "\033[0m"
  def bold;   "\033[1m#{self}#{@@reset}"; end
  def green;  "\033[32m#{self}#{@@reset}"; end
  def red;    "\033[31m#{self}#{@@reset}"; end
  def yellow; "\033[33m#{self}#{@@reset}"; end
end
