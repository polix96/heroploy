require 'heroploy/config/environment_checks'

module Heroploy
  module Config  
    class Environment
      attr_accessor :name
      attr_accessor :remote
      attr_accessor :app
      attr_accessor :tag
      attr_accessor :checks
      
      def initialize(name = nil, attrs = {})
        @name = name
        @remote = attrs['remote'] || name
        @app = attrs['app']
        @tag = attrs['tag']
        @checks = EnvironmentChecks.new(attrs['checks'])
      end
    end
  end
end
