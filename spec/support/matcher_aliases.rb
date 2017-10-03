RSpec.configure do
  RSpec::Matchers.define_negated_matcher :not_output, :output
end
