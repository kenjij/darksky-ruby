$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'darksky-ruby'

Gem::Specification.new do |s|
  s.name          = 'darksky-ruby'
  s.version       = DarkSkyAPI::VERSION
  s.authors       = ['Ken J.']
  s.email         = ['kenjij@gmail.com']
  s.summary       = %q{Pure simple Ruby based Dark Sky API gem}
  s.description   = %q{Dark Sky gem written in pure Ruby without any external dependency.}
  s.homepage      = 'https://github.com/kenjij/darksky-ruby'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.0'
end
