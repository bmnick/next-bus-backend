Feature: Manage welcomes
  In order to convince people this isn't a hacked out project
  Users
  want this website to have a decent intro page
  
  Scenario: Basic settings on the home page
    When I am on the home page
    Then I should see "Welcome to the Next Bus Helper"
    And I should see a link for "Sign in"
    And I should see a link for "Sign up"
    
    Given I am on the home page
    When I follow "Sign in"
    Then I should be on the sign in page
    
    Given I am on the home page
    When I follow "Sign up"
    Then I should be on the sign up page
    
  @wip
  Scenario: Route list should be shown on the home page
    Given I am on the home page
    Then I should see "Available Routes"
