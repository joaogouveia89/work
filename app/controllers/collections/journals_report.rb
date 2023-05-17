class JournalsReport

    attr_reader :journals, :size, :meetings, :current_task, :team_interaction, :humor

    def initialize(journals)
        @journals = journals
        @size = @journals.size

        meetings = @journals.map{ |j| j.meetings }
        current_task = @journals.map{ |j| j.current_task }
        team_interaction = @journals.map{ |j| j.team_interaction }
        humor = @journals.map{ |j| j.humor }

        @meetings = attribute_rating meetings.size, meetings.tally
        @current_task = attribute_rating current_task.size, current_task.tally
        @team_interaction = attribute_rating team_interaction.size, team_interaction.tally
        @humor = attribute_rating humor.size, humor.tally
    end
    
    
    private

    def attribute_rating size, tallied
        {
            0 => percentage_calculation((tallied[0] == nil ? 0 : tallied[0]), size),
            1 => percentage_calculation((tallied[1] == nil ? 0 : tallied[1]), size),
            2 => percentage_calculation((tallied[2] == nil ? 0 : tallied[2]), size)
        }
    end

    def percentage_calculation value, hundred
        (100 * value) / hundred
    end
end