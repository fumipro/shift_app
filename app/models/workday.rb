class Workday < ApplicationRecord
    belongs_to :user
    validates :begin_time, presence: true
    validates :finish_time, presence: true
    validate :begin_finish_check, if: :present_begin_time_and_finish_time?

    def begin_finish_check
      errors.add(:finish_time, "終業時刻は始業時刻より後にしてください") if self.begin_time >= self.finish_time
    end

    private
    def present_begin_time_and_finish_time?
      begin_time.present? && finish_time.present?
    end

  end
