Feature: we can add tasks

Scenario: we add a task for today
    Given we have navigated to http://sfhaugland1.pythonanywhere.com
    When we add a task for today called "testing task"
    Then there should be one more task added

Scenario: we add a task for tomorrow
    Given we have navigated to http://sfhaugland1.pythonanywhere.com
    When we add a task for tomorrow called "testing task for tomorrow"
    Then there should be one more task added

Scenario: we add a task for someday
    Given we have navigated to http://sfhaugland1.pythonanywhere.com
    When we add a task for someday called "testing task for someday"
    Then there should be one more task added
