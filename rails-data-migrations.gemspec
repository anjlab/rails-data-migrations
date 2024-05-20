# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_data_migrations/version'

Gem::Specification.new do |spec|
  spec.name          = 'rails-data-migrations'
  spec.version       = RailsDataMigrations::VERSION
  spec.authors       = ['Sergey Glukhov']
  spec.email         = ['sergey.glukhov@gmail.com']

  spec.summary       = 'Run your data migration tasks in a db:migrate-like manner'
  spec.homepage      = 'https://github.com/OffgridElectric/rails-data-migrations'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.3'

  spec.add_runtime_dependency 'rails', '>= 4.0.0'

  spec.add_development_dependency 'appraisal', '~> 2.1'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '3.5.0'
end
