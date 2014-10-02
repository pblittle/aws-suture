require 'fog'

module Suture
  class Base
    attr_accessor :options
    attr_reader :reports
    # attr_reader :servers
#     attr_reader :check_command
#     attr_reader :check_result

    def initialize(options = {})
      @options = options

      reports = []
      reports << Suture::Report::Terminal.new() unless options[:quiet]
      reports << Suture::Report::JSON.new(options[:json]) if options[:json]
      reports << Suture::Report::CSV.new(options[:csv]) if options[:csv]

      @reports = reports
    end

    def render(reports)
      instances #initializes the instances, thereby putting an error messages before table output
      reports.each{ |report| report.start }
      render_body reports
      reports.each{ |report| report.finish }
    end

    def render_body(reports)
      instances.sort_by!{ |instance| instance.tags['Name'] }.each do |instance|
        next unless instance.ready?
        begin
          result = run_command(instance)
        rescue StandardError => error
          result = error.message
          status = :unknown
        end

        status ||= check_status(result)
        reports.each{ |report| report.add_instance(instance, result, status) }
      end
    end

    def compute
      @compute ||= begin
        fail Exception, 'Invalid credentials' unless valid_credentials?
        Fog::Compute.new(credentials)
      end
    end

    private

    def credentials
      fail Error, '#credentials should be overridden by decendents'
    end

    def valid_credentials?
      fail Error, '#valid_credentials? should be overridden by decendents'
    end

    def check_command
      options[:check_command]
    rescue StandardError => error
      puts 'Error: ' + error.message
    end

    def expected_result
      options[:expected_result]
    rescue StandardError => error
      puts 'Error: ' + error.message
    end

    def results(server)
      command = server.ssh(check_command)
      command.reduce([]) do |result, check|
        result << check.stdout
        result
      end
    end

    def run_command(server)
      results(server)[0].strip
    end

    def check_status(result)
      if /#{expected_result}/m.match(result)
        :passed
      else
        :failed
      end
    end
  end
end
