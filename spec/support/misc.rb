RSpec.configure do
  def run *args
    Dirwatch.run_from_args args
  end

  def run_init *args
    run 'init', *args
  end
end
