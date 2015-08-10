@ucla @local_recyclebin @CCLE-5321 @CCLE-5336
Feature: Recycle bin refinements

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
    And the following config values are set as admin:
      | expiry | 10 | local_recyclebin |

  @javascript
  Scenario: Test for Recycle bin refinements of CCLE-5298.
    Given I log in as "teacher1"
    And I follow "Course 1"
    And I turn editing mode on
    And I add a "Assignment" to section "1" and I fill the form with:
      | Assignment name | Assignment to restore |
      | Description | I'll be back. |
    And I add a "Assignment" to section "1" and I fill the form with:
      | Assignment name | Another assignment to restore |
      | Description | I'll be back too. |
    And I add a "Assignment" to section "1" and I fill the form with:
      | Assignment name | Third assignment to restore |
      | Description | I'll be back too. |
    Then I should see "Recycle bin"
    When I delete "Assignment to restore" activity
    And I delete "Another assignment to restore" activity
    And I delete "Third assignment to restore" activity
    And I follow "Recycle bin"
    Then I should see "Assignment to restore"
    And I should see "Another assignment to restore"
    And I should see "Third assignment to restore"
    And I should not see "Empty Recycle Bin"
    And I should not see "The recycle bin currently has no items"
    When I follow "Delete"
    Then I should see "Are you sure you want to delete the selected item(s) in the recycle bin?"
    # Can't find the button "Yes" without the javascript tag
    When I press "Yes"
    And I follow "Delete all"
    Then I should see "Are you sure you want to delete the selected item(s) in the recycle bin?"
    When I press "Yes"
    And I follow "Go back"
    Then I should not see "Assignment to restore" in the "Topic 1" "section"
    And I should not see "Another assignment to restore" in the "Topic 1" "section"
    And I should not see "Third assignment to restore" in the "Topic 1" "section"
    When I follow "Recycle bin"
    Then I should see "There are no items in the recycle bin."
    And I should see "Contents will be permanently deleted after 10 days."
    And I should see "Items that have been deleted from a course can be restored and will appear at the bottom of the section from which they were deleted."
