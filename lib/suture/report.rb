require 'suture/aws'

module Suture
  class Report
    require 'command_line_reporter'
    include CommandLineReporter

    attr_reader :servers
    attr_reader :check_command
    attr_reader :check_result

    def initialize(servers = [], check_command, check_result)
      @servers = servers
      @check_command = check_command
      @check_result = check_result
    end

    def render
      print_report_header

      servers.each do |server|
        table(:border => true) do
          print_report_body(server)
        end
      end
    end

    def print_report_header
      table(:border => true) do
        row do
          column('Server ID', :width => 10)
          column('OpenSSL Version', :width => 30)
          column('Name', :width => 26)
          column('Public IP', :width => 16)
          column('Key Name', :width => 24)
          column('State', :width => 10)
        end
      end
    end

    def print_report_body(server)
      begin
        checks = server.ssh(check_command)
        check_results = results(checks)

        result = check_results[0].strip
        result_color = result_color(result)
      rescue StandardError => error
        result = error.message
        result_color = 'blue'
      end

      row do
        column(server.id, :width => 10)
        column(result, :color => result_color, :width => 30)
        column(server.tags['Name'], :width => 26)
        column(server.public_ip_address, :width => 16)
        column(server.key_name, :width => 24)
        column(server.state, :width => 10)
      end
    end

    def results(checks)
      checks.reduce([]) do |result, check|
        result << check.stdout
        result
      end
    end

    def result_color(result)
      if /#{check_result}/m.match(result)
        'green'
      else
        'red'
      end
    end
  end
end
