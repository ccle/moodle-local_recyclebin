@ucla @local_recyclebin @CCLE-5321 @CCLE-5333
Feature: Restoring an assignment from bin.
  create a blank assignment, delete it,
  and restore it from the bin.

  Background: Course with teacher exists.
    Given I am in a ucla environment
    And the following "users" exist:
      | username | firstname | lastname | email |
      | teacher1 | Teacher | 1 | teacher@asd.com |
      | student1 | Student | 1 | student@asd.com |
    And the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1 |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher1 | C1 | editingteacher |
      | student1 | C1 | student |
#    And I set the private config setting "forced_plugin_settings['backup']['backup_general_groups']" to "0"

  @javascript
  Scenario: Basic recycle bin functionality
    Given I log in as "teacher1"
    And I follow "Course 1"
    And I turn editing mode on
    When I add a "Assignment" to section "1" and I fill the form with:
      | Assignment name | Assignment to restore |
      | Description | I'll be back. |
    And I add a "Assignment" to section "1" and I fill the form with:
      | Assignment name | Another assignment to restore |
      | Description | I'll be back too. |
    And I should see "Recycle bin"
    When I delete "Assignment to restore" activity
    And I delete "Another assignment to restore" activity
    And I follow "Recycle bin"
    Then I should see "Assignment to restore"
    And I should see "Another assignment to restore"
    When I click on "//tr[contains(., \"Assignment to restore\")]/td[starts-with(@id, \"recyclebin\")]/a[@alt=\"Restore\"]" "xpath_element"
    And I click on "//tr[contains(., \"Another assignment to restore\")]/td[starts-with(@id, \"recyclebin\")]/a[@alt=\"Restore\"]" "xpath_element"
    And I click on "Go back" "link_or_button"
    Then I should see "Assignment to restore" in the "Topic 1" "section"
    And I should see "Another assignment to restore" in the "Topic 1" "section"
    When I delete "Assignment to restore" activity
    And I delete "Another assignment to restore" activity
    And I follow "Recycle bin"
    Then I should see "Assignment to restore"
    And I should see "Another assignment to restore"
    When I click on "//tr[contains(., \"Assignment to restore\")]/td[starts-with(@id, \"recyclebin\")]/a[@alt=\"Delete\"]" "xpath_element"
    And I click on "//tr[contains(., \"Another assignment to restore\")]/td[starts-with(@id, \"recyclebin\")]/a[@alt=\"Delete\"]" "xpath_element"
    And I click on "Go back" "link_or_button"
    Then I should not see "Assignment to restore" in the "Topic 1" "section"
    And I should not see "Another assignment to restore" in the "Topic 1" "section"

  @javascript
  Scenario: Delete and restore different types of modules.
    Test with: a file and a quiz
    Given I log in as "teacher1"
    And I follow "Course 1"
    And I turn editing mode on
    And I add a "Quiz" to section "1" and I fill the form with:
      | Name        | Quiz 1                |
      | Description | Test quiz description |
    And I add a "True/False" question to the "Quiz 1" quiz with:
      | Question name                      | TF1                          |
      | Question text                      | First question               |
      | General feedback                   | Thank you, this is the general feedback |
      | Correct answer                     | False                                   |
      | Feedback for the response 'True'.  | So you think it is true                 |
      | Feedback for the response 'False'. | So you think it is false                |
    And I add a "True/False" question to the "Quiz 1" quiz with:
      | Question name                      | TF2                          |
      | Question text                      | Second question               |
      | General feedback                   | Thank you, this is the general feedback |
      | Correct answer                     | False                                   |
      | Feedback for the response 'True'.  | So you think it is true                 |
      | Feedback for the response 'False'. | So you think it is false                |
    And I log out
    Given I log in as "student1"
    And I follow "Course 1"
    And I follow "Quiz 1"
    And I press "Attempt quiz now"
    And I press "Start attempt"
    And I click on "True" "radio" in the "First question" "question"
    And I click on "False" "radio" in the "Second question" "question"
    And I press "Next"
    And I press "Submit all and finish"
    And I click on "Submit all and finish" "button" in the "Confirmation" "dialogue"
    Then I should see "5.00 out of 10.00"
    Given I log out
    And I log in as "admin"
    And I follow "Course 1"
    And I turn editing mode on
    And I delete "Quiz 1" activity
    And I reload the page
    And I follow "Recycle bin"
    And I click on "//tr[contains(., \"Quiz 1\")]/td[starts-with(@id, \"recyclebin\")]/a[@alt=\"Restore\"]" "xpath_element"
    And I wait to be redirected
    And I log out
    And I log in as "student1"
    And I follow "Course 1"
    And I follow "Grades"
    Then "Quiz 1" row "Grade" column of "user-report-table" table should contain "5"
    And "Quiz 1" row "Percentage" column of "user-report-table" table should contain "50"
