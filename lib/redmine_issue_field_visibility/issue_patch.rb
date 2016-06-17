module RedmineIssueFieldVisibility
  module IssuePatch
    def self.apply
      Issue.send :prepend, InstanceMethods
    end

    module InstanceMethods
      def disabled_core_fields
        (super + hidden_core_fields).tap do |fields|
          fields.uniq!
        end
      end

      def hidden_core_field?(name)
        hidden_core_fields.include?(name.to_s) or
          hidden_core_fields.include?("#{name}_id")
      end

      def hidden_core_fields
        user = @user_for_hidden_core_fields || User.current
        @hidden_core_fields = {}
        @hidden_core_fields[user] ||= RedmineIssueFieldVisibility::hidden_core_fields user, project
      end

      def with_hidden_core_fields_for_user(user, &block)
        @user_for_hidden_core_fields = user
        yield
      ensure
        @user_for_hidden_core_fields = nil
      end

      RedmineIssueFieldVisibility::HIDEABLE_CORE_FIELDS.each do |field|
        define_method field do
          super() unless hidden_core_field?(field)
        end
      end

      def each_notification(users, &block)
        users.group_by do |user|
          user.roles_for_project(project).sort
        end.values.each do |part|
          super(part, &block)
        end
      end
    end
  end
end
