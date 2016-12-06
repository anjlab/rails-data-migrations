# Rails template to build the dummy app for specs

environment <<-RUBY
  ActiveRecord::Base.timestamped_migrations = false
  require_relative '../lib/bukkits/lib/bukkits'
RUBY

gem 'rails-data-migrations', path: File.expand_path('../../..', __FILE__)

# Create engine
file('lib/bukkits/lib/bukkits.rb', <<-RUBY)
  module Bukkits
    class Engine < ::Rails::Engine
      railtie_name 'bukkits'
    end
  end
RUBY

file('lib/bukkits/db/data_migrations/1_create_users.rb', <<-RUBY)
  class CreateUsers < DataMigration::DataMigration
  end
RUBY
