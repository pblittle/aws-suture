require 'fog'

module Suture
  class Base
    attr_accessor :options

    def initialize(options = {})
      @options = options
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
  end
end
