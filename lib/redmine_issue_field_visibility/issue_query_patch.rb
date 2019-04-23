module RedmineIssueFieldVisibility
  module IssueQueryPatch

    def self.apply
      IssueQuery.send :prepend, InstanceMethods
    end

    module InstanceMethods
      def initialize_available_filters
        super

        hidden_core_fields.each do |field|
          delete_available_filter field
        end
      end

      def available_columns
        return @available_columns if @available_columns
        super
        @available_columns.reject! do |col|
          hidden_core_fields.include? col.name.to_s
        end
        @available_columns
      end

      def hidden_core_fields
        @hidden_core_fields ||= begin
          fields = RedmineIssueFieldVisibility.hidden_core_fields(
            User.current, project
          )
          if fields.include?("estimated_hours")
            fields << "total_estimated_hours"
          end
          fields
        end
      end

    end

  end
end

