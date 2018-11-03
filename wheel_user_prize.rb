class WheelUserPrize < ApplicationRecord
  belongs_to :user
  belongs_to :wheel_prize

  def expired?
    interval_day = (Time.zone.today - created_at.to_date).to_i
    interval_day > 30
  end
end
