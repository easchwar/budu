require 'sqlite3'

# https://tomafro.net/2010/01/tip-relative-paths-with-file-expand-path
# ROOT_FOLDER = File.join(File.dirname(__FILE__), '..')
ROOT_FOLDER = Dir.pwd
MODEL_SQL_FILE = File.join(ROOT_FOLDER, 'local_db.sql')
MODEL_DB_FILE = File.join(ROOT_FOLDER, 'local_db.db')

# Database connection to local sqlite db 'local_db.db'
module Budu
  class DBConnection
    def self.open(db_file_name)
      @db = SQLite3::Database.new(db_file_name)
      @db.results_as_hash = true
      @db.type_translation = true

      @db
    end

    def self.reset
      # This used to reset the database every time the server started up.

      # commands = [
      #   "rm '#{MODEL_DB_FILE}'",
      #   "cat '#{MODEL_SQL_FILE}' | sqlite3 '#{MODEL_DB_FILE}'"
      # ]
      #
      # commands.each { |command| `#{command}` }

      unless File.exist?(MODEL_DB_FILE)
        `cat '#{MODEL_SQL_FILE}' | sqlite3 '#{MODEL_DB_FILE}'` 
      end
      
      DBConnection.open(MODEL_DB_FILE)
    end

    def self.instance
      reset if @db.nil?

      @db
    end

    def self.execute(*args)
      puts args[0]

      instance.execute(*args)
    end

    def self.execute2(*args)
      puts args[0]

      instance.execute2(*args)
    end

    def self.last_insert_row_id
      instance.last_insert_row_id
    end

    private

    def initialize(db_file_name)
    end
  end
end
