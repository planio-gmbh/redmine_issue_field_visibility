module RedmineIssueFieldVisibility
  module JournalPatch

    def self.apply
      Journal.send :prepend, InstanceMethods
    end

    module InstanceMethods
      def visible_details(user = User.current)
        super.select do |detail|
          if 'Issue' == journalized_type
            !journalized.hidden_core_fields.include?(detail.prop_key)
          else
            true
          end
        end
      end
    end

  end
end

