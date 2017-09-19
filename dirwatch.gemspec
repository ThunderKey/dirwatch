lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dirwatch/version'

Gem::Specification.new do |s|
  s.name          = 'dirwatch'
  s.version       = Dirwatch::VERSION.to_s
  s.summary       = 'Watch specific files and execute commands when any of them change'
  s.authors       = ['Nicolas Ganz']
  s.email         = 'nicolas@keltec.ch'
  s.files         = Dir["{lib,vendor}/**/*"] + ["LICENSE", "README.md"]
  s.bindir        = 'bin'
  s.executables   = Dir["bin/*"].map {|f| File.basename f }
  s.require_paths = ['lib']
  s.homepage      = 'https://github.com/ThunderKey/dirwatch'
  s.license       = 'MIT'
end
