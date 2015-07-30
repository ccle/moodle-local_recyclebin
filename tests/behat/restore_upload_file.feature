@ucla @local_recyclebin @CCLE-5321
Feature: restore uploaded file
  upload a file, delete it
  and restore it from recycle bin

  Background: Course with teacher exists.
    Given I am in a ucla environment
    And the following "users" exist:
      | username | firstname | lastname | email |
      | teacher1 | Teacher | 1 | teacher@asd.com |
    And the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1 |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher1 | C1 | editingteacher |

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
    Then I should see "Test file with recycle bin" in the "Topic 1" "section"
    Then following "Test file with recycle bin" should download between "1500" and "2000" bytes
