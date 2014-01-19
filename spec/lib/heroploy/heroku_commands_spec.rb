require 'spec_helper'

describe HerokuCommands do
  let(:commands) { Object.new.extend(HerokuCommands) }
  
  context "#heroku_exec" do
    it "executes the heroku command for the given app" do
      expect_command("heroku help --app my-app")
      commands.heroku_exec("help", "my-app")
    end
  end
  
  context "#heroku_run" do
    it "runs the given command on the heroku server" do
      expect_command("heroku run db:migrate --app my-app")
      commands.heroku_run("db:migrate", "my-app")
    end
  end
end