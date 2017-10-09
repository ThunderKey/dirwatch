#!/bin/env ruby

SimpleCov.start do
  # loaded before via the gemspec
  add_filter File.join(root, 'lib', 'dirwatch', 'version.rb')

  # loaded before via the rspec itself
  add_filter File.join(root, 'spec', 'spec_helper.rb')

  track_files File.join(root, '**', '*.rb')

  add_group 'Libraries', 'lib'
  add_group 'Binaries', 'bin'
  add_group 'Specs', 'spec'
end
