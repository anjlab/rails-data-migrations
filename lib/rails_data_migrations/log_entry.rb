module RailsDataMigrations
  class LogEntry < ::ActiveRecord::SchemaMigration
    class << self
      def table_name
        ActiveRecord::Base.table_name_prefix + ENV.fetch('DATA_MIGRATIONS_TABLE_NAME', 'data_migrations') + ActiveRecord::Base.table_name_suffix
      end

      def index_name
        "#{table_name_prefix}#{ENV.fetch('DATA_MIGRATIONS_INDEX_NAME', 'unique_data_migrations')}#{table_name_suffix}"
      end
    end
  end
end