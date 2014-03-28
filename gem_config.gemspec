lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'gem_config/version'

Gem::Specification.new do |gem|
  gem.name          = 'gem_config'
  gem.version       = GemConfig::VERSION
  gem.platform      = Gem::Platform::RUBY
  gem.authors       = ['Manuel Meurer']
  gem.email         = 'manuel@krautcomputing.com'
  gem.summary       = 'A nifty way to make your gem configurable.'
  gem.description   = 'A nifty way to make your gem configurable.'
  gem.homepage      = 'https://github.com/krautcomputing/gem_config'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r(^bin/)).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r(^(test|spec|features)/))
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rake', '>= 0.9.0'
  gem.add_development_dependency 'rspec', '~> 3.0.0.beta2'
  gem.add_development_dependency 'guard-rspec', '~> 4.2'
end
