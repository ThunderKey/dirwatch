RSpec.configure do |config|
  config.around(:example) do |ex|
    begin
      ex.run
    rescue SystemExit => e
      raise "Got unhandled SystemExit: #{e.status}\n  #{format_backtrace e.backtrace}"
    end
  end

  def format_backtrace backtrace, max: 10
    formated = backtrace[0..max].map {|b| b.gsub(/^#{RSpec.root}/, '.') }.join "\n  "
    formated += "\n  ..." if backtrace.count > max
    formated
  end
end
