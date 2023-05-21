class Event < ApplicationRecord
    default_scope -> { order(:start_time) }
    validates :start_time, presence: true
    validates :title, presence: true, length: { maximum: 10 }
end
