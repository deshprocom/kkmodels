class WheelUserTime < ApplicationRecord
  belongs_to :user

  def increase_total_times(by = 1)
    increment!(:total_times, by)
  end

  def increase_today_times(by = 1)
    increment!(:today_times, by)
  end

  def remain_times
    total_times - today_times
  end
end
