@local_recyclebin
Feature: Basic recycle bin functionality
  As a teacher
  I want be able to recover deleted content
  So that I can fix a mistake or accidently deletion

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

  Scenario: Restore and delete an assingnment.
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
    And I am on homepage
    And I follow "Course 1"
    Then I should see "Assignment to restore" in the "Topic 1" "section"
    When I delete "Assignment to restore" activity
    And I follow "Recycle bin"
    Then I should see "Assignment to restore"
    When I follow "Delete"
    Then I should see "Assignment to restore has been deleted"
    When I wait to be redirected
    And I am on homepage
    And I follow "Course 1"
    Then I should not see "Assignment to restore" in the "Topic 1" "section"
