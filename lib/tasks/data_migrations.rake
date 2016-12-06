require 'rake'
require 'rails-data-migrations'

namespace :data do
  def migrations_path
    RailsDataMigrations::Migrator.migrations_path
  end

  def apply_single_migration(direction, version)
    raise 'VERSION is required' unless version
    RailsDataMigrations::Migrator.run(direction, migrations_path, version.to_i)
  end

  task init_migration: :environment do
    RailsDataMigrations::LogEntry.create_table
  end

  desc 'Apply pending data migrations'
  task migrate: :init_migration do
    source_versions = RailsDataMigrations::Migrator.migrations(migrations_path).collect(&:version)
    applied_versions = RailsDataMigrations::Migrator.get_all_versions

    (source_versions - applied_versions).sort.each do |version|
      apply_single_migration(:up, version)
    end
  end

  namespace :install do
    desc 'Copies missing data migrations from Railties (e.g. engines)'
    task migrations: :init_migration do
      railties = Rails.application.railties.each_with_object({}) do |railtie, railties|
        if railtie.respond_to?(:paths)
          data_migrations_path = railtie.root.join(RailsDataMigrations::Migrator.migrations_path)
          if data_migrations_path.exist?
            railties[railtie.railtie_name] = data_migrations_path.to_s
          end
        end
      end

      on_copy = Proc.new do |name, migration|
        puts "Copied data migration #{migration.basename} from #{name}"
      end

      ActiveRecord::DataMigration.copy(
        RailsDataMigrations::Migrator.migrations_path,
        railties,
        on_copy: on_copy
      )
    end
  end

  namespace :migrate do
    desc 'Apply single data migration using VERSION'
    task up: :init_migration do
      apply_single_migration(:up, ENV['VERSION'])
    end

    desc 'Revert single data migration using VERSION'
    task down: :init_migration do
      apply_single_migration(:down, ENV['VERSION'])
    end

    desc 'Skip single data migration using VERSION'
    task skip: :init_migration do
      version = ENV['VERSION'].to_i
      raise 'VERSION is required' unless version > 0
      if RailsDataMigrations::LogEntry.where(version: version).any?
        puts "data migration #{version} was already applied."
      else
        RailsDataMigrations::LogEntry.create!(version: version)
        puts "data migration #{version} was skipped."
      end
    end

    desc 'List pending migrations'
    task pending: :init_migration do
      puts "#{'% 16s' % 'Migration ID'}  Migration Name"
      puts '--------------------------------------------------'
      migrator = RailsDataMigrations::Migrator
      migrator.open(migrator.migrations_path).pending_migrations.each do |m|
        puts "#{'% 16i' % m.version}  #{m.name.to_s.titleize}"
      end
    end
  end
end
