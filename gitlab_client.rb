require 'gitlab'

class GitlabClient
  attr_accessor :project_name

  def initialize(endpoint, private_token, project_name)
    Gitlab.endpoint = endpoint
    Gitlab.private_token = private_token
    @project_name = project_name
    projects = nil
    begin
      projects = Gitlab.project_search(project_name)
      if projects.nil? or projects.count == 0
        raise ArgumentError, 'Project not found.'
      else
        @project = projects[0]
      end
    rescue => ex
      puts ex.message
    end
  end

  def generate_changelog()
    tags = Gitlab.tags(@project.id)
    mrs = Gitlab.merge_requests(@project.id)
    closed_issues = Gitlab.issues(@project.id, {state: 'closed'})

    tags.each_with_index do |current_tag, i|
      previously_tag = tags[i + 1].nil? ? NIL : tags[i + 1]
      current_tag_date = DateTime.parse(current_tag.commit.committed_date)

      puts "#{current_tag.name} (#{current_tag_date.strftime("%F")})"

      if previously_tag != NIL
        previously_tag_date = DateTime.parse(previously_tag.commit.committed_date)
        full_changelog = "#{@project.web_url}/compare/#{previously_tag.name}...#{current_tag.name}"
        puts "Full changelog: #{full_changelog}"

        puts 'Merge requests'
        mrs.each_with_index do |mr, i|
          mr_date = DateTime.parse(mr.updated_at)
          if mr_date > previously_tag_date and mr_date < current_tag_date
            puts "\##{mr.iid}: #{mr.title} (@#{mr.author.username})"
          end
        end

        puts 'Closed issues'
        closed_issues.each_with_index do |closed_issue, i|
          closed_issue_date = DateTime.parse(closed_issue.updated_at)
          if closed_issue_date > previously_tag_date and closed_issue_date < current_tag_date
            puts "\##{mr.iid}: #{mr.title} (@#{mr.assignee.username})"
          end
        end

        puts ''
      end
    end
  end
end