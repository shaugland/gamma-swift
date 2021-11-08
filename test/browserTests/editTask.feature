Feature: we can edit tasks

Scenario: we edit a task from today
    Given we have navigated to http://sfhaugland1.pythonanywhere.com
    When we edit a task 
    Then the task should be different