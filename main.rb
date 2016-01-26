require 'slop'
require_relative 'gitlab_client'

opts = Slop.parse do |o|
  o.string '-u', '--url', 'Project API URL'
  o.string '-p', '--project', 'Project name'
  o.string '-t', '--token', 'Private token'
  o.on '--help', 'Print the help' do
    puts o
    exit
  end
end


client = GitlabClient.new(opts[:url], opts[:token], opts[:project])
client.generate_changelog()