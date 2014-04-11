require 'suture'

module Suture
  class Base

    require 'fog'
    require 'command_line_reporter'

    include CommandLineReporter

    CREDENTIALS = {
      :aws_access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    }

    attr_reader :compute

    def initialize(*args)
      @compute ||= compute
    end

    def compute
      Fog::Compute.new(credentials)
    end

    private

    def credentials
      CREDENTIALS.merge(:provider => 'AWS')
    end
  end
end
