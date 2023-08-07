module RedmineIssueFieldVisibility
  module Patches
    module IssuePatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          alias_method :disabled_core_fields_without_ifv, :disabled_core_fields
          alias_method :disabled_core_fields, :disabled_core_fields_with_ifv
          alias_method :reload_without_ifv, :reload
          alias_method :reload, :reload_with_ifv

          RedmineIssueFieldVisibility::HIDEABLE_CORE_FIELDS.each do |field|
            if Issue.method_defined?(field)
              alias_method "#{field}_without_ifv", field
              alias_method field, "#{field}_with_ifv"
            end
          end
        end
      end
      module InstanceMethods
        def disabled_core_fields_with_ifv
          (disabled_core_fields_without_ifv + hidden_core_fields).tap do |fields|
            fields.uniq!
          end
        end

        def hidden_core_field?(name)
          hidden_core_fields.include?(name.to_s) or
            hidden_core_fields.include?("#{name}_id")
        end

        def hidden_core_fields
          user = @user_for_hidden_core_fields || User.current
          @hidden_core_fields ||= {}
          @hidden_core_fields[user] ||= RedmineIssueFieldVisibility::hidden_core_fields user, project
        end

        def reload_with_ifv
          reload_without_ifv.tap { @hidden_core_fields = nil }
        end

        def with_hidden_core_fields_for_user(user, &block)
          @user_for_hidden_core_fields = user
          yield
        ensure
          @user_for_hidden_core_fields = nil
        end

        RedmineIssueFieldVisibility::HIDEABLE_CORE_FIELDS.each do |field|
          if Issue.method_defined?(field)
            define_method "#{field}_with_ifv" do
              send("#{field}_without_ifv") unless hidden_core_field?(field)
            end
          end
        end

        # WARNING: if changed here change in journal_patch too
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

Issue.include(RedmineIssueFieldVisibility::Patches::IssuePatch)
