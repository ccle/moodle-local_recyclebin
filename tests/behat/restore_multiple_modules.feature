@ucla @local_recyclebin @CCLE-5321 @CCLE-5334 
Feature: Recycle bin refinements
  As an administrator
  I want to be able to delete and restore multiple types of modules

  Background: Course with teacher and student exist.
    Given the following "users" exist:
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
    And I log in as "student1"
    And I follow "Course 1"
    And I follow "Quiz 1"
    And I press "Attempt quiz now"
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
    And I follow "Recycle bin"
    And I follow "Restore"
    And I log out
    And I log in as "student1"
    And I follow "Course 1"
    And I follow "Grades"
    Then "Quiz 1" row "Grade" column of "user-report-table" table should contain "5"
    And "Quiz 1" row "Percentage" column of "user-report-table" table should contain "50"
 
  @javascript
  Scenario: restore file uploaded
    Given I log in as "teacher1"
    And I follow "Course 1"
    And I turn editing mode on
    And I add a "File" to section "1"
    And I set the following fields to these values:
      | Name | Test file with recycle bin |
      | Description | file to be restore |
    And I wait to be redirected
    And I upload "lib/tests/fixtures/empty.txt" file to "Select files" filemanager
    And I press "Save and return to course"
    Then I should see "Test file with recycle bin" in the "Topic 1" "section"
    When I delete "Test file with recycle bin" activity
    Then I should not see "Test file with recycle bin" in the "Topic 1" "section"
    When I follow "Recycle bin"
    Then I should see "Test file with recycle bin"
    When I follow "Restore"
    And I follow "Go back"
    Then I should see "Test file with recycle bin" in the "Topic 1" "section"
    And following "Test file with recycle bin" should download between "0" and "50" bytes

  @javascript
  Scenario: restore folder with two files
    Given I log in as "teacher1"
    And I follow "Course 1"
    And I turn editing mode on
    And I add a "Folder" to section "1"
    And I set the following fields to these values: 
      | Name | Test Folder to be restore |
      | Description | This is a folder to be restore |
    And I upload "lib/tests/fixtures/empty.txt" file to "Files" filemanager
    And I upload "lib/tests/fixtures/upload_users.csv" file to "Files" filemanager
    And I press "Save and return to course"
    Then I should see "Test Folder to be restore" in the "Topic 1" "section"
    When I click on "Test Folder to be restore" "link_or_button"
    Then I should see "empty.txt"
    And I should see "upload_users.csv"
    When I follow "Course 1"
    And I delete "Test Folder to be restore" activity
    Then I should not see "Test Folder to be restore" in the "Topic 1" "section"
    When I follow "Recycle bin"
    Then I should see "Test Folder to be restore"
    When I follow "Restore"
    And I follow "Go back"
    Then I should see "Test Folder to be restore" in the "Topic 1" "section"
    When I click on "Test Folder to be restore" "link_or_button"
    Then following "empty.txt" should download between "0" and "50" bytes
    And following "upload_users.csv" should download between "150" and "200" bytes
