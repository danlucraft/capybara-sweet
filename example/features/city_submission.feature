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
