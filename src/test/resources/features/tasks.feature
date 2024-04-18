Feature: Task Management

  Scenario: Add Task
    Given the user provides valid Task details
    When the user sends a POST request to "/tasks"
    Then the response status code of account registration should be 200
    And the response body should contain the created account ID "teisisis-sjsks-eisisi"

#  Scenario: Get an existing Task
#    Given an existing account with ID "teisisis-sjsks-eisisi"
#    When the user sends a GET request to "/tasks"
#    Then the response status code of getting an Task should be 200
#    And the response body should contain the Task details