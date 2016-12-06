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
    `bundle install`
  end

  after do
    FileUtils.rmtree('db/data_migrations')
  end

  def install_migrations
    system('bundle exec rake data:install:migrations RAILS_ENV=test')
  end

  it 'logs copied migrations to stdout' do
    expect do
      install_migrations
    end.to output("Copied data migration 0_create_users.bukkits.rb from bukkits\n").to_stdout_from_any_process
  end

  it 'copies data migration file form engine to application' do
    install_migrations

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
      install_migrations
      add_create_sessions_migration_to_engine
    end
    after do
      FileUtils.rm(new_migration_path)
    end

    it 'logs only new migrations copies' do
      expect do
        install_migrations
      end.to output("Copied data migration 1_create_sessions.bukkits.rb from bukkits\n").to_stdout_from_any_process
    end

    it 'copies new data migration file form engine to application' do
      install_migrations

      expect(File).to be_exist('db/data_migrations/1_create_sessions.bukkits.rb')
    end

    it 'adds only one migration' do
      expect do
        install_migrations
      end.to change { Dir['db/data_migrations/*.rb'].length }.by(1)
    end
  end
end
