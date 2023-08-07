require_dependency 'issue_query'

module RedmineIssueFieldVisibility
  module Patches
    module IssueQueryPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          alias_method :initialize_available_filters_without_ifv, :initialize_available_filters
          alias_method :initialize_available_filters, :initialize_available_filters_with_ifv
          alias_method :available_columns_without_ifv, :available_columns
          alias_method :available_columns, :available_columns_with_ifv
        end
      end
      module InstanceMethods
        def initialize_available_filters_with_ifv
          initialize_available_filters_without_ifv

          hidden_core_fields.each do |field|
            delete_available_filter field
          end
        end

        def available_columns_with_ifv
          return @available_columns if @available_columns

          @available_columns = available_columns_without_ifv.reject do |col|
            hidden_core_fields.include?(col.name.to_s) || hidden_core_fields.include?("#{col.name}_id")
            end
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
end

IssueQuery.include(RedmineIssueFieldVisibility::Patches::IssueQueryPatch)
