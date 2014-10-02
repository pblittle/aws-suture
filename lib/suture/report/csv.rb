require 'csv'

module Suture
  module Report
    class CSV

      def initialize(path)
        super()
        @path = path
      end

      def start
        @data = {}
        @data[:header] = ['Server ID', 'Command Output', 'Name', 'Public IP', 'Key Name', 'status']
      end

      def add_instance(instance, result, status)
        @data[:instances] ||= []
        @data[:instances] << [instance.id,
                             result,
                             instance.tags['Name'],
                             instance.public_ip_address,
                             instance.key_name,
                             status]
      end

      def finish
        ::CSV.open(@path, 'wb') do |csv|
          csv << @data[:header]
          @data[:instances].each{ |instance| csv << instance }
        end
      end
    end
  end
end
