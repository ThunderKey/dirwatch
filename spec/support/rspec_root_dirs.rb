module RSpec
  def self.spec_root
    @@spec_root ||= File.dirname File.dirname(__FILE__)
  end

  def self.root
    @@root ||= File.dirname spec_root
  end
end
