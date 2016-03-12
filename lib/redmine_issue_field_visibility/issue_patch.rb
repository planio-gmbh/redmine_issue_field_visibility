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
        @hidden_core_fields ||= RedmineIssueFieldVisibility::hidden_core_fields  User.current, project
      end

      RedmineIssueFieldVisibility::HIDEABLE_CORE_FIELDS.each do |field|
        define_method field do
          super() unless hidden_core_field?(field)
        end
      end

    end
  end
end
