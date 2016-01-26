require 'slop'
require 'gitlab'

opts = Slop.parse do |o|
  o.string '-u', '--url', 'Project API URL'
  o.string '-p', '--project', 'Project name'
  o.string '-t', '--token', 'Private token'
  o.on '--help', 'Print the help' do
    puts o
    exit
  end
end

Gitlab.endpoint = opts[:url]
Gitlab.private_token = opts[:token]

projects = Gitlab.project_search(opts[:project])
if projects.count == 0
  raise ArgumentError, 'Project not found.'
end