json.extract! journal, :id, :meetings, :current_task, :team_interaction, :humor, :comments, :created_at, :updated_at
json.url journal_url(journal, format: :json)
