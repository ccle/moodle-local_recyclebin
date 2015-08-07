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
    Then I should see "Recycle bin"
    When I delete "Assignment to restore" activity
    And I delete "Another assignment to restore" activity
    And I follow "Recycle bin"
    Then I should see "Assignment to restore"
    And I should see "Another assignment to restore"
    When I click on "//tr[contains(., \"Assignment to restore\")]/td[starts-with(@id, \"recyclebin\")]/a[@alt=\"Restore\"]" "xpath_element"
    Then I should see "Assignment to restore has been restored"
    When I wait to be redirected
    And I click on "//tr[contains(., \"Another assignment to restore\")]/td[starts-with(@id, \"recyclebin\")]/a[@alt=\"Restore\"]" "xpath_element"
    Then I should see "Another assignment to restore has been restored"
    When I wait to be redirected
    And I follow "Go back"
    Then I should see "Assignment to restore" in the "Topic 1" "section"
    And I should see "Another assignment to restore" in the "Topic 1" "section"
    When I delete "Assignment to restore" activity
    And I delete "Another assignment to restore" activity
    And I follow "Recycle bin"
    Then I should see "Assignment to restore"
    And I should see "Another assignment to restore"
    When I click on "//tr[contains(., \"Assignment to restore\")]/td[starts-with(@id, \"recyclebin\")]/a[@alt=\"Delete\"]" "xpath_element"
    Then I should see "Assignment to restore has been deleted"
    When I wait to be redirected
    And I click on "//tr[contains(., \"Another assignment to restore\")]/td[starts-with(@id, \"recyclebin\")]/a[@alt=\"Delete\"]" "xpath_element"
    Then I should see "Another assignment to restore has been deleted"
    When I wait to be redirected
    And I follow "Go back"
    Then I should not see "Assignment to restore" in the "Topic 1" "section"
    And I should not see "Another assignment to restore" in the "Topic 1" "section"
