class Ticket < ApplicationRecord
    has_many :dailies
    enum status: [ :open, :pr_opened, :closed ]

    def status_title
        unless status == Ticket.statuses.key(1)
            status.titleize
        else
            status.titleize.sub("Pr", "PR")
        end
    end

    def past_days
        dailies = self.dailies.order(updated_at: :desc).pluck(:updated_at)
        if dailies.size == 0
          0
        else
          end_reference = self.open? ? DateTime.now.to_date : dailies.first.to_date
          (end_reference -  dailies.last.to_date).to_i
        end
      end
end
