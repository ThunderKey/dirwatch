source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

group :test do
  gem 'codeclimate-test-reporter', '~> 1.0.0'
  gem 'rubocop', '~> 0.58.2', require: false
end

# Specify your gem's dependencies in rubys_cube.gemspec
gemspec
