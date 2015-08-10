@ucla @local_recyclebin @CCLE-5321 @CCLE-5333
Feature: Recycle bin refinements
  As an administrator
  I want the recycle bin to have basic functionality

  Background: Course with teacher exists.
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

  Scenario: Basic recycle bin functionality
    Given I log in as "teacher1"
    And I follow "Course 1"
    And I turn editing mode on
    And I add a "Assignment" to section "1" and I fill the form with:
      | Assignment name | Assignment to restore |
      | Description | I'll be back. |
    Then I should see "Recycle bin"
    When I delete "Assignment to restore" activity
    And I follow "Recycle bin"
    Then I should see "Assignment to restore"
    When I follow "Restore"
    Then I should see "Assignment to restore has been restored"
    When I wait to be redirected
    And I follow "Go back"
    Then I should see "Assignment to restore" in the "Topic 1" "section"
    When I delete "Assignment to restore" activity
    And I follow "Recycle bin"
    Then I should see "Assignment to restore"
    When I follow "Delete"
    Then I should see "Assignment to restore has been deleted"
    When I wait to be redirected
    And I follow "Go back"
    Then I should not see "Assignment to restore" in the "Topic 1" "section"
