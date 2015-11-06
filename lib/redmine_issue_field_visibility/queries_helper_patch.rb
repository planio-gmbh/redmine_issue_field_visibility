module RedmineIssueFieldVisibility
  module QueriesHelperPatch
    def self.apply
      #QueriesHelper.send :prepend, InstanceMethods
      IssuesController.send :helper, InstanceMethods
    end

    module InstanceMethods
      def column_content(column, issue)
        super unless issue.hidden_core_field?(column.name)
      end
    end
  end
end

