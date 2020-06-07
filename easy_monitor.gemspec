# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'easy_monitor'
  spec.version     = '1.0'
  spec.authors     = ['wildeng']
  spec.email       = ['alain.mauri@gmail.com']
  spec.homepage    = 'https://wildengineer.ilcavolfiore.it'
  spec.summary     = 'Summary of EasyMonitor.'
  spec.description = 'Description of EasyMonitor.'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'influxdb'
  spec.add_dependency 'rails', '~> 5.2.3'
  spec.add_dependency 'redis'
  spec.add_dependency 'rotp'
  spec.add_dependency 'sidekiq'

  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'mock_redis'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'pry-rails'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'webmock'
end
