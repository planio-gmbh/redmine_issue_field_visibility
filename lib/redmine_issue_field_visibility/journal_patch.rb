module RedmineIssueFieldVisibility
  module JournalPatch

    def self.apply
      Journal.send :prepend, InstanceMethods
    end

    module InstanceMethods
      def visible_details(user = User.current)
        super.select do |detail|
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

