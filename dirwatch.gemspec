lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dirwatch/version'

Gem::Specification.new do |spec|
  spec.name          = 'dirwatch'
  spec.version       = Dirwatch::VERSION.to_s
  spec.summary       = 'Watch specific files and execute commands when any of them change'
  spec.authors       = ['Nicolas Ganz']
  spec.email         = 'nicolas@keltec.ch'
  spec.files         = Dir["{lib,vendor}/**/*"] + ["LICENSE", "README.md"]
  spec.bindir        = 'bin'
  spec.executables   = Dir["bin/*"].map {|f| File.basename f }
  spec.require_paths = ['lib']
  spec.homepage      = 'https://github.com/ThunderKey/dirwatch'
  spec.license       = 'MIT'
end
