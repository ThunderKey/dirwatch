RSpec::Matchers.define :an_option_with do |action, options|
  match do |actual|
    return false unless actual.is_a? Dirwatch::Options
    actual.action == action && actual.options == options
  end
end
