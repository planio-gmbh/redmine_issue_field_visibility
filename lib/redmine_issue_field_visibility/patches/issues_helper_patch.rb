module RedmineIssueFieldVisibility
  module Patches
    module IssuesHelperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          alias_method :email_issue_attributes_without_ifv, :email_issue_attributes
          alias_method :email_issue_attributes, :email_issue_attributes_with_ifv
        end
      end
      module InstanceMethods
        def email_issue_attributes_with_ifv(issue, user, *_)
          issue.with_hidden_core_fields_for_user(user) do
            email_issue_attributes_without_ifv(issue, user, *_)
          end
        end
      end
    end
  end
end

IssuesHelper.include(RedmineIssueFieldVisibility::Patches::IssuesHelperPatch)
