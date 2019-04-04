# frozen_string_literal: true

$:.push File.expand_path('lib', __dir__)

require 'europeana/feeds/version'

Gem::Specification.new do |spec|
  spec.name          = 'europeana-feeds'
  spec.version       = Europeana::Feeds::VERSION
  spec.authors       = ['Lutz Biedinger']
  spec.email         = ['lutz.biedinger@gmail.com']

  spec.summary       = 'This gem retrieves rss feeds and caches their contents'
  spec.description   = 'Rails Engine to retrieve and cache rss feeds'
  spec.homepage      = 'https://github.org/europeana/europeana-feeds'
  spec.license       = 'EUPL-1.2'

  spec.files = Dir['{app,bin,lib}/**/*', '.rubocop.yml', 'Gemfile', 'LICENSE.md', 'README.md']

  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'feedjira', '~> 2.0'
  spec.add_dependency 'rails', '>= 4.2', '< 6'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'coveralls', '~> 0.7.1'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-rails', '~> 3.0'
  spec.add_development_dependency 'rubocop', '0.50.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
  spec.add_development_dependency 'webmock', '~> 2.3'
end
