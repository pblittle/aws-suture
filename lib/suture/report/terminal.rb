module Suture
  module Report
    class Terminal
      require 'command_line_reporter'
      include CommandLineReporter

      COLOR_MAPPING = {:passed => 'green', :failed => 'red', :unknown => 'blue'}

      def start
        print_report_header
      end

      def finish; end

      def add_instance(server, result, status)
        table(:border => true) do
          row do
            column(server.id, :color => result_color(status), :width => 12)
            column(result, :color => result_color(status), :width => 38)
            column(server.tags['Name'], :color => result_color(status), :width => 50)
            column(server.public_ip_address, :color => result_color(status), :width => 16)
            column(server.key_name, :color => result_color(status), :width => 24)
          end
        end
      end

      def print_report_header
        table(:border => true) do
          row do
            column('Server ID', :width => 12)
            column('Command Output', :width => 38)
            column('Name', :width => 50)
            column('Public IP', :width => 16)
            column('Key Name', :width => 24)
          end
        end
      end

      def result_color(status)
        COLOR_MAPPING[status]
      end
    end
  end
end
