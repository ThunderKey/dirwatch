module RSpec
  def self.spec_root
    @spec_root ||= Pathname.new File.dirname(File.dirname(__FILE__))
  end

  def self.root
    @root ||= Pathname.new File.dirname(spec_root)
  end
end
