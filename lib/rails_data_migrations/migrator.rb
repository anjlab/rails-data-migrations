module RailsDataMigrations
  class Migrator < ::ActiveRecord::Migrator

    def record_version_state_after_migrating(version)
      if down?
        migrated.delete(version)
        LogEntry.where(version: version.to_s).delete_all
      else
        migrated << version
        LogEntry.create!(version: version.to_s)
      end
    end

    class << self
      def migrations_table_exists?(connection = ActiveRecord::Base.connection)
        table_check_method = connection.respond_to?(:data_source_exists?) ? :data_source_exists? : :table_exists?
        connection.send(table_check_method, schema_migrations_table_name)
      end

      def get_all_versions(connection = ActiveRecord::Base.connection)
        if migrations_table_exists?(connection)
          LogEntry.all.map { |x| x.version.to_i }.sort
        else
          []
        end
      end

      def schema_migrations_table_name
        LogEntry.table_name
      end

      def migrations_path
        'db/data_migrations'
      end
    end
  end
end