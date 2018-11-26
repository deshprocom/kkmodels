class WheelUserPrize < ApplicationRecord
  belongs_to :user
  belongs_to :wheel_prize

  def expired?
    interval_day = (Time.zone.today - created_at.to_date).to_i
    interval_day > 30
  end

  def to_used
    update(used: true, used_time: Time.current)
  end

  def pocket_money?
    wheel_prize.face_value.to_i > 0 && prize_type.eql?('cheap')
  end
end
