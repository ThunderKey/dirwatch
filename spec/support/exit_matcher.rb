module CallExitHelper
  def exit_status
    begin
      yield
    rescue SystemExit => e
      return e.status
    end
    nil
  end
end

RSpec::Matchers.define :call_exit_with do |expected|
  include CallExitHelper

  supports_block_expectations

  match do
    @exit_status = exit_status(&actual)
    @exit_status == expected
  end

  failure_message do
    <<-EOT
expected: exit status == #{expected}
     got:                #{@exit_status}
EOT
  end

  failure_message_when_negated do
    <<-EOT
expected: exit status != #{expected}
     got:                #{@exit_status}
EOT
  end
end

RSpec::Matchers.alias_matcher :exit_with, :call_exit_with

RSpec::Matchers.define :call_exit do
  include CallExitHelper

  supports_block_expectations

  match do
    @exit_status = exit_status(&actual)
    !@exit_status.nil?
  end

  failure_message do
    'expected the Kernel.exit method to be called'
  end

  failure_message_when_negated do
    'expected the Kernel.exit method to not be called'
  end
end
