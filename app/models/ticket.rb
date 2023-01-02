class Ticket < ApplicationRecord
    enum status: [ :open, :closed ]
end
