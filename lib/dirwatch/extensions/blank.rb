class Object
  # An object is blank if it's false, empty, or a whitespace string.
  # For example, +false+, '', '   ', +nil+, [], and {} are all blank.
  def blank?
    respond_to?(:empty?) ? !!empty? : !self
  end

  # An object is present if it's not blank.
  def present?
    !blank?
  end

  # Returns the receiver if it's present otherwise returns +nil+.
  def presence
    self if present?
  end
end

class NilClass
  # +nil+ is blank
  def blank?
    true
  end
end

class FalseClass
  # +false+ is blank
  def blank?
    true
  end
end

class TrueClass
  # +true+ is not blank
  def blank?
    false
  end
end

class Array
  # An array is blank if it's empty
  alias_method :blank?, :empty?
end

class Hash
  # A hash is blank if it's empty
  alias_method :blank?, :empty?
end

class String
  BLANK_RE = /\A[[:space:]]*\z/

  # A string is blank if it's empty or contains whitespaces only:
  #
  #   ''.blank?       # => true
  #   '   '.blank?    # => true
  #   "\t\n\r".blank? # => true
  #   ' blah '.blank? # => false
  #
  # Unicode whitespace is supported:
  #
  #   "\u00a0".blank? # => true
  #
  # @return [true, false]
  def blank?
    # The regexp that matches blank strings is expensive. For the case of empty
    # strings we can speed up this method (~3.5x) with an empty? call. The
    # penalty for the rest of strings is marginal.
    empty? || BLANK_RE.match?(self)
  end
end

class Numeric
  # No number is blank
  def blank?
    false
  end
end

class Time
  # No Time is blank
  def blank?
    false
  end
end
