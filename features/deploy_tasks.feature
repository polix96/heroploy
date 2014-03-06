Feature: Environment tasks

  Scenario: Successful deployment

    Given a development environment
    When I run "development:deploy"
    Then heroploy should invoke "development:check:all"
    And heroploy should invoke "development:push"
    And heroploy should invoke "development:config"
    And heroploy should invoke "development:db:migrate"
    And heroploy should invoke "development:tag"

  Scenario: Failing build check
  
    Given a staging environment
    When the travis build is failing
    And I have "master" checked out
    And I run "staging:deploy"
    Then the task should fail with "Failing Travis build for branch master"
    
  Scenario: Failing branch check
  
    Given a staging environment
    When I have "my-development-branch" checked out
    And I run "staging:deploy"
    Then the task should fail with "Cannot deploy branch my-development-branch to staging"
    
  Scenario: Failing remote check
  
    Given a staging environment
    When my branch is ahead of origin
    And I have "master" checked out
    And I run "staging:deploy"
    Then the task should fail with "Branch master is behind origin/master"
    
  Scenario: Failing staged check
  
    Given a production environment
    And a staging environment
    When I have "master" checked out
    And my changes aren't yet staged
    And I run "production:deploy"
    Then the task should fail with "Changes not yet staged on staging"