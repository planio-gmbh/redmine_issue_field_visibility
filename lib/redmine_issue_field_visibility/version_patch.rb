module RedmineIssueFieldVisibility
  module VersionPatch
    module FixedIssuesAssocPatch
      def estimated_hours
        project = proxy_association.owner.project
        if RedmineIssueFieldVisibility.hidden_core_fields(User.current, project).include?("estimated_hours")
          0
        else
          super
        end
      end
    end

    def self.apply
      unless VersionFixedIssuesAssociationExtension < FixedIssuesAssocPatch
        VersionFixedIssuesAssociationExtension.prepend FixedIssuesAssocPatch
      end
    end

  end
end
