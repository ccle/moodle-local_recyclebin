@ucla @local_recyclebin @CCLE-5321
Feature: Restoring an assignment from bin.
  create a blank assignment, delete it,
  and restore it from the bin.

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

#  @javascript
#  Scenario: Make sure we can restore a blank assignment.
#    Given I log in as "teacher1"
#    And I follow "Course 1"
#    And I turn editing mode on
#    And I add a "Assignment" to section "1" and I fill the form with:
#      | Assignment name | Assignment to restore |
#      | Description | I'll be back. |
#    Then I should see "Assignment to restore" in the "Topic 1" "section"
#    Given I delete "Assignment to restore" activity
#    Then I should not see "Assignment to restore" in the "Topic 1" "section"
#    Given I reload the page
#    And I follow "Recycle bin"
#    Then I should see "Assignment to restore"
#    Given I click on "//tr[contains(., \"Assignment to restore\")]/td[starts-with(@id, \"recyclebin\")]/a[@alt=\"Restore\"]" "xpath_element"
#    And I wait to be redirected
#    Then I should see "Assignment to restore" in the "Topic 1" "section"

  @javascript
  Scenario: Make sure we can restore multiple assignments/
    Given I log in as "teacher1"
    And I follow "Course 1"
    And I turn editing mode on
    And I add a "Assignment" to section "1" and I fill the form with:
      | Assignment name | Assignment to restore |
      | Description | I'll be back. |
    Then I should see "Assignment to restore" in the "Topic 1" "section"
    And I add a "Assignment" to section "1" and I fill the form with:
      | Assignment name | Another assignment to restore |
      | Description | I'll be back too. |
    Then I should see "Assignment to restore" in the "Topic 1" "section"
    And I should see "Another assignment to restore" in the "Topic 1" "section"
    Given I delete "Assignment to restore" activity
    And I delete "Another assignment to restore" activity
    Then I should not see "Assignment to restore" in the "Topic 1" "section"
    And I should not see "Another assignment to restore" in the "Topic 1" "section"
    Given I reload the page
    And I follow "Recycle bin"
    Then I should see "Assignment to restore"
    And I should see "Another assignment to restore"
    Given I click on "//tr[contains(., \"Assignment to restore\")]/td[starts-with(@id, \"recyclebin\")]/a[@alt=\"Restore\"]" "xpath_element"
    Given I click on "//tr[contains(., \"Another assignment to restore\")]/td[starts-with(@id, \"recyclebin\")]/a[@alt=\"Restore\"]" "xpath_element"
    And I wait to be redirected
    Then I should see "Assignment to restore" in the "Topic 1" "section"
    And I should see "Another assignment to restore" in the "Topic 1" "section"
    Given I delete "Assignment to restore" activity
    And I delete "Another assignment to restore" activity
    Then I should not see "Assignment to restore" in the "Topic 1" "section"
    And I should not see "Another assignment to restore" in the "Topic 1" "section"
    Given I reload the page
    And I follow "Recycle bin"
    Then I should see "Assignment to restore"
    And I should see "Another assignment to restore"
    Given I click on "//tr[contains(., \"Assignment to restore\")]/td[starts-with(@id, \"recyclebin\")]/a[@alt=\"Delete\"]" "xpath_element"
    Given I click on "//tr[contains(., \"Another assignment to restore\")]/td[starts-with(@id, \"recyclebin\")]/a[@alt=\"Delete\"]" "xpath_element"
    And I wait to be redirected
    Then I should not see "Assignment to restore" in the "Topic 1" "section"
    And I should not see "Another assignment to restore" in the "Topic 1" "section"
