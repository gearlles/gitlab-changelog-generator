require 'gitlab'

class GitlabClient
  attr_accessor :project_name

  def initialize(endpoint, private_token, project_name)
    Gitlab.endpoint = endpoint
    Gitlab.private_token = private_token
    @project_name = project_name
    projects = Gitlab.project_search(project_name)
    if projects.count == 0
      raise ArgumentError, 'Project not found.'
    end
    @project = projects[0]
  end

  def generate_changelog()
    
  end
end