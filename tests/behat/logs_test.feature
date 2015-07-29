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

  @javascript
  Scenario: Make sure we can restore a blank assignment.
    Given I log in as "teacher1"
    And I follow "Course 1"
    And I turn editing mode on
    And I add a "Assignment" to section "1" and I fill the form with:
      | Assignment name | Assignment to restore |
      | Description | I'll be back. |
    Given I delete "Assignment to restore" activity
    Given I reload the page
    And I follow "Recycle bin"
    Given I click on "//tr[contains(., \"Assignment to restore\")]/td[starts-with(@id, \"recyclebin\")]/a[@alt=\"Restore\"]" "xpath_element"
    And I wait to be redirected
    Then I log out
    Given I log in as "admin"
    And I navigate to "Logs" node in "Site administration > Reports"
    And I click on "Get these logs" "link_or_button"
    And I put a breakpoint
    Then "//tr[contains(., \"Course 1\") and contains(., \"Recycle bin\") and contains(., \"Item restored\")]" "xpath_element" should be visible
