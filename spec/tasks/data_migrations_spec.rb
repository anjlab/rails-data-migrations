require 'spec_helper'

RSpec.describe 'data migrations' do
  around do |example|
    Bundler.with_clean_env do
      example.run
    end
  end

  around do |example|
    Dir.chdir('spec/dummy') do
      example.run
    end
  end

  before do
    FileUtils.rmtree('db/data_migrations')
  end

  after do
    FileUtils.rmtree('db/data_migrations')
  end

  def install_migrations
    `bundle exec rake data:install:migrations RAILS_ENV=test`
  end

  it 'copies data migration file form engine to application' do
    system('bundle install')

    expect(File).not_to be_exist('db/data_migrations/0_create_users.bukkits.rb')

    output = install_migrations

    expect(output).to eq("Copied data migration 0_create_users.bukkits.rb from bukkits\n")
    expect(File).to be_exist('db/data_migrations/0_create_users.bukkits.rb')
  end

  context 'new data migration added to engine' do
    let(:new_migration_path) do
      'lib/bukkits/db/data_migrations/2_create_sessions.rb'
    end

    def add_create_sessions_migration_to_engine
      IO.write(new_migration_path, <<-RUBY)
        class CreateSessions < DataMigration::DataMigration
        end
      RUBY
    end

    before do
      system('bundle install')
      install_migrations
      add_create_sessions_migration_to_engine
    end

    after do
      FileUtils.rm(new_migration_path)
    end

    it 'copies only new data migration file form engine to application' do
      expect(File).not_to be_exist('db/data_migrations/1_create_sessions.bukkits.rb')

      output = install_migrations

      expect(output).to eq("Copied data migration 1_create_sessions.bukkits.rb from bukkits\n")
      expect(File).to be_exist('db/data_migrations/1_create_sessions.bukkits.rb')
    end
  end
end
