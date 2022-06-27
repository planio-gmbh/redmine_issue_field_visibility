require File.expand_path('../../test_helper', __FILE__)

class HiddenCoreFieldsTest < ActiveSupport::TestCase
  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :trackers,
           :projects_trackers,
           :enabled_modules,
           :enumerations,
           :workflows,
           :journals,
           :journal_details

  setup do
    Setting.clear_cache
    @issue = Issue.find 1
    @issue.update_columns estimated_hours: 12, assigned_to_id: 3

    User.current = @user = User.find 2
  end

  test "should have no hidden core fields by default" do
    assert_equal [], @issue.hidden_core_fields
    assert_equal [], RedmineIssueFieldVisibility::hidden_core_fields(@user, @issue.project)
    assert @issue.safe_attribute_names.include?('estimated_hours')
  end

  test "should hide field for role" do
    with_settings('plugin_redmine_issue_field_visibility' => {
      'hiddenfields' => {
        '1' => {
          'estimated_hours' => '1'
        }
      }
    }) do
      issue = Issue.find 1
      assert_equal %w(estimated_hours), RedmineIssueFieldVisibility::hidden_core_fields(@user, issue.project)
      assert_equal %w(estimated_hours), issue.hidden_core_fields
      assert !@issue.safe_attribute_names.include?('estimated_hours')
    end
  end
end