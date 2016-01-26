require 'slop'

opts = Slop.parse do |o|
  o.string '-u', '--url', 'Project API URL'
  o.integer '-t', '--token', 'Private token'
  o.on '--help', 'Print the help' do
    puts o
    exit
  end
end

projects = Gitlab.project_search('gitlab-changelog-generator')
if projects.count == 0
  raise ArgumentError, 'Project not found.'
end