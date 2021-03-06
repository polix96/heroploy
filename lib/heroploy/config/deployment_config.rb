require 'heroploy/config/deployment_config'
require 'heroploy/config/environment'
require 'heroploy/config/shared_env'
require 'heroploy/config/remote_config'
require 'heroploy/commands/shell'
require 'heroploy/commands/git'

module Heroploy
  module Config
    class DeploymentConfig
      attr_accessor :travis_repo
      attr_accessor :environments
      attr_accessor :shared_env
      attr_accessor :remote_configs
      
      include Commands::Git

      def [](env_name)
        environments.select{ |env| env.name == env_name }.first
      end

      def initialize(attrs = {})
        @travis_repo = attrs['travis_repo']
        unless attrs['environments'].nil?
          @environments = attrs['environments'].map { |name, env_attrs| Environment.new(name, env_attrs) }
        end
        unless attrs['load_configs'].nil?
          @remote_configs = attrs['load_configs'].map { |name, remote_config_attrs| RemoteConfig.new(name, remote_config_attrs) }
        end
        @shared_env = SharedEnv.new(attrs['common'])
      end
  
      def self.load(filename = 'config/heroploy.yml')
        DeploymentConfig.new(YAML::load(File.open(filename)))
      end
      
      def merge_config(deployment_config)
        deployment_config.environments.each do |env_config|
          self[env_config.name].variables.merge!(env_config.variables)
        end
      end
      
      def load_remotes!
        unless remote_configs.nil? || Rails.env.test?
          remote_configs.each do |remote_config|
            git_clone(remote_config.repository, remote_config.name) do
              remote_config.files.each do |filename|
                config_file = File.join(Dir.pwd, remote_config.name, filename)
                merge_config(Heroploy::Config::DeploymentConfig.load(config_file))
              end
            end
          end
        end
      end
    end
  end
end
