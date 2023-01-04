class Daily < ApplicationRecord
  belongs_to :ticket

  def notes_truncated
    self.notes.truncate(NOTE_TRUNCATED_SIZE)
  end

  private
  NOTE_TRUNCATED_SIZE = 100
end
