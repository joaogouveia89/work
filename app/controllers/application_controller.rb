class ApplicationController < ActionController::Base
    before_action :last_updates_info , only: %i[ index ]

    def today
        Time.now
    end

    def last_updates_info
        last_updates_git_command = `git log -1 --date=format:'%d/%m/%Y' --format="%cd - %B"`
        last_updates_git_command = last_updates_git_command.split('-')
        @last_updates = {:date => last_updates_git_command[0].strip, :commit_message => last_updates_git_command[1].strip.humanize }
    end
end
