@ucla @local_recyclebin @CCLE-5321 @CCLE-5335
Feature: Recycle bin refinements
  As an administrator
  I want the log to reflect the recycle bin's actions

  Background: Course with teacher exists.
    Given the following "users" exist:
      | username | firstname | lastname | email |
      | teacher1 | Teacher | 1 | teacher@asd.com |
    And the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1 |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher1 | C1 | editingteacher |
  
  Scenario: Make sure the recycle bin is logging.
    Given I log in as "teacher1"
    And I follow "Course 1"
    And I turn editing mode on
    And I add a "Assignment" to section "1" and I fill the form with:
      | Assignment name | Assignment to restore |
      | Description | I'll be back. |
    And I delete "Assignment to restore" activity
    And I follow "Recycle bin"
    And I follow "Delete" 
    And I wait to be redirected
    And I log out
    And I log in as "admin"
    And I follow "Course 1"
    And I follow "Logs"  
    And I click on "Get these logs" "link_or_button"
    Then I should see "Item purged" in the "Recycle bin" "table_row"
