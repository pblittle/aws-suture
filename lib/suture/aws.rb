require 'suture/base'
require 'suture/report'

module Suture
  class AWS < Suture::Base

    attr_reader :report

    def check
      render(reports)
    end

    def patch
      fail NotImplementedError, '#patch not implemented'
    end

    def exec
      options[:command]
    end

    private

    def credentials
      {
        :provider => 'AWS',
        :aws_access_key_id => options[:aws][:access_key_id],
        :aws_secret_access_key => options[:aws][:secret_access_key],
        :region => options[:aws][:region]
      }
    end

    def valid_credentials?
      options.key?(:aws) &&
        options[:aws].is_a?(Hash) &&
        options[:aws][:access_key_id] &&
        options[:aws][:secret_access_key] &&
        options[:aws][:region]
    end

    def instances
      @instances ||= begin
        compute.servers.all(instance_filter).each do |server|
          server.username = ssh_user if ssh_user
          server.ssh_options = ssh_options(server.key_name)
        end
      end
    end

    def instance_filter
      { 'instance-id' => instance_id }
    end

    def instance_id
      options[:aws][:ec2][:instance_id] || []
    rescue
      []
    end

    def identity_file(key_name)
      identity_file = ::File.join(
        identity_file_path, key_name
      )

      if ::File.exist?(identity_file)
        identity_file
      elsif ::File.exist?(identity_file + '.pem')
        identity_file + '.pem'
      else
        raise "Keyfile #{key_name} not found in #{identity_file_path}"
      end
    rescue StandardError => error
      raise error.message
    end

    def identity_file_path
      ::File.expand_path(
        options[:aws][:ec2][:identity_file_path]
      )
    rescue StandardError => error
      raise error.message
    end

    def key_pair_data(key_name)
      ::File.read(identity_file(key_name))
    rescue StandardError => error
      puts 'Error: ' + error.message
    end

    def ssh_options(key_name)
      { :key_data => key_pair_data(key_name) }
    end

    def ssh_user
      options[:aws][:ec2][:ssh_user]
    rescue StandardError => error
      puts 'Error: ' + error.message
    end
  end
end
