class Ticket < ApplicationRecord
    enum status: [ :open, :pr_opened, :closed ]

    def status_title
        unless status == Ticket.statuses.key(1)
            status.titleize
        else
            status.titleize.sub("Pr", "PR")
        end
    end
end
