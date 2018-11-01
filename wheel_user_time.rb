class WheelUserTime < ApplicationRecord
  belongs_to :user

  def increase_total_times(by)
    increment!(:total_times, by)
  end

  def increase_today_times(by = 1)
    increment!(:today_times, by)
  end
end
