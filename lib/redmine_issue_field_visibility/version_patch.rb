module RedmineIssueFieldVisibility
  module VersionPatch
    def estimated_hours
      if RedmineIssueFieldVisibility.hidden_core_fields(User.current, project).include?("estimated_hours")
        0
      else
        super
      end
    end

    def self.apply
      Version.prepend self unless Version < self
    end

  end
end
