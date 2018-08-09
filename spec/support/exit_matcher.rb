module CallExitHelper
  def exit_status
    yield
    nil
  rescue SystemExit => e
    e.status
  end
end

RSpec::Matchers.define :call_exit_with do |expected|
  include CallExitHelper

  supports_block_expectations

  match do
    @exit_status = exit_status(&actual)
    @exit_status == expected
  end

  match_when_negated do
    @exit_status = exit_status(&actual)
    !@exit_status.nil? && @exit_status != expected
  end

  failure_message do
    if @exit_status
      <<-OUTPUT
expected: exit status == #{expected}
     got:                #{@exit_status}
OUTPUT
    else
      "expected the exit status to match #{expected} but exit was not called"
    end
  end

  failure_message_when_negated do
    if @exit_status
      <<-OUTPUT
expected: exit status != #{expected}
     got:                #{@exit_status}
OUTPUT
    else
      "expected the exit status to not match #{expected} but exit was not called"
    end
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
