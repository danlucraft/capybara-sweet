Feature: Submit my location
  As a user
  I should be able to choose and submit my location
  
  Scenario: See stuff
    When I visit "/"
    Then I should see "Choose country"

  Scenario: Choose a country and see city options
    When I visit "/"
    And I select "United Kingdom" from "country"
    Then I should see "Edinburgh"

  Scenario: Choose a country, and city and enter notes
    When I visit "/"
    And I select "United States" from "country"
    And I select "New York" from "city"
    And I enter "my home town!" into "notes"
    And I press "Submit Location"
    Then I should see "You chose the city New York in the country United States."
    And I should see "Your notes were 13 characters long"
