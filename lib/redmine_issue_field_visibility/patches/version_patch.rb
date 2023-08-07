module RedmineIssueFieldVisibility
  module Patches
    module VersionPatch
      def self.included(base)
        base.class_eval do
          alias_method :estimated_hours_without_ifv, :estimated_hours
          alias_method :estimated_hours, :estimated_hours_with_ifv
        end
      end

      def estimated_hours_with_ifv
        if RedmineIssueFieldVisibility.hidden_core_fields(User.current, project).include?("estimated_hours")
          0
        else
          estimated_hours_without_ifv
        end
      end
    end
  end
end

Version.include(RedmineIssueFieldVisibility::Patches::VersionPatch)
