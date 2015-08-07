@ucla @local_recyclebin @CCLE-5334 @CCLE-5321
Feature: restore folder
  create a folder with two files, delete the folder
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
    Then I should see "Test Folder to be restore" in the "Topic 1" "section"
    When I click on "Test Folder to be restore" "link_or_button"
    Then following "restore_upload_file.feature" should download between "1500" and "2000" bytes
    Then following "restore_folder.feature" should download between "2000" and "2500" bytes
