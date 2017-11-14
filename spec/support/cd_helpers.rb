RSpec.configure do
  def cd path
    original_path = Dir.pwd
    Dir.chdir path
    yield
  ensure
    Dir.chdir original_path
  end
end
