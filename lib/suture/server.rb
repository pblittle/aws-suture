require 'suture'
require 'suture/base'

module Suture
  class Server < Suture::Base

    attr_reader :instance_id

    def initialize(*args)
      super(*args)

      @instance_id = args[0]
    end

    def check
      if instance_id.empty?
        print_servers(compute_servers)
      else
        print_server(compute_server)
      end
    end

    private

    def compute_servers
      @compute.servers
    end

    def compute_server
      compute_servers.get(@instance_id)
    end

    def run_commands(dns_name)
      ssh = Fog::SSH.new(dns_name, 'ubuntu', ssh_options)
      begin
        ssh.run(commands)
      rescue
        [Fog::SSH::Result.new(ssh)]
      end
    end

    def print_server(server)
      table(:border => true) do
        print_server_header
        print_server_row(server)
      end
    end

    def print_servers(servers)
      table(:border => true) do
        print_server_header
        servers.each do |server|
          print_server_row(server) if server.state == 'running'
        end
      end
    end

    def print_server_header
      row do
        column('Instance ID', :width => 20)
        column('OpenSSL Version', :width => 30)
        column('Name', :width => 15)
        column('Public IP', :width => 20)
        column('Key Name', :width => 20)
      end
    end

    def print_server_row(server)
      result = run_commands(server.dns_name)[0]
      version = result.stdout.strip
      color = result_color(version)

      row do
        column(server.id, { :color => color })
        column(version, { :color => color })
        column(server.tags['Name'], { :color => color })
        column(server.public_ip_address, { :color => color })
        column(server.key_name, { :color => color })
      end
    end

    def result_color(result)
      if /1\.0\.(1[a-f]|2)/.match(result)
        'green'
      else
        'red'
      end
    end

    def ssh_options
      options = {}
      options.merge(:key_data => [private_key]) if private_key
    end

    def commands
      [ 'openssl version -v' ]
    end

    def private_key_path
      ::File.join(Dir.home, '.ec2', compute_server.key_name)
    end

    def private_key
      @private_key ||= private_key_path && File.read(private_key_path)
    end
  end
end
