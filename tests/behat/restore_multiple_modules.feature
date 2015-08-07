@ucla @local_recyclebin @CCLE-5321 @CCLE-5333 @ha999
  Feature: restore multiple modules.

  Background: Course with teacher and student exist.
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

    @javascript
    Scenario: restore file uploaded
     Given I log in as "teacher1"
      And I follow "Course 1"
      And I turn editing mode on
    Given I add a "File" to section "1"
    Given I set the following fields to these values:
      | Name | Test file with recycle bin |
      | Description | file to be restore |
    And I upload "local/recyclebin/tests/behat/restore_upload_file.feature" file to "Select files" filemanager
    And I press "Save and return to course"
    Then I should see "Test file with recycle bin" in the "Topic 1" "section"
    Given I delete "Test file with recycle bin" activity
    Then I should not see "Test file with recycle bin" in the "Topic 1" "section"
    Given I reload the page
    And I follow "Recycle bin"
    Then I should see "Test file with recycle bin"
    Given I click on "//tr[contains(., \"Test file with recycle bin\")]/td[starts-with(@id, \"recyclebin\")]/a[@alt=\"Restore\"]" "xpath_element"
    And I wait to be redirected
    Given I follow "Go back"
    Then I should see "Test file with recycle bin" in the "Topic 1" "section"
    Then following "Test file with recycle bin" should download between "1500" and "2000" bytes

    @javascript
    Scenario: restore folder with two files
     Given I log in as "teacher1"
      And I follow "Course 1"
      And I turn editing mode on
    Given I add a "Folder" to section "1"
    Given I set the following fields to these values: 
      | Name | Test Folder to be restore |
      | Description | This is a folder to be restore |
    And I upload "local/recyclebin/tests/behat/restore_upload_file.feature" file to "Files" filemanager
    And I upload "local/recyclebin/tests/behat/restore_folder.feature" file to "Files" filemanager
    Then I press "Save and return to course"
    Then I should see "Test Folder to be restore" in the "Topic 1" "section"
    When I click on "Test Folder to be restore" "link_or_button"
    Then I should see "restore_folder.feature"
    And I should see "restore_upload_file.feature"
    And I follow "Course 1"
    Given I delete "Test Folder to be restore" activity
    Then I should not see "Test Folder to be restore" in the "Topic 1" "section"
    Given I reload the page
    And I follow "Recycle bin"
    Then I should see "Test Folder to be restore"
    Given I click on "//tr[contains(., \"Test Folder to be restore\")]/td[starts-with(@id, \"recyclebin\")]/a[@alt=\"Restore\"]" "xpath_element"
    And I wait to be redirected
    Given I follow "Go back"
    Then I should see "Test Folder to be restore" in the "Topic 1" "section"
    When I click on "Test Folder to be restore" "link_or_button"
    Then following "restore_upload_file.feature" should download between "1500" and "2000" bytes
    Then following "restore_folder.feature" should download between "2000" and "2500" bytes

