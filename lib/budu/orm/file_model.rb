require 'multi_json'

# First ORM. Has nothing to do with SQLObject. Also it's terrible.
module Budu
  module Model
    class FileModel
      def self.find(id)
        begin
          FileModel.new("db/quotes/#{id}.json")
        rescue
          return nil
        end
      end

      def self.all
        files = Dir["db/quotes/*.json"]
        files.map { |f| FileModel.new(f) }
      end

      def initialize(filename)
        @filename = filename

        basename = File.split(filename).last
        @id = File.basename(basename, '.json').to_i

        obj = File.read(filename)
        @hash = MultiJson.load(obj)
      end

      def [](key)
        @hash[key.to_s]
      end

      def []=(key, val)
        @hash[key.to_s] = val 
      end
    end
  end
end
