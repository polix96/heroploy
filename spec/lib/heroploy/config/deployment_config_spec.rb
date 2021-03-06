require 'spec_helper'

describe Heroploy::Config::DeploymentConfig do
  before(:each) { stub_shell }
  
  let(:attrs) do
    {
      'travis_repo' => 'travis/my-repo',
      'environments' => {
        'staging' => {},
        'production' => {
          'variables' => {'foo' => 'foo'}
        }
      },
      'common' => {
        'required' => ['my-var'],
        'variables' => {'my-var' => 'some-value'}
      }
    }
  end
  
  subject(:deployment_config) { Heroploy::Config::DeploymentConfig.new(attrs) }
  
  describe "#initialize" do
    context "it initializes its environments" do
      its(:environments) { should include an_environment_named(:staging) }
      its(:environments) { should include an_environment_named(:production) }
    end
    
    context "it initializes its environment variables" do
      its('shared_env.required') { should eq(['my-var']) }
      its('shared_env.variables') { should eq({'my-var' => 'some-value'}) }
    end
    
    context "it initializes the travis repo" do
      its(:travis_repo) { should eq('travis/my-repo') }
    end
  end
  
  describe "#[]" do
    it "returns the environment with the given name, if one exists" do
      expect(deployment_config['staging']).to be_an_environment_named(:staging)
    end
    
    it "returns nil otherwise" do
      expect(deployment_config['development']).to be_nil
    end
  end
  
  describe "#merge_config" do
    let(:other_config) do
      build(:deployment_config, environments: [
        build(:environment, :production, variables: {'bar' => 'bar'})
      ])
    end
    
    it "merges the environment variables defined by the other config" do
      deployment_config.merge_config(other_config)
      expect(deployment_config['production'].variables).to include('foo' => 'foo')
      expect(deployment_config['production'].variables).to include('bar' => 'bar')
    end
  end
  
  describe ".load" do
    let(:yaml_config) do
      <<-END
      common:
        required:
          - my-var
        variables:
          my-var: some-value
      environments:
        heroku:
          app: my-app
      END
    end
    
    before { File.stub(:open).with('config/heroploy.yml').and_return(yaml_config) }
    
    let(:deployment_config) { deployment_config = Heroploy::Config::DeploymentConfig.load }
    
    it "it initializes the list of environments" do
      expect(deployment_config.environments).to include an_environment_named(:heroku)
    end
    
    it "initializes the shared environment variables" do
      expect(deployment_config.shared_env.required).to eq(['my-var'])
      expect(deployment_config.shared_env.variables).to eq({ 'my-var' => 'some-value' })
    end
  end
end
