class Journal < ApplicationRecord
    enum radio_values: [ :bad, :medium, :good ]
end
