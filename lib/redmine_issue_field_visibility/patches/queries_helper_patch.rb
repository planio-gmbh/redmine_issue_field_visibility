require_dependency 'queries_helper'

module RedmineIssueFieldVisibility
  module Patches
    module QueriesHelperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          alias_method :column_content_without_ifv, :column_content
          alias_method :column_content, :column_content_with_ifv
        end
      end

      module InstanceMethods
        def column_content_with_ifv(column, issue)
          column_content_without_ifv(column, issue) unless issue.hidden_core_field?(column.name)
        end
      end
    end
  end
end

QueriesHelper.include(RedmineIssueFieldVisibility::Patches::QueriesHelperPatch)
