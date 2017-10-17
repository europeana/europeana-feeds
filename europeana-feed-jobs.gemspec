# frozen_string_literal: true

# coding: utf-8

$:.push File.expand_path('../lib', __FILE__)

require 'europeana/feed_jobs/version'

Gem::Specification.new do |spec|
  spec.name          = 'europeana-feed-jobs'
  spec.version       = Europeana::FeedJobs::VERSION
  spec.authors       = ['Lutz Biedinger']
  spec.email         = ['lutz.biedinger@gmail.com']

  spec.summary       = 'This gem retrieves rss feeds and caches their contents'
  spec.description   = ''
  spec.homepage      = 'https://github.org/europeana/europeana-feed-jobs'
  spec.license       = 'EUPL-1.1'

  spec.files = Dir['{config,lib}/**/*', '.rubocop.yml', 'Gemfile', 'LICENSE.md', 'README.md']

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '~> 4.2.9'
  spec.add_dependency 'dotenv-rails', '~> 2.1'
  spec.add_dependency 'feedjira', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-rails', '~> 3.0'
  spec.add_development_dependency 'rubocop', '0.50.0'
  spec.add_development_dependency 'coveralls', '~> 0.7.1'
end
