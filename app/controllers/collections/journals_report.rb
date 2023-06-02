class JournalsReport

    attr_reader :journals, :size, :meetings, :current_task, :team_interaction, :humor

    def initialize(journals)
        @journals = journals
        @size = @journals.size

        meetings = @journals.map{ |j| j.meetings }
        current_task = @journals.map{ |j| j.current_task }
        team_interaction = @journals.map{ |j| j.team_interaction }
        humor = @journals.map{ |j| j.humor }

        @meetings = new_hash().merge(meetings.tally)
        @current_task = new_hash().merge(current_task.tally)
        @team_interaction = new_hash().merge(team_interaction.tally)
        @humor = new_hash().merge(humor.tally)
    end

    private

    def new_hash
        {0 => 0, 1 => 0, 2 => 0}
    end
end