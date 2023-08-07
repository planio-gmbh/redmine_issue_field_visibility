module RedmineIssueFieldVisibility
  module Patches
    module JournalPatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)

        base.class_eval do
          alias_method :visible_details_without_ifv, :visible_details
          alias_method :visible_details, :visible_details_with_ifv
        end
      end
      module InstanceMethods
        def visible_details_with_ifv(user = User.current)
          visible_details_without_ifv(user).select do |detail|
            if 'Issue' == journalized_type
              journalized.with_hidden_core_fields_for_user(user) do
                !journalized.hidden_core_fields.include?(detail.prop_key)
              end
            else
              true
            end
          end
        end

        # WARNING: if changed here change in issue_patch too
        def each_notification(users, &block)
          users.group_by do |user|
            if user.admin?
              :admin
            else
              user.roles_for_project(project).sort
            end
          end.values.each do |part|
            super(part, &block)
          end
        end
      end
    end
  end
end

Journal.include(RedmineIssueFieldVisibility::Patches::JournalPatch)
