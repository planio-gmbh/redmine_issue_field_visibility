#encoding: utf-8

Redmine::Plugin.register :redmine_issue_field_visibility do
  name 'Redmine Issue Field Visibility Plugin'
  url  'https://github.com/planio-gmbh/redmine_issue_field_visibility'

  description 'Hide core issue fields per role'

  author     'Jens Krämer, Planio GmbH'
  author_url 'https://plan.io/'

  version '1.1.0'

  requires_redmine version_or_higher: '3.3.14'

  settings partial: 'settings/redmine_issue_field_visibility', default: {}
end

require File.dirname(__FILE__) + '/lib/redmine_issue_field_visibility/redmine_issue_field_visibility'
require File.dirname(__FILE__) + '/lib/redmine_issue_field_visibility/patches/queries_helper_patch'
require File.dirname(__FILE__) + '/lib/redmine_issue_field_visibility/patches/issues_helper_patch'
require File.dirname(__FILE__) + '/lib/redmine_issue_field_visibility/patches/issue_patch'
require File.dirname(__FILE__) + '/lib/redmine_issue_field_visibility/patches/issue_query_patch'
require File.dirname(__FILE__) + '/lib/redmine_issue_field_visibility/patches/journal_patch'
require File.dirname(__FILE__) + '/lib/redmine_issue_field_visibility/patches/version_patch'
