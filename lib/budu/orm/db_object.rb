require 'budu/orm/db_connection'
require 'budu/util'

module Budu
  module Model
    class SQLObject
      def self.columns
        DBConnection.execute2(<<-SQL).first.map(&:to_sym)
          SELECT
            *
          FROM
            #{table_name}
        SQL
      end

      def self.finalize!
        columns.each do |column|
          define_method(column) do
            attributes[column]
          end
          define_method("#{column}=") do |val|
            attributes[column] = val
          end
        end
      end

      def self.table_name=(table_name)
        @table_name = table_name
      end

      def self.table_name
        @table_name ||= Budu.to_underscore(self.to_s)
      end

      def self.all
        sql_str = <<-SQL
          SELECT
            #{table_name}.*
          FROM
            #{table_name}
        SQL

        parse_all(DBConnection.execute(sql_str))
      end

      def self.parse_all(results)
        results.map { |result| self.new(result) }
      end

      def self.find(id)
        sql_str = <<-SQL
          SELECT
            #{table_name}.*
          FROM
            #{table_name}
          WHERE
            id = ?
          LIMIT 1
        SQL

        parse_all(DBConnection.execute(sql_str, id)).first
      end

      def initialize(params = {})
        params.each do |attr_name, value|
          attr_name = attr_name.to_sym
          unless self.class.columns.include?(attr_name)
            raise "unknown attribute '#{attr_name}'"
          end
          self.send("#{attr_name}=", value) # sends to setter method defined in finalize!
        end
      end

      def attributes
        @attributes ||= {}
      end

      def attribute_values
        self.class.columns.map { |attr_name| send(attr_name.to_sym)}
      end

      def insert
        cols = self.class.columns
        col_names = cols.join(', ')
        q_marks = Array.new(cols.length, '?').join(', ')

        sql_str = <<-SQL
          INSERT INTO
            #{self.class.table_name} (#{col_names})
          VALUES
            (#{q_marks})
        SQL

        DBConnection.execute(sql_str, *attribute_values)

        self.id = DBConnection.last_insert_row_id
      end

      def update
        cols = self.class.columns.map { |column| "#{column} = ?"}.join(', ')

        sql_str = <<-SQL
          UPDATE
            #{self.class.table_name}
          SET
            #{cols}
          WHERE
            id = ?
        SQL

        DBConnection.execute(sql_str, *attribute_values, id)
      end

      def save
        if id.nil?
          insert
        else
          update
        end
      end
    end
  end
end
