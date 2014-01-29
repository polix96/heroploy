require 'coveralls'
Coveralls.wear! do
  add_filter '/spec/'
end
    
require 'factory_girl'
require 'rails/generators'

require "generator_spec/test_case"
require "generator_spec/matcher"

require 'heroploy'
require 'heroploy/tasks/deploy_task_lib'

require 'support/shell_support'
require 'support/shared_contexts/rake'
require 'support/shared_contexts/generator'

FactoryGirl.find_definitions

TMP_ROOT = Pathname.new(File.expand_path('../tmp', __FILE__))

RSpec.configure do |config|
  config.color_enabled = true
  
  config.include FactoryGirl::Syntax::Methods
  
  config.include ShellSupport
end
