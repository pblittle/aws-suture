require 'json'

module Suture
  module Report
    class JSON

      def initialize(path)
        super()
        @path = path
        @data = {}
      end

      def start; end

      def add_instance(instance, result, status)
        @data[:status] ||= []
        @data[:status] << {'Server ID' => instance.id,
                          'Command Output' => result,
                          'Name' => instance.tags['Name'],
                          'Public IP' => instance.public_ip_address,
                          'Key Name' => instance.key_name}
      end

      def finish
        ::File.open(@path, 'w') do |json_file|
          json_file.write(@data.to_json)
        end
      end
    end
  end
end
