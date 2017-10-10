RSpec.configure do
  def run *args
    Dirwatch.console.run args
  end

  def run_init *args
    run 'init', *args
  end
end
