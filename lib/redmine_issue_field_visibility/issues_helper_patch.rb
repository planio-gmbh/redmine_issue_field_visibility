module RedmineIssueFieldVisibility
  module IssuesHelperPatch
    def self.apply
      Mailer.send :helper, InstanceMethods
    end

    module InstanceMethods
      def email_issue_attributes(issue, user, *_)
        issue.with_hidden_core_fields_for_user(user) do
          super
        end
      end
    end
  end
end
