Feature: we can delete tasks

Scenario: we delete a task from today
    Given we have navigated to http://sfhaugland1.pythonanywhere.com
    When we delete a task
    Then there should no longer be a task 